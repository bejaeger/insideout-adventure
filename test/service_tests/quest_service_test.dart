import 'dart:math';

import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_data/test_constants.dart';
import '../test_data/test_datamodels.dart';
import '../helpers/test_helpers.dart';

QuestService _getService() => QuestService();

void main() {
  group('QuestServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    /////////////////////////////////////////////
    group('Initialization -', () {
      test('When service is initialized activated quest needs to be null', () {
        final service = _getService();
        expect(service.activatedQuest, isNull);
      });
    });

    ///////////////////////////////////////////////
    group('startQuest -', () {
      test('When quest is started we start the timer', () async {
        final stopWatch = getAndRegisterStopWatchService();
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        verify(stopWatch.startTimer());
      });

      test('When quest is started we setup our data tracking listener',
          () async {
        final stopWatch = getAndRegisterStopWatchService();
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        verify(stopWatch.listenToSecondTime(callback: service.trackData));
      });

      test(
          'When quest is started we should have an activated quest corresponding to the quest that was started',
          () async {
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        expect(service.activatedQuest, getTestActivatedQuest());
      });
    });

    //////////////////////////////////////////////////////
    group('evaluateQuest -', () {
      test('When not all markers were collected, mark quest as incomplete', () {
        // arrange
        final service = _getService();
        service.pushActivatedQuest(getTestActivatedButIncompleteQuest());
        // act
        service.evaluateQuest();
        // assert
        expect(service.activatedQuest?.status, QuestStatus.incomplete);
      });

      test('When not all markers were collected, mark quest as success', () {
        // arrange
        final service = _getService();
        service.pushActivatedQuest(getTestActivatedAndCompleteQuest());
        // act
        service.evaluateQuest();
        // assert
        expect(service.activatedQuest?.status, QuestStatus.success);
      });
    });

    //////////////////////////////////////////////
    group('finishQuest -', () {
      test(
          'When quest is finished need to stop the timer, pause the listener, and get the time once more',
          () async {
        // arrange
        final stopWatchService = getAndRegisterStopWatchService();

        when(stopWatchService.getSecondTime()).thenReturn(100);

        //act
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        await service.evaluateAndFinishQuest();

        //assert
        verify(stopWatchService.stopTimer());
        verify(stopWatchService.pauseListener());
        verify(stopWatchService.getSecondTime());
      });

      test(
          'When quest is finished succesfully we want to reset the timer and cancel the stopwatch listener',
          () async {
        // arrange
        final stopWatchService = getAndRegisterStopWatchService();

        //act
        final service = _getService();
        service.pushActivatedQuest(getTestSuccessQuest());
        await service.evaluateAndFinishQuest();

        //assert
        verify(stopWatchService.resetTimer());
        verify(stopWatchService.cancelListener());
      });

      test(
          'When quest is finished successsfully save quest to database with status finished',
          () async {
        final firestoreApi = getAndRegisterFirestoreApi();
        final service = _getService();
        service.pushActivatedQuest(getTestSuccessQuest());
        await service.evaluateAndFinishQuest();
        verify(firestoreApi.pushFinishedQuest(quest: anyNamed("quest")));
      });

      test('When quest is incomplete return string with warning', () async {
        final service = _getService();
        // this basically mocks out the evaluateQuest function!
        service.pushActivatedQuest(getTestIncompleteQuest());
        expect(await service.evaluateAndFinishQuest(), WarningQuestNotFinished);
      });

      test('After quest is finished activated quest should be null', () async {
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        service.pushActivatedQuest(getTestSuccessQuest());
        await service.evaluateAndFinishQuest();
        expect(service.activatedQuest, isNull);
      });
    });

    group('continueIncompleteQuest -', () {
      test(
          'When quest is continued, timer need to start again and status needs to be made active again',
          () {
        // arrange
        final stopWatchService = getAndRegisterStopWatchService();
        final service = _getService();
        service.pushActivatedQuest(getTestIncompleteQuest());

        // act
        service.continueIncompleteQuest();

        // assert
        verify(stopWatchService.startTimer());
        verify(stopWatchService.resumeListener());
        expect(service.activatedQuest?.status, QuestStatus.active);
      });
    });

    group('trackData -', () {
      test(
          'when trackData is called after MaxQuestTime the tracking should stop',
          () async {
        // arrange
        final stopWatchService = getAndRegisterStopWatchService();
        final firestoreApi = getAndRegisterFirestoreApi();
        final service = _getService();
        service.pushActivatedQuest(getTestSuccessQuest());

        // act
        await service.trackData(kMaxQuestTimeInSeconds);

        // assert
        verify(firestoreApi.pushFinishedQuest(quest: anyNamed("quest")));
        verify(stopWatchService.resetTimer());
        verify(stopWatchService.cancelListener());
      });
    });

    group('verifyAndUpdateCollectedMarkers -', () {
      test(
          'when called, a check needs to be performed whether the user is close to the marker',
          () async {
        // arrange
        final markerService = getAndRegisterMarkerService();
        // act
        final service = _getService();
        service.pushActivatedQuest(getTestActivatedButIncompleteQuest());
        await service.verifyAndUpdateCollectedMarkers(marker: getTestMarker1());
        // assert
        verify(markerService.isUserCloseby(marker: getTestMarker1()));
      });

      test(
          'when called and marker not in quest, return string with error message',
          () async {
        // arrange
        final service = _getService();
        service.pushActivatedQuest(getTestActivatedButIncompleteQuest());
        // assert & act
        expect(
            await service.verifyAndUpdateCollectedMarkers(
                marker: getTestMarker4()),
            isA<String>());
      });

      // ! This test is currently failing because we still use dummy data here!
      test(
          'when called and user is not nearby marker, return string with error message',
          () async {
        // arrange
        // act
        final service = _getService();
        service.pushActivatedQuest(getTestActivatedButIncompleteQuest());
        // assert
        expect(
            await service.verifyAndUpdateCollectedMarkers(
                marker: getTestMarker1()),
            isA<String>());
      });
    });

    group('isMarkerInQuest -', () {
      test('Return true if it belongs to the currently active quest', () {
        // arrange
        final service = _getService();
        // act
        service.pushActivatedQuest(getTestActivatedButIncompleteQuest());
        // assert
        expect(service.isMarkerInQuest(marker: getTestMarker2()), true);
      });

      test('Return false when it doesn\'t belong to the currently active quest',
          () {
        final service = _getService();
        service.pushActivatedQuest(getTestActivatedButIncompleteQuest());
        expect(service.isMarkerInQuest(marker: getTestMarker4()), false);
      });
    });

    group('updateCollectedMarkers -', () {
      test(
          'When the second marker is succesfully scanned it needs to be reflected in the activated quest model',
          () async {
        // arrange
        final service = _getService();
        service.pushActivatedQuest(getTestActivatedButIncompleteQuest());
        // act
        service.updateCollectedMarkers(marker: getTestMarker2());
        // assert
        expect(service.activatedQuest?.markersCollected[1], true);
      });
    });

    //--------------------------------------------
    // Marker scanning

    group('handleQrCodeScan -', () {
      test(
          'If no quest is present, download quest associated to that marker and prompt user with start quest dialog',
          () async {
        // arrange
        final firestoreApi = getAndRegisterFirestoreApi();
        when(firestoreApi.getQuestsWithStartMarkerId(
                startMarkerId: kTestMarker1Id))
            .thenAnswer((_) async => [getTestQuest()]);
        // act
        final service = _getService();
        service.handleQrCodeScan(qrCodeString: kTestMarker1QrCodeString);
        // assert
        verify(firestoreApi.getQuestsWithStartMarkerId(
            startMarkerId: kTestMarker1Id));
      });

      test(
          'If a quest is active and the scanned marker is present in activatedQuest, should call isUserCloseBy',
          () async {
        // arrange
        final markerService = getAndRegisterMarkerService();
        // act
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        service.handleQrCodeScan(qrCodeString: kTestMarker1QrCodeString);
        // assert
        verify(markerService.isUserCloseby(marker: getTestMarker1()));
      });

      test(
          'If a quest is active and the scanned marker is the first marker in activatedQuest marker should be collected',
          () async {
        // arrange
        getAndRegisterQRCodeService(marker: getTestMarker1());
        // act
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        await service.handleQrCodeScan(qrCodeString: kTestMarker1QrCodeString);
        // assert
        expect(service.activatedQuest!.markersCollected[0], true);
        expect(service.activatedQuest!.markersCollected[1], false);
        expect(service.activatedQuest!.markersCollected[2], false);
      });

      test(
          'If a quest is active and the scanned marker is the second marker in activatedQuest marker should be collected',
          () async {
        // arrange
        getAndRegisterQRCodeService(marker: getTestMarker2());
        // act
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        await service.handleQrCodeScan(qrCodeString: kTestMarker2QrCodeString);
        // assert
        expect(service.activatedQuest!.markersCollected[0], false);
        expect(service.activatedQuest!.markersCollected[1], true);
        expect(service.activatedQuest!.markersCollected[2], false);
      });

      test(
          'If a quest is active and the scanned marker is not in activatedQuest, return error',
          () async {
        // arrange
        getAndRegisterQRCodeService(marker: getTestMarkerFarAway());
        // act
        final service = _getService();
        await service.startQuest(quest: getTestQuest());
        QuestQRCodeScanResult result = await service.handleQrCodeScan(
            qrCodeString: kTestMarkerFarAwayQrCodeString);
        // assert
        expect(result.errorMessage, WarningScannedMarkerNotInQuest);
      });
    });

    group('getMarkerFromQrCodeString -', () {
      test('Return marker with actual coordinates looked up at in our database',
          () async {
        // arrange
        final firestoreApi = getAndRegisterFirestoreApi();
        // act
        final service = _getService();
        await service.getMarkerFromQrCodeId(qrCodeId: kTestMarker1QrCodeId);
        // assert
        verify(
          await firestoreApi.getMarkerFromQrCodeId(
              qrCodeId: kTestMarker1QrCodeId),
        );
      });
    });
  });
}
