import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class GuardianMapViewModel extends QuestViewModel {
  final MapViewModel mapViewModel = locator<MapViewModel>();

  bool get showReloadQuestButton => questService.showReloadQuestButton;
  bool get isReloadingQuests => questService.isReloadingQuests;

  bool isDeletingQuest = false;

  void initialize() async {
    setBusy(true);
    mapViewModel.resetAllMapMarkersAndAreas();
    mapStateService.setCameraToDefaultGuardianPosition();
    await getLocation(forceAwait: true, forceGettingNewPosition: false);
    setBusy(false);
    await initializeQuests(force: true);
    addStartMarkers();
    notifyListeners();
  }

  // ! Note: Same function exists in ward_home_viewmodel.dart
  Future initializeQuests(
      {bool? force,
      double? lat,
      double? lon,
      bool loadNewQuests = false}) async {
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await questService.loadNearbyQuests(
            force: true,
            guardianIds: [currentUser.uid],
            lat: lat,
            lon: lon,
            addQuestsToExisting: loadNewQuests);
        await questService.sortNearbyQuests();
        questService.extractAllQuestTypes();
      }
    } catch (e) {
      log.e(
          "Error when loading quests, this could happen when the quests collection is flawed or when no quests were found. Error: $e");
      if (e is QuestServiceException) {
        if (e.message == WarningNoQuestsDownloaded) {
          // delay makes for some nicer UX
          isDeletingQuest = true;
          notifyListeners();
          await Future.delayed(Duration(milliseconds: 1500));
          isDeletingQuest = false;
          notifyListeners();
          final res = await dialogService.showDialog(
              title: "Oops...",
              barrierDismissible: true,
              description: e.message,
              buttonTitle: "Create quest",
              cancelTitle: "Ok");
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

  void addStartMarkers() {
    if (nearbyQuests.isNotEmpty) {
      for (Quest _q in nearbyQuests) {
        log.v("Add start marker of quest with name ${_q.name} to map");
        if (_q.startMarker != null) {
          AFKMarker _m = _q.startMarker!;
          mapViewModel.addMarkerToMap(
            quest: _q,
            afkmarker: _m,
            isStartMarker: _m == _q.startMarker,
            onMarkerTapCustom: () => onMarkerTapGuardian(quest: _q, marker: _m),
            completed: false,
            isGuardianAccount: true,
          );
        }
      }
    }
  }

  void showCreateQuestDialog(double lat, double lon) async {
    final res = await dialogService.showDialog(
        title: "Create quest",
        description: "You can create a quest starting here",
        cancelTitle: "Nope",
        barrierDismissible: true,
        buttonTitle: "Create quest");
    if (res?.confirmed == true) {
      await navigationService.navigateTo(Routes.createQuestView,
          arguments:
              CreateQuestViewArguments(fromMap: true, latLng: [lat, lon]));
    }
  }

  Future onMarkerTapGuardian(
      {required Quest quest, required AFKMarker marker}) async {
    // marker info window shows automatically (google maps feature). hide it when not in avatar view
    mapViewModel.hideMarkerInfoWindowNow(markerId: marker.id);
    SheetResponse? response = await displayQuestBottomSheet(quest: quest);

    bool deleteQuest = response?.confirmed == false;
    if (deleteQuest) {
      DialogResponse? confirmation = await dialogService.showDialog(
        title: "Sure?",
        description: "Are you sure you want to delete this quest?",
        buttonTitle: "YES",
        cancelTitle: "NO",
      );
      if (confirmation?.confirmed == true) {
        await removeQuest(quest: quest);
        snackbarService.showSnackbar(
            title: "Deleted quest",
            message: "Successfully deleted quest.",
            duration: Duration(milliseconds: 1500));
        mapViewModel.resetAndAddBackAllMapMarkersAndAreas();
        addStartMarkers();
        notifyListeners();
      } else {
        await onMarkerTapGuardian(quest: quest, marker: marker);
      }
    }

    bool showQuestDetails = response?.confirmed == true;
    if (showQuestDetails) {
      mapViewModel.animateToQuestDetails(quest: quest);
      notifyListeners();
    }
  }

  Future<void> removeQuest({required Quest quest}) async {
    isDeletingQuest = true;
    notifyListeners();
    await questService.removeQuest(quest: quest);
    questService.removeFromNearbyQuests(quest: quest);
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
    addStartMarkers();
    notifyListeners();
  }

  // when quest details are shown we need to remove them again
  // (for guardian account this is simple. Corresponding function for ward account is in
  // active_quest_base_viewmodel.dart)
  void popQuestDetails() async {
    mapStateService.restorePreviousCameraPosition();
    mapViewModel.animateCameraViewModel(
        forceUseLocation: true,
        customLat: mapStateService.newLat,
        customLon: mapStateService.newLon);
    mapStateService.resetNewLatLon();

    mapViewModel.resetAllMapMarkersAndAreas();
    addStartMarkers();

    // reset selected quest -> UI: don't show quest details anymore
    activeQuestService.resetSelectedAndMaybePreviouslyFinishedQuest();

    notifyListeners();
  }
}
