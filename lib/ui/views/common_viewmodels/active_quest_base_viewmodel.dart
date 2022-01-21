import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

abstract class ActiveQuestBaseViewModel extends QuestViewModel {
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final GeolocationService _geolocationService = locator<GeolocationService>();
  Set<Marker> markersOnMap = {};
  String get timeElapsed => questService.getMinutesElapsedString();
  bool questSuccessfullyFinished = false;

  // Functions to override!
  void loadQuestMarkers();
  bool isQuestCompleted();
  void updateMapMarkers({required AFKMarker afkmarker}) {}
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker});
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest});

  void onMapCreated(GoogleMapController controller) {
    if (hasActiveQuest) {
      setBusy(true);
      try {
        _googleMapController = controller;
        //Add Starter Marker
        loadQuestMarkers();
      } catch (error) {
        throw MapViewModelException(
            message: 'An error occured when creating the map',
            devDetails: "Error message from Map View Model $error ",
            prettyDetails:
                "An internal error occured on our side, sorry, please try again later.");
      }
      setBusy(false);
      notifyListeners();
    } else {
      _googleMapController = controller;
    }
  }

  CameraPosition initialCameraPosition() {
    if (hasActiveQuest) {
      return CameraPosition(
          target: LatLng(activeQuest.quest.startMarker!.lat!,
              activeQuest.quest.startMarker!.lon!),
          zoom: 16);
    } else {
      if (_geolocationService.getUserLivePositionNullable != null) {
        final CameraPosition _initialCameraPosition = CameraPosition(
            target: LatLng(_geolocationService.getUserLivePositionNullable!.latitude,
                _geolocationService.getUserLivePositionNullable!.longitude),
            zoom: 16);
        return _initialCameraPosition;
      } else {
        return CameraPosition(
          target: getDummyCoordinates(),
          zoom: 16,
        );
      }
    }
  }

  // ---------------------------------------------------
  // Function to call when quest was detected to be finished in individual viewmodel
  Future showSuccessDialog() async {
    questService.setSuccessAsQuestStatus();
    log.i("SUCCESFFULLY FOUND trophy");

    // Make checkout procedure same for all quest types!
    // Function in quest_viewmodel!
    final result = await dialogService.showCustomDialog(
      variant: DialogType.CollectCredits,
      data: activeQuest,
    );
    if (result?.confirmed == true) {
      // this means everything went fine!
      // Show statistics display
      questSuccessfullyFinished = true;
    }
    cancelQuestListener();
    notifyListeners();
  }

  Future showFoundTreasureDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.FoundTreasure,
      data: activeQuest,
    );
  }

  //------------------------------------------------------------
  // Reactive Service Mixin Functionality from stacked ReactiveViewModel!
  late List<ReactiveServiceMixin> _reactiveServices;
  ActiveQuestBaseViewModel() {
    _reactToServices(reactiveServices);
  }
  List<ReactiveServiceMixin> get reactiveServices =>
      [questService]; // _reactiveServices;
  void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
    _reactiveServices = reactiveServices;
    for (var reactiveService in _reactiveServices) {
      reactiveService.addListener(_indicateChange);
    }
  }

  Future showCollectedMarkerDialog() async {
    await dialogService.showCustomDialog(variant: DialogType.CollectedMarker);
    // await dialogService.showDialog(
    //     title: "Successfully collected marker!",
    //     description: getActiveQuestProgressDescription());
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    for (var reactiveService in _reactiveServices) {
      reactiveService.removeListener(_indicateChange);
    }
    super.dispose();
  }

  void _indicateChange() {
    notifyListeners();
  }

  void resetPreviousQuest() {
    questSuccessfullyFinished = false;
    showStartSwipe = true;
  }
}
