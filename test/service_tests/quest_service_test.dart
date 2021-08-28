import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/datamodel_helpers.dart';
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
        service.pushActivatedQuest(getTestFinishedQuest());
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
        service.pushActivatedQuest(getTestFinishedQuest());
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
        service.pushActivatedQuest(getTestFinishedQuest());
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
        service.pushActivatedQuest(getTestFinishedQuest());
        // act
        await service.trackData(kMaxQuestTimeInSeconds);
        // assert
        verify(firestoreApi.pushFinishedQuest(quest: anyNamed("quest")));
        verify(stopWatchService.resetTimer());
        verify(stopWatchService.cancelListener());
      });
    });
  });
}
