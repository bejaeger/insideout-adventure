import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/hike_quest/hike_quest_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:afkcredits/app/app.logger.dart';

// ! Likely DEPRECATED

//class ActiveQrCodeSearchViewModel extends ActiveQuestBaseViewModel {
class ActiveQrCodeSearchViewModel extends HikeQuestViewModel {
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final bool Function(
      {Future Function() animateCamera,
      bool? flipToMap,
      bool? flipToClue}) flipCard;
  ActiveQrCodeSearchViewModel({required this.flipCard});

  //getters
  bool get firstClueFound => activeQuestService.getNumberMarkersCollected > 1;
  int get getNumberMarkersCollected =>
      activeQuestService.getNumberMarkersCollected;

  // UI state
  List<AFKMarker> get foundObjects => activeQuestService.getCollectedMarkers();
  // List<AFKMarker> foundObjects = [];
  int indexClue = 0;
  bool animateProgress = false;
  bool displayClue =
      true; // bool to check whether hint should be displayed or not!
  bool displayButtonNewClue = false;
  final log = getLogger("ActiveQrCodeSearchViewModel");

  // -------------------------------
  // functions
  @override
  Future initialize({required Quest quest}) async {
    resetPreviousQuest();
    super.initialize(quest: quest);
  }

  Future maybeStartHuntQuest({required Quest? quest}) async {
    displayClue = true;
    await maybeStartQuest(quest: quest);
  }

  bool maybeFlipCardToMap() {
    return flipCard(
        animateCamera: () =>
            animateCameraToQuestMarkers(getGoogleMapController),
        flipToMap: true);
  }

  bool maybeFlipCardToClue() {
    return flipCard(flipToClue: true);
  }

  String getCurrentProgressString() {
    if (currentQuest != null) {
      return hasActiveQuest
          ? (activeQuestService.getNumberMarkersCollected - 1).toString() +
              " / " +
              (activeQuest.quest.markers!.length - 1).toString()
          : "0 / " + currentQuest!.markers!.length.toString();
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
        if (activeQuestService.getNumberMarkersCollected <
            activeQuest.quest.markerNotes!.length) {
          return activeQuest.quest
              .markerNotes![activeQuestService.getNumberMarkersCollected].note;
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
    if (activeQuestService.getNumberMarkersCollected >= indexClue + 1) {
      indexClue = indexClue + 1;
      notifyListeners();
    }
  }

  // @override
  // bool isQuestCompleted() {
  //   return activeQuestService.isAllMarkersCollected;
  // }

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
        displayClue = false;
        final bool completed = isQuestCompleted();
        if (completed) {
          await showCollectedMarkerDialog();
          // TODO: Show successfully finished quest!
          await showSuccessDialog();
          return;
          // checkQuestAndFinishWhenCompleted();
        } else {
          questTestingService.maybeRecordData(
            trigger: QuestDataPointTrigger.userAction,
            pushToNotion: true,
            userEventDescription:
                "collected marker " + getNumberMarkersCollectedString(),
          );

          await showCollectedMarkerDialog();

          // for now do the animation only for GPS Area Hunt!
          if (currentQuest!.type == QuestType.GPSAreaHunt) {
            if (maybeFlipCardToMap()) {
              await Future.delayed(Duration(milliseconds: 500));
            } else {
              animateCameraToQuestMarkers(getGoogleMapController);
            }
            isAnimatingCamera = true;
            await Future.delayed(Duration(milliseconds: 1000));
          }

          if (currentQuest!.type == QuestType.QRCodeHunt) {
            addMarkerToMap(quest: activeQuest.quest, afkmarker: result.marker!);
          }
          addAreaToMap(quest: activeQuest.quest, afkmarker: result.marker!);

          if (currentQuest!.type == QuestType.GPSAreaHunt) {
            notifyListeners();
            await Future.delayed(Duration(milliseconds: 1000));
          }
          isAnimatingCamera = false;
          displayButtonNewClue = true;

          // animateProgress = true;
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

  Future setDisplayNewClue(bool set) async {
    displayClue = set;
    displayButtonNewClue = false;
    notifyListeners();
    if (maybeFlipCardToClue()) {
      await Future.delayed(Duration(milliseconds: 800));
    }
    // animateProgress = true;
    // notifyListeners();
  }

  // -------------------------------------
  @override
  void resetPreviousQuest() {
    animateProgress = false;
    displayClue = true;
    displayButtonNewClue = false;
    super.resetPreviousQuest();
  }
}
