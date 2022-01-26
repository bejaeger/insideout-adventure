import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/maps/maps_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

abstract class ActiveQuestBaseViewModel extends QuestViewModel {
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final MapsService mapsService = locator<MapsService>();
  bool questCenteredOnMap = true;
  String mapStyle = "";

  Set<Marker> markersOnMap = {};
  Set<Circle> areasOnMap = {};
  String get timeElapsed => questService.getMinutesElapsedString();
  bool questSuccessfullyFinished = false;
  bool questFinished = false;
  // Functions to override!
  void loadQuestMarkers();
  bool isQuestCompleted();
  void updateMapMarkers({required AFKMarker afkmarker}) {}
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker});
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest});

  void onMapCreated(GoogleMapController controller) async {
    if (hasActiveQuest) {
      setBusy(true);
      try {
        _googleMapController = controller;
        // await Future.delayed(Duration(milliseconds: 50));
        // controller.setMapStyle(mapStyle);
        // for camera position

        //Add Starter Marker
        loadQuestMarkers();

        log.v("Animating camera to quest markers");
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
      // await Future.delayed(Duration(milliseconds: 50));
      // controller.setMapStyle(mapStyle);
      if (currentQuest != null) {
        // animate camera to markers
        animateCameraToQuestMarkers(controller);
      }
    }
  }

  Future animateCameraToQuestMarkers(GoogleMapController? controller,
      {int delay = 200}) async {
    if (controller == null && getGoogleMapController == null) {
      log.wtf(
          "Cannot animate camera because no google maps controller present");
      return;
    }
    Future.delayed(
      Duration(milliseconds: delay),
      () => animateCameraToBetweenCoordinates(
        controller: controller ?? getGoogleMapController!,
        latLngList: questService
            .markersToShowOnMap(questIn: currentQuest)
            .map((m) => LatLng(m.lat!, m.lon!))
            .toList(),
      ),
    );
  }

  Future animateCameraToBetweenCoordinates(
      {required GoogleMapController controller,
      required List<LatLng> latLngList,
      double padding = 75}) async {
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          mapsService.boundsFromLatLngList(latLngList: latLngList), padding),
    );
  }

  Future animateCameraToPreviewNextArea() async {
    if (getGoogleMapController == null) {
      log.e("Can't animate camera because google maps controller is null");
      return;
    }
    // LatLng = getGoogleMapController.getZoomLevel()
    // getGoogleMapController!.
    AFKMarker? marker = questService.getNextMarker();
    if (marker != null && marker.lat != null && marker.lon != null) {
      double zoom = await getGoogleMapController!.getZoomLevel();
      await getGoogleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(marker.lat!, marker.lon!), zoom: zoom),
        ),
      );
      await Future.delayed(Duration(seconds: 1));
      Position pos = await geolocationService.getUserLivePosition;
      await animateCameraToBetweenCoordinates(
          controller: getGoogleMapController!,
          latLngList: [
            LatLng(pos.latitude, pos.longitude),
            LatLng(marker.lat!, marker.lon!),
          ],
          padding: 100);
    }
    notifyListeners();
  }

  Future animateToUserPosition(GoogleMapController controller) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                geolocationService.getUserLivePositionNullable!.latitude,
                geolocationService.getUserLivePositionNullable!.longitude),
            zoom: await controller.getZoomLevel()),
      ),
    );
    questCenteredOnMap = false;
    notifyListeners();
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
            target: LatLng(
                _geolocationService.getUserLivePositionNullable!.latitude,
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

  void navigateBackFromSingleQuestView() {
    cancelPositionListener();
    navigationService.back();
  }

  @override
  void dispose() {
    questCenteredOnMap = true;
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
