import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:insideout_ui/insideout_ui.dart';

abstract class QuestViewModel extends BaseModel with MapStateControlMixin {
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final MapViewModel mapViewModel = locator<MapViewModel>();
  final log = getLogger("QuestViewModel");

  bool get isDevFlavor => appConfigProvider.flavor == Flavor.dev;
  List<Quest> get nearbyQuests => questService.getNearByQuest;
  List<Quest> get nearbyQuestsTodo => questService.getNearByQuestTodo;

  List<double> distancesFromQuests = [];

  List<Quest> getQuestsOfType({required QuestType type}) {
    return questService.extractQuestsOfType(
        quests: nearbyQuests, questType: type);
  }

  Future getLocation(
      {bool forceAwait = false, bool forceGettingNewPosition = true}) async {
    try {
      if (_geolocationService.getUserLivePositionNullable == null) {
        await _geolocationService.getAndSetCurrentLocation(
            forceGettingNewPosition: forceGettingNewPosition);
      } else {
        if (forceAwait) {
          await _geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        } else {
          _geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        }
      }
    } catch (e) {
      if (e is GeolocationServiceException) {
        if (appConfigProvider.enableGPSVerification) {
          await dialogService.showDialog(
              title: "Sorry", description: e.prettyDetails);
        } else {
          if (!shownDummyModeDialog) {
            await dialogService.showDialog(
                title: "Dummy mode active",
                description:
                    "GPS connection not available, you can still try out the quests by tapping on the markers");
            shownDummyModeDialog = true;
          }
        }
      } else {
        log.wtf("Could not get location of user");
        await showGenericInternalErrorDialog();
      }
    }
  }

  Future onQuestInListTapped(Quest quest) async {
    if (hasActiveQuest == false) {
      removeQuestListOverlay();
      changeNavigatedFromQuestList(true);
      showQuestDetailsFromList(quest: quest);
    } else {
      dialogService.showDialog(title: "You currently have a running quest!");
    }
  }

  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    log.i("Handling marker analysis result");
    if (!hasActiveQuest &&
        (result.quests == null ||
            (result.quests != null && result.quests!.length == 0))) {
      await dialogService.showDialog(
          title:
              "The scanned marker is not a start of a quest. Please go to the starting point");
    }
    if (result.quests != null && result.quests!.length > 0) {
      // TODO: Handle case where more than one quest is returned here!
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

  void showQuestDetailsFromList({required Quest quest}) {
    mapViewModel.animateToQuestDetails(quest: quest);
  }

  int currentIndex = 0;
  void toggleIndex() {
    if (currentIndex == 0) {
      currentIndex = 1;
    } else {
      currentIndex = 0;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
