import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ActiveVibrationSearchQuestViewModel extends QuestViewModel {
  final GeolocationService _geolocationService = locator<GeolocationService>();
  double? get currentGPSAccuracy => _geolocationService.currentGPSAccuracy;
  StreamSubscription? _activeVibrationQuestSubscription;
  String directionStatus = "Start Walking";
  bool isTrackingDeadTime = false;
  bool skipUpdatingQuestStatus = false;
  final MarkerService _markerService = locator<MarkerService>();

  bool? closeby;

  void initialize({required Quest? quest}) async {
    if (quest != null) {
      closeby = await _markerService.isUserCloseby(marker: quest.startMarker);
      notifyListeners();
    }
  }

  // AUTOMATIC TRACKING
  void listenToActiveQuest() {
    log.i("Add listener to active vibration search quest");
    if (_activeVibrationQuestSubscription == null) {
      _activeVibrationQuestSubscription =
          questService.activatedQuestSubject.listen(
        (activatedQuest) {
          log.wtf("Listening to quest update");
          if (activatedQuest?.status == QuestStatus.active ||
              activatedQuest?.status == QuestStatus.incomplete) {
            if (!skipUpdatingQuestStatus) {
              reactToActivatedQuestChange();
              skipUpdatingQuestStatus = false;
            }
          }
          if (activatedQuest?.status == QuestStatus.success ||
              activatedQuest?.status == QuestStatus.cancelled ||
              activatedQuest?.status == QuestStatus.failed) {
            cancelQuestListener();
          }
          notifyListeners();
        },
      );
    }
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null) {
      resetPreviousQuest();
      log.i("Starting vibration search quest with name ${quest.name}");
      listenToActiveQuest();
      setBusy(true);
      final result = await startQuestMain(
          quest: quest, periodicFuncFromViewModel: periodicUpdate);
      setBusy(false);
      if (result == false) {
        navigateBack();
      }
    } else {
      log.i("Not starting quest, quest is probably already running");
    }
  }

  Future reactToActivatedQuestChange() async {
    if (activeQuest.lastDistanceInMeters == null ||
        activeQuest.currentDistanceInMeters == null) {
      lastActivatedQuestInfoText = "Start Walking and search for the Trophy!";
    } else {
      // if (activeQuest.currentDistanceInMeters! <
      //     kMinDistanceToCatchTrophyInMeters) {
      /// Cheat version here
      ///
      if (activeQuest.currentDistanceInMeters! <
          kMinDistanceToCatchTrophyInMeters) {
        // DUMMY
        // if (activeQuest.currentDistanceInMeters! < 9999) {
        // This should collect the NEXT marker!!

        // TODO: Make this proper here!
        // Show loading screen, show that the quest is gonna be pushed!
        // ! (What if there is no data connection? Sill need to be able to push the data later on!)

        // This will show a dialog from a viewmodel that is not attached to a view!
        // need to think of something better here!
        // - Maybe when starting a quest from a map we can navigate with an argument that STARTS a quest
        // this would give the authority to the quest model that is actually the active quest
        // - OR: have quest_viewmodel as singleton!
        // - OR: move everything that is here to active_quest_viewmodel and extend to active_quest_viewmodel and make this a singleton!
        questService.setAndPushActiveQuestStatus(QuestStatus.success);
        setTrackingDeadTime(true);
        vibrateRightDirection();
        log.i("SUCCESFFULLY FOUND trophy");

        await dialogService.showCustomDialog(
          variant: DialogType.CollectCredits,
          data: activeQuest,
        );
        // await dialogService.showDialog(
        //     title: "SUCCESS!", description: "You found the trophy!");
        setBusy(true);
        setTrackingDeadTime(false);
        final result = await checkQuestAndFinishWhenCompleted();
        // clean -up!
        if (result != false) {
          cancelQuestListener();
        }
        setBusy(false);
        return;
      }
      if (activeQuest.lastDistanceInMeters! >
          activeQuest.currentDistanceInMeters!) {
        await vibrateRightDirection();
        directionStatus = "On last update: getting closer!";
      } else {
        await vibrateWrongDirection();
        directionStatus = "On last update: getting further away!";
      }
      notifyListeners();
    }
  }

  Future vibrateWrongDirection() async {
    await checkCanVibrate();
    if (canVibrate!) {
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 500),
      ];
      log.v("Phone is supposed to vibrate now");
      // vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate
      Vibrate.vibrateWithPauses(pauses);
      Vibrate.feedback(FeedbackType.heavy);
    }
  }

  Future vibrateRightDirection() async {
    // Check if the device can vibrate
    await checkCanVibrate();
    if (canVibrate!) {
      log.v("Phone is supposed to vibrate now");
      // vibrate for default (500ms on android, about 500ms on iphone)
      Vibrate.vibrate();
      Vibrate.feedback(FeedbackType.success);
    }
  }

  Future checkCanVibrate() async {
    if (canVibrate == null) {
      canVibrate = await Vibrate.canVibrate;
      if (canVibrate!) {
        log.i("Phone is able to vibrate");
      } else {
        log.w("Phone is not able to!");
      }
    }
  }

  void resetPreviousQuest() {
    cancelQuestListener();
    directionStatus = "Start Walking";
  }

  Future periodicUpdate(int seconds) async {
    if (questService.activatedQuest != null) {
      ActivatedQuest tmpActivatedQuest = questService.activatedQuest!;
      //void updateTime(int seconds) {

      // set initial data!
      if (seconds == 1) {
        final position = await _geolocationService.getAndSetCurrentLocation();
        tmpActivatedQuest = questService.updateLatLonOnQuest(
            activatedQuest: tmpActivatedQuest,
            newLat: position.latitude,
            newLon: position.latitude);
        final newDistanceInMeters = _geolocationService.distanceBetween(
          lat1: position.latitude,
          lon1: position.longitude,
          lat2: tmpActivatedQuest.quest.finishMarker?.lat,
          lon2: tmpActivatedQuest.quest.finishMarker?.lon,
        );
        tmpActivatedQuest = questService.updateDistanceOnQuest(
            activatedQuest: tmpActivatedQuest,
            newDistance: newDistanceInMeters,
            newLat: position.latitude,
            newLon: position.longitude);
        log.i(
            "Setting initial data for Vibration Search Quest $newDistanceInMeters meters");
        questService.pushActivatedQuest(tmpActivatedQuest);
      }
      bool push = false;
      if (seconds % 3 == 0) {
        if (isTrackingDeadTime) {
          log.v(
              "Skipping distance to goal check because tracking dead time is on");
          return;
        }
        final position = await _geolocationService.getAndSetCurrentLocation();

        if (position.accuracy > kMinRequiredAccuracyVibrationSearch) {
          log.v(
              "Accuracy is ${position.accuracy} and not enough to take next point!");
          return;
        } else {
          setSkipUpdatingQuestStatus(true);
          push = true;
        }

        // check how far user went when last check happened!
        final distanceFromLastCheck = _geolocationService.distanceBetween(
          lat1: tmpActivatedQuest.lastCheckLat,
          lon1: tmpActivatedQuest.lastCheckLon,
          lat2: position.latitude,
          lon2: position.longitude,
        );

        if (distanceFromLastCheck > kMinDistanceFromLastCheckInMeters) {
          // DUMMY
          // if (distanceFromLastCheck > 0) {
          setSkipUpdatingQuestStatus(false);
          push = true;
          // check distance to goal!
          final newDistanceInMeters = _geolocationService.distanceBetween(
            lat1: position.latitude,
            lon1: position.longitude,
            lat2: tmpActivatedQuest.quest.finishMarker?.lat,
            lon2: tmpActivatedQuest.quest.finishMarker?.lon,
          );
          tmpActivatedQuest = questService.updateDistanceOnQuest(
              activatedQuest: tmpActivatedQuest,
              newDistance: newDistanceInMeters,
              newLat: position.latitude,
              newLon: position.longitude);
          log.i("Updating distance to goal to $newDistanceInMeters meters");
          tmpActivatedQuest =
              questService.updateTimeOnQuest(tmpActivatedQuest, seconds);
        } else {
          log.v(
              "Not checking distance to goal, distance from last check: $distanceFromLastCheck");
        }
      }
      if (seconds % 10 == 0) {
        // push = true;
        // every ten seconds
        log.v("quest active since $seconds seconds!");
        // tmpActivatedQuest = trackSomeOtherData(tmpActivatedQuest, seconds);
      }
      if (seconds >= kMaxQuestTimeInSeconds) {
        push = false;
        log.wtf(
            "Cancel quest after $kMaxQuestTimeInSeconds seconds, it was probably forgotten!");
        // TODO: Could also be override function
        await cancelIncompleteQuest();
        return;
      }
      //}
      if (push) {
        questService.pushActivatedQuest(tmpActivatedQuest);
        setTrackingDeadTime(true);
        await Future.delayed(
            Duration(seconds: kDeadTimeAfterVibrationInSeconds));
        if (tmpActivatedQuest.status != QuestStatus.success)
          setTrackingDeadTime(false);
      }
    }
  }

  Future showInstructions() async {
    await dialogService.showDialog(
        title: "How it works",
        description:
            "Start walking and watch the current distance or simply feel the vibrations. Three vibrations means you walk the wrong way! One vibration means you go the correct direction and get closer. Watch out, the trohphy is clever and sometimes moves around!!");
  }

  Future cancelIncompleteQuest() async {
    setTrackingDeadTime(false);
    await questService.cancelIncompleteQuest();
  }

  void setTrackingDeadTime(bool deadTime) {
    log.v("Setting quest data tracking dead time to $deadTime");
    isTrackingDeadTime = deadTime;
  }

  void setSkipUpdatingQuestStatus(bool skipUpdate) {
    log.v("Setting skip react to activated quest change to $skipUpdate");
    skipUpdatingQuestStatus = skipUpdate;
  }

  ///////////////////////////////////////////////////
  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }

  void cancelQuestListener() {
    log.i("Cancelling subscription to vibration search quest");
    _activeVibrationQuestSubscription?.cancel();
    _activeVibrationQuestSubscription = null;
  }

  @override
  void dispose() {
    cancelQuestListener();
    super.dispose();
  }
}
