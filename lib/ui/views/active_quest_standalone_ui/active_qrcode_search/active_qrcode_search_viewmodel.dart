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

  //getters
  bool get firstClueFound => foundObjects.length > 1;

  // UI state
  List<AFKMarker> foundObjects = [];
  int indexClue = 0;
  bool animateProgress = false;
  bool displayNewClue =
      true; // bool to check whether hint should be displayed or not!
  final log = getLogger("ActiveQrCodeSearchViewModel");

  // set of markers and areas on map
  Set<Marker> markersOnMap = {};

  // -------------------------------
  // functions
  @override
  Future initialize({required Quest quest}) async {
    super.initialize(quest: quest);
    resetPreviousQuest();
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
          quest.type != QuestType.QRCodeHunt) {
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

        //await Future.delayed(Duration(seconds: 1));
        showStartSwipe = false;
        displayNewClue = true;
        notifyListeners();
        return;
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

  String getCurrentProgressString() {
    if (currentQuest != null) {
      return hasActiveQuest
          ? (foundObjects.length - 1).toString() +
              " / " +
              (activeQuest.quest.markers.length - 1).toString()
          : "0 / " + currentQuest!.markers.length.toString();
    } else {
      return "";
    }
  }

  // Retrieve current hint which is attached to the previously collected marker.
  // This means it is simply the last object of foundObjects!
  String getCurrentClue() {
    if (!hasActiveQuest) {
      // return "Start the quest above to see the first hint";
      return "Start to see the first clue";
    } else {
      if (activeQuest.quest.markerNotes != null) {
        if (foundObjects.length < activeQuest.quest.markerNotes!.length) {
          return activeQuest.quest.markerNotes![foundObjects.length].note;
        } else {
          return "No clues left";
        }
      } else {
        return "No clue for this round, sorry! You are on your own...";
      }
    }
  }

  // Retrieve current hint which is attached to the previously collected marker.
  // This means it is simply the last object of foundObjects!
  void getNextClue() {
    if (foundObjects.length >= indexClue + 1) {
      indexClue = indexClue + 1;
      notifyListeners();
    }
  }

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
            dynamic adminMode = false;
            if (useSuperUserFeatures) {
              adminMode = await showAdminDialogAndGetResponse();
              if (adminMode == true) {
                displayQrCode(afkmarker);
              }
            }
          }),
    );
    notifyListeners();
  }

  void loadQuestMarkers() {
    // for testing purposes, display location of qr code markers
    if (useSuperUserFeatures) {
      for (AFKMarker _m in activeQuest.quest.markers) {
        addMarkerToMap(quest: activeQuest.quest, afkmarker: _m);
      }
    }

    // TODO:
    // This should be used to specify an area on the map that should
    // be searched through for markers!
    return;
  }

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
      } else if (quest?.type == QuestType.QRCodeSearch) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      }
    }
  }

  @override
  bool isQuestCompleted() {
    return questService.isAllMarkersCollected;
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    // potentially add artificial delay for UX improvement?
    // validatingMarker = true;
    // notifyListeners();
    // await Future.delayed(Duration(seconds: 1));
    // validatingMarker = false;
    // notifyListeners();

    if (!hasActiveQuest) {
      log.wtf("No quest running");
      dialogService.showDialog(title: "Please start the quest first");
      return;
    }
    //
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return false;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      // if (result.errorType != MarkerCollectionFailureType.alreadyCollected) {
      await dialogService.showDialog(
        title: "Cannot collect marker!",
        description: result.errorMessage!,
      );
      // }
      return false;
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
          displayNewClue = false;
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

  void setDisplayNewClue(bool set) {
    displayNewClue = set;
    notifyListeners();
  }

  // -------------------------------------
  @override
  void resetPreviousQuest() {
    markersOnMap = {};
    foundObjects = [];
    animateProgress = false;
    displayNewClue = true;
    super.resetPreviousQuest();
  }
}
