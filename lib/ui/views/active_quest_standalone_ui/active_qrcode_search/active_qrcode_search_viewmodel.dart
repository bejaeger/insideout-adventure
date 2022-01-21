import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:afkcredits/app/app.logger.dart';

class ActiveQrCodeSearchViewModel extends ActiveQuestBaseViewModel {
  final MarkerService _markerService = locator<MarkerService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();

  List<AFKMarker> foundObjects = [];
  int indexHint = 0;
  bool? closeby;
  bool animateProgress = false;
  bool displayNewHint =
      true; // bool to check whether hint should be displayed or not!
  final log = getLogger("ActiveQrCodeSearchViewModel");

  void initializeMapAndMarkers({required Quest quest}) async {
    resetPreviousQuest();
    runBusyFuture(_geolocationService.getAndSetCurrentLocation());
    closeby = await _markerService.isUserCloseby(marker: quest.startMarker);
    notifyListeners();
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (!hasEnoughSponsoring(quest: quest)) {
      return null;
    }
    if (quest != null && !hasActiveQuest) {
      resetPreviousQuest();
      log.i("Maybe starting Qr code search quest with name ${quest.name}");
      //setBusy(true);
      final position = await _geolocationService.getAndSetCurrentLocation();

      if (quest.type != QuestType.QRCodeSearchIndoor &&
          quest.type != QuestType.QRCodeHuntIndoor) {
        if (!(await checkAccuracy(position: position))) {
          resetSlider();
          return false;
        }
      }
      final result = await startQuestMain(quest: quest);
      if (result is bool && result == true) {
        // adding start marker as it contains the first hint and
        // is only used to bring the user to the screen with the active quest UI
        foundObjects.add(quest.markers[0]);
        // this might be redundant. Could also use 'handleQrCodeScanEvent' in questService
        // which performs geolocation verification!
        questService.updateCollectedMarkers(marker: quest.markers[0]);

        await Future.delayed(Duration(seconds: 1));
        showStartSwipe = false;
        displayNewHint = true;
        notifyListeners();
      } else {
        log.wtf("Not starting quest, due to an unknown reason");
      }
      resetSlider();

      //setBusy(false);
      // if (result is bool && result == false) {
      //   navigateBack();
      // } else {}
    } else {
      log.w("Not starting quest, quest is probably already running");
    }
  }

  // Retrieve current hint which is attached to the previously collected marker.
  // This means it is simply the last object of foundObjects!
  String getCurrentHint() {
    if (!hasActiveQuest) {
      // return "Start the quest above to see the first hint";
      return "Starte um den ersten Hinweis zu sehen";
    } else {
      if (activeQuest.quest.markerNotes != null) {
        if (foundObjects.length < activeQuest.quest.markerNotes!.length) {
          return activeQuest.quest.markerNotes![foundObjects.length].note;
        } else {
          return "Kein Hinweis mehr übrig";
        }
      } else {
        return "No hint for this round, sorry! You are on your own...";
      }
    }
  }

  // Retrieve current hint which is attached to the previously collected marker.
  // This means it is simply the last object of foundObjects!
  void getNextHint() {
    if (foundObjects.length >= indexHint + 1) {
      indexHint = indexHint + 1;
      notifyListeners();
    }
  }

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker? afkmarker}) {
    if (afkmarker == null) return;
    markersOnMap.add(
      Marker(
          markerId: MarkerId(afkmarker
              .id), // google maps marker id of start marker will be our quest id
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
          infoWindow: InfoWindow(snippet: foundObjects.length.toString()),
          icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
          onTap: () async {
            bool adminMode = false;
            if (isSuperUser) {
              adminMode = await showAdminDialogAndGetResponse();
              if (adminMode) {
                displayMarker(afkmarker);
              }
            }
          }),
    );
    notifyListeners();
  }

  @override
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  @override
  void loadQuestMarkers() {
    // for testing purposes, display location of qr code markers
    if (isSuperUser) {
      for (AFKMarker _m in activeQuest.quest.markers) {
        addMarkerToMap(quest: activeQuest.quest, afkmarker: _m);
      }
    }

    // TODO:
    // This should be used to specify an area on the map that should
    // be searched through for markers!
    return;
  }

  @override
  bool isQuestCompleted() {
    return questService.isAllMarkersCollected;
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    if (!hasActiveQuest) {
      log.wtf("No quest running");
      dialogService.showDialog(title: "Please start the quest first");
      return;
    }
    if (result.marker != null) {
      if (hasActiveQuest) {
        log.i("Scanned marker sucessfully collected!");
        // add scanned marker on map!
        addMarkerToMap(quest: activeQuest.quest, afkmarker: result.marker!);

        // this might be redundant as this is also taken care of in quest service
        // maybe we should remove the version in the service though!
        foundObjects.add(result.marker!);

        final bool completed = isQuestCompleted();
        if (completed) {
          await showCollectedMarkerDialog();
          // TODO: Show successfully finished quest!
          await showSuccessDialog();
          return;
          // checkQuestAndFinishWhenCompleted();
        } else {
          await showCollectedMarkerDialog();
          log.i("After show collected marker dialog view!");
          animateProgress = true;
          displayNewHint = false;
          // if (result.marker!.nextLocationHint != null)
          //   await dialogService.showDialog(
          //       title: "Next hint",
          //       description: result.marker!.nextLocationHint!);
        }
        // possibleToGetNextHint = true;
        notifyListeners();
      }
    }
  }

  void setDisplayNewHint(bool set) {
    displayNewHint = set;
    notifyListeners();
  }

  // -------------------------------------
  @override
  void resetPreviousQuest() {
    markersOnMap = {};
    foundObjects = [];
    animateProgress = false;
    displayNewHint = true;
    super.resetPreviousQuest();
  }
}
