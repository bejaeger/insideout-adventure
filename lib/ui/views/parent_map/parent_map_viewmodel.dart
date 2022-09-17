import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class ParentMapViewModel extends QuestViewModel {
  // -----------------------------------------
  // services
  final MapViewModel mapViewModel = locator<MapViewModel>();

  // ----------------------------------
  // getters
  bool get showReloadQuestButton => questService.showReloadQuestButton;
  bool get isReloadingQuests => questService.isReloadingQuests;

  // ---------------------------------------
  // state
  bool isDeletingQuest = false;

  // ---------------------------------
  // initialize function
  void initialize() async {
    setBusy(true);
    mapViewModel.resetAllMapMarkersAndAreas();
    await getLocation(forceAwait: true, forceGettingNewPosition: false);
    await initializeQuests(force: true);
    setBusy(false);
    addMarkers();
  }

  // ? Note: Same function exists in explorer_home_viewmodel.dart
  Future initializeQuests(
      {bool? force,
      double? lat,
      double? lon,
      bool loadNewQuests = false}) async {
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await questService.loadNearbyQuests(
            force: true,
            sponsorIds: [currentUser.uid],
            lat: lat,
            lon: lon,
            addQuestsToExisting: loadNewQuests);
        await questService.sortNearbyQuests();
        questService.extractAllQuestTypes();
      }
    } catch (e) {
      log.e(
          "Error when loading quests, this could happen when the quests collection is flawed. Error: $e");
      if (e is QuestServiceException) {
        if (e.message == WarningNoQuestsDownloaded) {
          final res = await dialogService.showDialog(
              title: "Oops...",
              description: e.message,
              buttonTitle: "Create quest",
              cancelTitle: "Back");
          if (res?.confirmed == true) {
            navToCreateQuest(fromMap: true);
          }
        } else {
          await dialogService.showDialog(
              title: "Oops...", description: e.prettyDetails);
        }
      } else {
        log.wtf(
            "Error when loading quests, this should never happen. Error: $e");
        await showGenericInternalErrorDialog();
      }
    }
  }

  void addMarkers() {
    if (nearbyQuests.isNotEmpty) {
      for (Quest _q in nearbyQuests) {
        log.v("Add start marker of quest with name ${_q.name} to map");
        if (_q.startMarker != null) {
          AFKMarker _m = _q.startMarker!;
          mapViewModel.addMarkerToMap(
              quest: _q,
              afkmarker: _m,
              isStartMarker: _m == _q.startMarker,
              onMarkerTapCustom: () => onMarkerTapParent(quest: _q, marker: _m),
              completed: currentUserStats.completedQuestIds.contains(_q.id));
        }
      }
    }
  }

  Future onMarkerTapParent(
      {required Quest quest, required AFKMarker marker}) async {
    // marker info window shows automatically. hide it when not in avatar view
    mapViewModel.hideMarkerInfoWindowNow(markerId: marker.id);
    SheetResponse? response = await displayQuestBottomSheet(quest: quest);

    if (response?.confirmed == false) {
      DialogResponse? response2 = await dialogService.showDialog(
        title: "Sure?",
        description: "Are you sure you want to delete this quest?",
        buttonTitle: "YES",
        cancelTitle: "NO",
      );
      if (response2?.confirmed == true) {
        // Delete quest!
        await removeQuest(quest: quest);
        snackbarService.showSnackbar(
            title: "Deleted quest",
            message: "Successfully deleted quest.",
            duration: Duration(milliseconds: 1500));

        // update marker on map!
        mapViewModel.resetAndAddBackAllMapMarkersAndAreas();
        addMarkers();
        notifyListeners();
      } else {
        await onMarkerTapParent(quest: quest, marker: marker);
      }
    }
  }

  // TODO: Function also in single_quest_type_viewmodel.dart, NEEDED there!?
  Future<void> removeQuest({required Quest quest}) async {
    isDeletingQuest = true;
    notifyListeners();
    //Remove Quest in the Firebase
    await questService.removeQuest(quest: quest);
    //Remove Quest In the List.
    nearbyQuests.remove(quest);
    isDeletingQuest = false;
    notifyListeners();
  }

  Future loadNewQuests() async {
    log.i("Loading new quests");
    questService.isReloadingQuests = true;
    notifyListeners();
    await initializeQuests(
        force: true,
        lat: mapStateService.currentLat,
        lon: mapStateService.currentLon,
        loadNewQuests: true);
    questService.showReloadQuestButton = false;
    questService.isReloadingQuests = false;
    addMarkers();
    notifyListeners();
  }
}
