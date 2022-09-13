import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

import '../../../app/app.locator.dart';
import '../../../exceptions/mapviewmodel_expection.dart';
import '../../../services/afk_markers_positions_services/afk_markers_positions_service.dart';

class HikeQuestViewModel extends ActiveQuestBaseViewModel
    with MapStateControlMixin {
  /// If user enters an area, the following AFKMarker will be set that corresponds to the marker.
  /// If the user walks outside the area (geofence) (+ some extra buffer zone)
  /// the marker is set to null again (after some time delay to avoid multiple dialogs
  /// that open because location events were fired in the background
  /// while the first dialog was open)
  /// If null: allow to show alert dialog when user enters geofence
  /// If not null: don't show alert dialog on additional location listener events
  /// @see checkIfInAreaOfMarker()
  AFKMarker? markerInArea;

  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;

  // UI state
  String mapStyle = "";
  bool isAnimatingCamera = false;
  bool validatingMarkerInArea = false;

  final afkMarkersPositionsServices = locator<AFKMarkersPositionService>();

  // -------------------------------------------------
  // initialize
  @override
  Future initialize({required Quest quest}) async {
    log.i("Initializing active map quest of tye: ${quest.type}");
    resetPreviousQuest();
    setBusy(true);
    await super.initialize(quest: quest);
    setBusy(false);
    notifyListeners();
  }

  Future maybeStartQuest(
      {required Quest? quest, void Function()? onStartQuestCallback}) async {
    if (quest != null && !hasActiveQuest) {
      final result =
          await startQuestMain(quest: quest, countStartMarkerAsCollected: true);
      if (result == false) {
        log.wtf("Not starting quest, due to an unknown reason");
        return;
      }
      // quest started
      //if (quest.type != QuestType.GPSAreaHike) {
      // Notifications().createPermanentNotification(
      //     title: "Hike quest ongoing", message: "Collect all markers.");
      activeQuestService.listenToPosition(
        distanceFilter: kDistanceFilterHikeQuest,
        pushToNotion: true,
        viewModelCallback: (userLivePosition) async {
          // ! this only ever checks the "next" marker
          // ! that is only really defined if the checkpoints are ordered!
          // ! Need to have a method in place that allows some freedom here.
          checkIfInAreaOfMarker(
              marker: activeQuestService.getNextMarker(),
              position: userLivePosition);
        },
      );

      //}
      notifyListeners();
      //resetSlider();
    }
  }

  Future checkIfInAreaOfMarker(
      {required AFKMarker? marker, required Position position}) async {
    if (marker != null) {
      if (marker.lat != null && marker.lon != null) {
        double distance =
            geolocationService.distanceBetweenPositionAndCoordinates(
          position: position,
          lat: marker.lat!,
          lon: marker.lon!,
        );
        bool isInAreaNow = distance < kDistanceFromCenterOfArea;
        if (isInAreaNow && markerInArea == null) {
          //isInAreaOfMarker = true;
          markerInArea = marker;
          log.i("User in area of marker!");
          questTestingService.maybeRecordData(
            trigger: QuestDataPointTrigger.liveQuestUICallback,
            position: position,
            pushToNotion: true,
            userEventDescription: "in area of marker",
          );
          if (currentQuest?.type == QuestType.QRCodeHike ||
              currentQuest?.type == QuestType.GPSAreaHike) {
            vibrateAlert();
            activeQuestService.pausePositionListener();
            final result = await showQrCodeIsInAreaDialog();

            if (result?.confirmed == false) {
              log.i(
                  "Did close the area alert dialog without having fetched the marker");
              // this allows to show the dialog again!
              // but only after a certain dead time.
              // The dead time avoids additional dialogs appear immediately
              // after closing the first one when marker was NOT collected.
              // (cause of location listener events fired in the background
              // WHILE the dialog was open)
              Future.delayed(Duration(seconds: 4), () {
                //isInAreaOfMarker = false;
                markerInArea = null;
              });
            }
            activeQuestService.resumePositionListener();
          }
        }
        // apply a tolerance of 10 meters here to mark the user as NOT in area.
        // Useful when, because of bad gps accuracy, the user is "jumping" in and out
        // of the geofence.
        else if (!isInAreaNow &&
            markerInArea != null &&
            (distance > (kDistanceFromCenterOfArea + 10))) {
          log.i("Outside of the area again");
          markerInArea = null;
        }
      }
    }
  }

  Future showQrCodeIsInAreaDialog() async {
    if (currentQuest?.type == QuestType.QRCodeHike) {
      return await dialogService.showCustomDialog(
        variant: DialogType.QrCodeInArea,
        data: {
          "function": scanQrCode,
        },
      );
    } else if (currentQuest?.type == QuestType.GPSAreaHike) {
      return await dialogService.showCustomDialog(
        variant: DialogType.CheckpointInArea,
        data: {
          "function": () async {
            return await collectMarkerFromGPSLocation();
          }
        },
      );
    } else {
      log.wtf("Unknown quest type");
      //showGenericInternalErrorDialog();
    }
  }

  Future collectMarkerFromGPSLocation() async {
    if (await maybeCheatAndCollectNextMarker()) {
      return;
    }

    validatingMarkerInArea = true;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 500));
    validatingMarkerInArea = false;
    notifyListeners();
    if (!hasActiveQuest) {
      await dialogService.showDialog(
          title: "Start the quest to collect markers");
      return;
    }
    // if ((flavorConfigProvider.allowDummyMarkerCollection &&
    //     !flavorConfigProvider.enableGPSVerification)) {
    //   markerInArea = activeQuestService.getNextMarker();
    // }
    if (markerInArea == null) {
      await dialogService.showDialog(
        title: "Cannot collect marker!",
        description: "You are not in the area of a checkpoint!",
      );
      return;
    }
    MarkerAnalysisResult markerResult =
        await activeQuestService.analyzeMarker(marker: markerInArea);
    return await handleMarkerAnalysisResult(markerResult);
  }

  String getNumberMarkersCollectedString() {
    if (activeQuestService.hasActiveQuest) {
      // minus one because start marker is counted as collected from the start!
      return (numMarkersCollected - 1).toString() +
          " / " +
          (activeQuest.markersCollected.length - 1).toString();
    } else {
      return "0";
    }
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    log.i("Handling marker analysis result");
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return false;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      // if (result.errorType != MarkerCollectionFailureType.alreadyCollected) {
      await dialogService.showDialog(
        title: "Can't collect marker!",
        description: result.errorMessage!,
      );
      // }
      return false;
    } else {
      if (!hasActiveQuest && result.quests == null) {
        await dialogService.showDialog(
            title:
                "The scanned marker is not a start of a quest. Please go to the starting point");
        return false;
      }

      if (result.marker != null) {
        if (hasActiveQuest) {
          log.i("Scanned marker sucessfully collected!");
          await handleCollectedMarkerEvent(afkmarker: result.marker!);
        }
        return true;
      }

      if (result.quests != null && result.quests!.length > 0) {
        // TODO: Handle case where more than one quest is returned here!
        // For now, just start first quest!
        if (!hasActiveQuest) {
          log.i("Found quests associated to the scanned start marker.");
          await displayQuestBottomSheet(
            quest: result.quests![0],
            startMarker: result.quests![0].startMarker,
          );
        }
      }
      return false;
    }
  }

  Future handleCollectedMarkerEvent({required AFKMarker afkmarker}) async {
    if (hasActiveQuest == true) {
      questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        pushToNotion: true,
        userEventDescription:
            "collected marker " + getNumberMarkersCollectedString(),
      );

      // Move this to isQuestCompleted function and remove stuff from service!
      if (isQuestCompleted()) {
        await showCollectedMarkerDialog();
        handleQuestCompletedEvent(afkmarker: afkmarker);
        return;
      } else {
        // animate camera to preview next marker
        animateCameraToPreviewNextMarker();
      }
    } else {
      dialogService.showDialog(
          title: "Quest Not Running",
          description: "Verify Your Quest Because is not running");
    }
  }

  Future handleQuestCompletedEvent({required AFKMarker afkmarker}) async {
    //checkQuestAndFinishWhenCompleted();
    isAnimatingCamera = true;
    setBusy(true);
    mapViewModel.updateMapDisplay(afkmarker: afkmarker);
    await animateCameraToQuestMarkers();
    questFinished = true;
    activeQuestService.setSuccessAsQuestStatus();

    CollectCreditsStatus collectCreditsStatus = CollectCreditsStatus.todo;
    try {
      // Upload quest but give it some time 4 seconds while the camera is animating
      // for some sweet UX experience
      final results = await Future.wait(
        [
          handleSuccessfullyFinishedQuest(showDialogs: false),
          Future.delayed(Duration(milliseconds: 2000))
        ],
      );
      collectCreditsStatus = results[0];
    } catch (e) {
      log.e(e);
      showGenericInternalErrorDialog();
      collectCreditsStatus = CollectCreditsStatus.todo;
    }

    setBusy(false);
    // quest succesfully completed
    await showSuccessDialog(collectCreditsStatus: collectCreditsStatus);
  }

  @override
  void resetPreviousQuest() {
    validatingMarkerInArea = false;
    isAnimatingCamera = false;
    markerInArea = null;
    activeQuestService.questCenteredOnMap = true;
    super.resetPreviousQuest();
  }

  void showInfoWindowOfNextMarker({Quest? quest, AFKMarker? marker}) async {
    if (quest == null && marker == null) return;
    late MarkerId markerId;
    if (quest != null) {
      if (quest.markers.length > 1) {
        markerId = MarkerId(quest.markers[1].id);
      }
    }
    if (marker != null) {
      markerId = MarkerId(marker.id);
    }
    try {
      Future.delayed(
        Duration(seconds: marker != null ? 0 : 1),
        () {
          mapViewModel.showMarkerInfoWindowNow(markerId: marker?.id);
        },
      );
    } catch (e) {
      log.e(
          "This is a weird error from google maps when showing the marker info: $e");
      log.wtf(
          "We tried to circumvent it with a delay and didn't bother about it any longer");
      return;
    }
  }

  Future animateCameraToPreviewNextMarker() async {
    log.i("Animate camera to preview next marker");
    isAnimatingCamera = true;
    notifyListeners();

    AFKMarker? nextMarker = activeQuestService.getNextMarker();
    AFKMarker? previousMarker = activeQuestService.getPreviousMarker();
    if (nextMarker != null &&
        nextMarker.lat != null &&
        nextMarker.lon != null &&
        previousMarker != null &&
        previousMarker.lat != null &&
        previousMarker.lon != null) {
      await mapViewModel.animateNewLatLon(
          lat: previousMarker.lat!, lon: previousMarker.lon!);
      await showCollectedMarkerDialog();
      await Future.delayed(Duration(milliseconds: 600));
      mapViewModel.updateMapDisplay(afkmarker: previousMarker);
      triggerCollectedMarkerAnimation();
      await Future.delayed(Duration(milliseconds: 600));
      await mapViewModel.animateNewLatLon(
          lat: nextMarker.lat!, lon: nextMarker.lon!);
      if (currentQuest?.type == QuestType.GPSAreaHike) {
        await Future.delayed(Duration(milliseconds: 400));
        addNextArea(marker: nextMarker);
        addNextMarker(marker: nextMarker);
        showInfoWindowOfNextMarker(marker: nextMarker);
        await mapViewModel.animateNewLatLonZoomDelta(
            lat: nextMarker.lat!, lon: nextMarker.lon!, deltaZoom: 1);
        await Future.delayed(Duration(milliseconds: 400));
      } else {
        if (currentQuest!.type == QuestType.QRCodeHike) {
          await Future.delayed(Duration(milliseconds: 600));
          showInfoWindowOfNextMarker(marker: nextMarker);
          await Future.delayed(Duration(milliseconds: 600));
        } else {
          await Future.delayed(Duration(milliseconds: 1200));
        }
      }
      await mapViewModel.animateCameraToBetweenCoordinates(
        latLngList: [
          [previousMarker.lat!, previousMarker.lon!],
          [nextMarker.lat!, nextMarker.lon!],
        ],
      );
    }
    await Future.delayed(Duration(milliseconds: 600));
    if (currentQuest?.type == QuestType.GPSAreaHike ||
        currentQuest?.type == QuestType.GPSAreaHunt) {
      await Future.delayed(Duration(milliseconds: 600));
    }
    isAnimatingCamera = false;
    notifyListeners();
    if (currentQuest?.type == QuestType.GPSAreaHike ||
        currentQuest?.type == QuestType.GPSAreaHunt) {
      dialogService.showDialog(
          title: "New checkpoint spotted!", description: "Find next location!");
    } else {
      snackbarService.showSnackbar(
          title: "Let's go", message: "The next marker is waiting!");
    }
  }

  void addNextArea({Quest? quest, AFKMarker? marker}) {
    AFKMarker? actualMarker =
        marker ?? activeQuestService.getNextMarker(quest: quest);
    if (actualMarker != null) {
      mapViewModel.addAreaToMap(
          quest: quest ?? activeQuest.quest, afkmarker: actualMarker);
    }
    notifyListeners();
  }

  void addNextMarker({Quest? quest, AFKMarker? marker}) {
    AFKMarker? actualMarker =
        marker ?? activeQuestService.getNextMarker(quest: quest);
    if (actualMarker != null) {
      mapViewModel.addMarkerToMap(
          quest: quest ?? activeQuest.quest,
          afkmarker: actualMarker,
          handleMarkerAnalysisResultCustom: handleMarkerAnalysisResult);
    }
    notifyListeners();
  }

  void maybeAddFinishMarker({AFKMarker? marker}) {
    if (marker == null) return;
    if (activeQuestService.isFinishMarker(marker)) {
      // TODO: See what Finish marker makes different!
      mapViewModel.addMarkerToMap(
          quest: activeQuest.quest,
          afkmarker: marker,
          handleMarkerAnalysisResultCustom: handleMarkerAnalysisResult);
    }
  }

  void triggerCollectedMarkerAnimation() {
    showCollectedMarkerAnimation = true;
    notifyListeners();
  }

  // Future animateToUserPosition(GoogleMapController? controller) async {
  //   if (controller == null) return;
  //   await controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //           target: LatLng(
  //               geolocationService.getUserLivePositionNullable!.latitude,
  //               geolocationService.getUserLivePositionNullable!.longitude),
  //           zoom: await controller.getZoomLevel()),
  //     ),
  //   );
  //   questCenteredOnMap = false;
  //   notifyListeners();
  // }

  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker,
      required Quest? quest,
      bool isFinishMarker = false}) {
    if (hasActiveQuest) {
      final index = activeQuest.quest.markers
          .indexWhere((element) => element == afkmarker);
      if (!activeQuest.markersCollected[index]) {
        if (!isFinishMarker) {
          return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        } else {
          // finish marker gets different icon
          return BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange);
        }
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      }
    } else {
      if (quest?.type == QuestType.QRCodeHike) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      } else if (quest?.type == QuestType.TreasureLocationSearch) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      }
    }
  }

  @override
  bool isQuestCompleted() {
    return activeQuestService.isAllMarkersCollected;
  }

  @override
  dispose() {
    resetPreviousQuest();
    _googleMapController?.dispose();
    super.dispose();
  }
  /////// New Code **************

}
