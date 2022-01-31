import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_viewmodel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActiveMapQuestViewModel extends MapViewModel {
  @override
  Future initialize({required Quest quest}) async {
    resetPreviousQuest();
    setBusy(true);
    await super.initialize(quest: quest);
    await rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
    setBusy(false);

    addMarkers(quest: quest);
    if (quest.type == QuestType.QRCodeHike) {
      addAreas(quest: quest);
    } else if (quest.type == QuestType.GPSAreaHike) {
      addNextArea(quest: quest);
    } else {
      log.e("Code will crash, unknown quest type");
      return;
    }
    addStartMarkerToMap(quest: quest, afkmarker: quest.startMarker!);
    addStartAreaToMap(quest: quest, afkmarker: quest.startMarker!);
    notifyListeners();
  }

  void addStartMarkers({required Quest quest}) {
    for (AFKMarker _m in quest.markers) {
      addMarkerToMap(quest: quest, afkmarker: _m);
    }
    // notifyListeners();
  }

  void addMarkers({required Quest quest}) {
    for (AFKMarker _m in questService.markersToShowOnMap(questIn: quest)) {
      addMarkerToMap(quest: quest, afkmarker: _m);
    }
    // notifyListeners();
  }

  void addAreas({required Quest quest}) {
    for (AFKMarker _m in questService.markersToShowOnMap(questIn: quest)) {
      addAreaToMap(quest: quest, afkmarker: _m);
    }
    // notifyListeners();
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null && !hasActiveQuest) {
      final result =
          await startQuestMain(quest: quest, countStartMarkerAsCollected: true);
      if (result == false) {
        log.wtf("Not starting quest, due to an unknown reason");
        resetSlider();
        return;
      }
      // quest started
      if (quest.type != QuestType.GPSAreaHike) {
        questService.listenToPosition(
          distanceFilter: kDistanceFilterHikeQuest,
          pushToNotion: true,
          viewModelCallback: (userLivePosition) async {
            // ! this only ever checks the "next" marker
            // ! that is only really defined if the checkpoints are ordered!
            // ! Need to have a method in place that allows some freedom here.
            checkIfInAreaOfMarker(
                marker: questService.getNextMarker(),
                position: userLivePosition);
          },
        );
      }
      await Future.delayed(Duration(seconds: 1));
      showStartSwipe = false;
      notifyListeners();
      //resetSlider();
    }
  }

  /// If user enters an area, the following AFKMarker will be set that corresponds to the marker.
  /// If the user walks outside the area (geofence) (+ some extra buffer zone)
  /// the marker is set to null again (after some time delay to avoid multiple dialogs
  /// that open because location events were fired in the background
  /// while the first dialog was open)
  /// If null: allow to show alert dialog when user enters geofence
  /// If not null: don't show alert dialog on additional location listener events
  AFKMarker? markerInArea;
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
            userEventDescription: "in area of qrcode",
          );
          vibrateAlert();
          questService.pausePositionListener();
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
          questService.resumePositionListener();
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
      showGenericInternalErrorDialog();
    }
  }

  Future collectMarkerFromGPSLocation() async {
    if (!hasActiveQuest) {
      await dialogService.showDialog(
          title: "Start the quest to collect markers");
      return;
    }
    if (markerInArea == null) {
      await dialogService.showDialog(
        title: "Can't collect marker!",
        description: "You are not in the area of a marker",
      );
      return;
    }
    MarkerAnalysisResult markerResult =
        await questService.analyzeMarker(marker: markerInArea);
    return await handleMarkerAnalysisResult(markerResult);
  }

  @override
  void resetPreviousQuest() {
    //isInAreaOfMarker = false;
    markerInArea = null;
    super.resetPreviousQuest();
  }
}
