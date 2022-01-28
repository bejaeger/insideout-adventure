import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/maps/maps_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:flutter/material.dart';
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
  bool showCollectedMarkerAnimation = false;

  Set<Marker> markersOnMap = {};
  Set<Circle> areasOnMap = {};
  String get timeElapsed => questService.getMinutesElapsedString();
  bool questSuccessfullyFinished = false;
  bool questFinished = false;
  bool isAnimatingCamera = false;
  // Functions to override!
  void loadQuestMarkers();
  bool isQuestCompleted();
  // void updateMapMarkers({required AFKMarker afkmarker}) {}
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

  @override
  void updateMapMarkers({required AFKMarker afkmarker}) {
    markersOnMap = markersOnMap
        .map((item) => item.markerId == MarkerId(afkmarker.id)
            ? item.copyWith(
                iconParam:
                    defineMarkersColour(afkmarker: afkmarker, quest: null))
            : item)
        .toSet();
    notifyListeners();
  }

  // TODO all google maps controller stuff to a UI helper class!
  void updateMapArea({required AFKMarker afkmarker}) {
    areasOnMap = areasOnMap
        .map((item) => item.circleId == CircleId(afkmarker.id)
            ? item.copyWith(
                fillColorParam: Colors.green.withOpacity(0.5),
                strokeColorParam: Colors.green.withOpacity(0.6),
              )
            : item)
        .toSet();
    notifyListeners();
  }

  void updateMapDisplay({required AFKMarker afkmarker}) {
    if (activeQuest.quest.type == QuestType.QRCodeHike) {
      updateMapMarkers(afkmarker: afkmarker);
      updateMapArea(afkmarker: afkmarker);
    } else if (activeQuest.quest.type == QuestType.GPSAreaHike) {
      updateMapArea(afkmarker: afkmarker);
    }
  }

  Future animateCameraToPreviewNextArea() async {
    isAnimatingCamera = true;
    notifyListeners();
    if (getGoogleMapController == null) {
      log.e("Can't animate camera because google maps controller is null");
      return;
    }
    // LatLng = getGoogleMapController.getZoomLevel()
    // getGoogleMapController!.
    AFKMarker? marker = questService.getNextMarker();
    AFKMarker? previousMarker = questService.getPreviousMarker();
    if (marker != null &&
        marker.lat != null &&
        marker.lon != null &&
        previousMarker != null &&
        previousMarker.lat != null &&
        previousMarker.lon != null) {
      await getGoogleMapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(previousMarker.lat!, previousMarker.lon!),
        ),
      );
      await Future.delayed(Duration(milliseconds: 1200));
      triggerCollectedMarkerAnimation();
      // await Future.delayed(Duration(milliseconds: 1000));
      updateMapDisplay(afkmarker: previousMarker);
      await Future.delayed(Duration(milliseconds: 1200));
      await getGoogleMapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(marker.lat!, marker.lon!),
        ),
      );
      await Future.delayed(Duration(milliseconds: 1200));
      Position pos = await geolocationService.getUserLivePosition;
      await animateCameraToBetweenCoordinates(
        controller: getGoogleMapController!,
        latLngList: [
          //LatLng(pos.latitude, pos.longitude),
          LatLng(previousMarker.lat!, previousMarker.lon!),
          LatLng(marker.lat!, marker.lon!),
        ],
      );
    }
    await Future.delayed(Duration(milliseconds: 1200));
    isAnimatingCamera = false;
    notifyListeners();
    snackbarService.showSnackbar(
        title: "Let's go", message: "The next marker is waiting!");
  }

  void triggerCollectedMarkerAnimation() {
    showCollectedMarkerAnimation = true;
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
