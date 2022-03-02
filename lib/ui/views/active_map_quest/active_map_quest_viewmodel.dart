import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActiveMapQuestViewModel extends ActiveQuestBaseViewModel {
  /// If user enters an area, the following AFKMarker will be set that corresponds to the marker.
  /// If the user walks outside the area (geofence) (+ some extra buffer zone)
  /// the marker is set to null again (after some time delay to avoid multiple dialogs
  /// that open because location events were fired in the background
  /// while the first dialog was open)
  /// If null: allow to show alert dialog when user enters geofence
  /// If not null: don't show alert dialog on additional location listener events
  /// @see checkIfInAreaOfMarker()
  AFKMarker? markerInArea;

  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;

  // UI state
  String mapStyle = "";
  bool isAnimatingCamera = false;
  bool validatingMarkerInArea = false;

  // set of markers and areas on map
  Set<Marker> markersOnMap = {};
  Set<Circle> areasOnMap = {};

  // -------------------------------------------------
  // initialize
  @override
  Future initialize({required Quest quest}) async {
    log.i("Initializing active map quest of tye: ${quest.type}");
    resetPreviousQuest();
    setBusy(true);
    await super.initialize(quest: quest);
    // Option to add custom map style
    await rootBundle.loadString('assets/DayStyle.json').then((string) {
      mapStyle = string;
    });
    setBusy(false);

    if (quest.type == QuestType.QRCodeHike) {
      addMarkers(quest: quest);
    }
    addAreas(quest: quest);

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
    for (AFKMarker _m
        in activeQuestService.markersToShowOnMap(questIn: quest)) {
      if (_m != quest.startMarker) {
        addMarkerToMap(quest: quest, afkmarker: _m);
      }
    }
    // notifyListeners();
  }

  void addAreas({required Quest quest}) {
    for (AFKMarker _m
        in activeQuestService.markersToShowOnMap(questIn: quest)) {
      // don't add area if it's the start marker because that is handled separately
      if (_m != quest.startMarker) {
        addAreaToMap(quest: quest, afkmarker: _m);
      }
    }
    // notifyListeners();
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null && !hasActiveQuest) {
      final result =
          await startQuestMain(quest: quest, countStartMarkerAsCollected: true);
      if (result == false) {
        log.wtf("Not starting quest, due to an unknown reason");
        return;
      }
      // quest started
      //if (quest.type != QuestType.GPSAreaHike) {
      activeQuestService.listenToPosition(
        distanceFilter: kDistanceFilterHikeQuest,
        pushToNotion: true,
        viewModelCallback: (userLivePosition) async {
          // ! this only ever checks the "next" marker
          // ! that is only really defined if the checkpoints are ordered!
          // ! Need to have a method in place that allows some freedom here.
          checkIfInAreaOfMarker(
              marker: activeQuestService.getNextMarker(),
              position: userLivePosition);
        },
      );
      //}
      showStartSwipe = false;
      notifyListeners();
      //resetSlider();
    }
  }

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
            userEventDescription: "in area of marker",
          );
          if (currentQuest?.type == QuestType.QRCodeHike ||
              currentQuest?.type == QuestType.GPSAreaHike) {
            vibrateAlert();
            activeQuestService.pausePositionListener();
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
            activeQuestService.resumePositionListener();
          }
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
      //showGenericInternalErrorDialog();
    }
  }

  Future collectMarkerFromGPSLocation() async {
    if (await maybeCheatAndCollectNextMarker()) {
      return;
    }

    validatingMarkerInArea = true;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 500));
    validatingMarkerInArea = false;
    notifyListeners();
    if (!hasActiveQuest) {
      await dialogService.showDialog(
          title: "Start the quest to collect markers");
      return;
    }
    if (markerInArea == null) {
      await dialogService.showDialog(
        title: "Cannot collect marker!",
        description: "You are not in the area of a checkpoint!",
      );
      return;
    }
    MarkerAnalysisResult markerResult =
        await activeQuestService.analyzeMarker(marker: markerInArea);
    return await handleMarkerAnalysisResult(markerResult);
  }

  // TODO: check if this is necessary
  void loadQuestMarkers() {
    log.i("Getting quest markers");
    setBusy(true);
    for (AFKMarker _m in activeQuest.quest.markers) {
      addMarkerToMap(quest: activeQuest.quest, afkmarker: _m);
    }
    log.v('These Are the values of the current Markers $markersOnMap');
    setBusy(false);
  }

  String getNumberMarkersCollectedString() {
    if (activeQuestService.hasActiveQuest) {
      // minus one because start marker is counted as collected from the start!
      return (numMarkersCollected - 1).toString() +
          " / " +
          (activeQuest.markersCollected.length - 1).toString();
    } else {
      return "0";
    }
  }

  CameraPosition initialCameraPosition() {
    if (!hasActiveQuest) {
      if (geolocationService.getUserLivePositionNullable != null) {
        final CameraPosition _initialCameraPosition = CameraPosition(
            target: LatLng(
                geolocationService.getUserLivePositionNullable!.latitude,
                geolocationService.getUserLivePositionNullable!.longitude),
            zoom: 14);
        return _initialCameraPosition;
      } else {
        return CameraPosition(
          target: getDummyCoordinates(),
          zoom: 14,
        );
      }
    } else {
      // HAS ACTIVE QUEST
      if (activeQuest.quest.startMarker != null) {
        final CameraPosition _initialCameraPosition = CameraPosition(
          //In Future I will change these values to dynamically Change the Initial Camera Position
          //Based on teh city
          target: LatLng(activeQuest.quest.startMarker!.lat!,
              activeQuest.quest.startMarker!.lon!),
          zoom: 15,
        );
        return _initialCameraPosition;
      } else {
        // return current user position
        final CameraPosition _initialCameraPosition = CameraPosition(
            target: LatLng(
                geolocationService.getUserLivePositionNullable!.latitude,
                geolocationService.getUserLivePositionNullable!.longitude),
            zoom: 13);
        return _initialCameraPosition;
      }
    }
  }

  void addMarkerToMap(
      {required Quest quest,
      required AFKMarker afkmarker,
      bool isFinishMarker = false}) {
    markersOnMap.add(
      Marker(
        markerId: MarkerId(afkmarker
            .id), // google maps marker id of start marker will be our quest id
        position: LatLng(afkmarker.lat!, afkmarker.lon!),
        infoWindow: InfoWindow(
            title: activeQuestService.isStartMarker(afkmarker)
                ? "START"
                : activeQuestService.isFinishMarker(afkmarker)
                    ? "FINISH"
                    : "GO HERE"),
        // InfoWindow(snippet: quest.name),
        icon: defineMarkersColour(
            quest: quest, afkmarker: afkmarker, isFinishMarker: isFinishMarker),
        onTap: () async {
          // event triggered when user taps marker

          if (getGoogleMapController != null) {
            // needed to avoid navigating to that marker!
            getGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(
                await getGoogleMapController!.getVisibleRegion(), 0));
          }

          dynamic adminMode = false;
          if (useSuperUserFeatures) {
            adminMode = await showAdminDialogAndGetResponse();
            if (adminMode == true) {
              String qrCodeString =
                  qrCodeService.getQrCodeStringFromMarker(marker: afkmarker);
              navigationService.navigateTo(Routes.qRCodeView,
                  arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
            }
          }
          if (!useSuperUserFeatures || adminMode == false) {
            if (hasActiveQuest == false) {
              if (quest.type != QuestType.QRCodeHike) {
                dialogService.showDialog(
                    title: "Checkpoint",
                    description: "Start the quest and reach this checkpoint.");
              } else {
                dialogService.showDialog(
                    title: "Marker",
                    description: "Start the quest and collect this marker.");
              }
            } else {
              // what happens when the user collects a marker
              log.i("Quest active, handling qrCodeScanEvent");
              if (flavorConfigProvider.allowDummyMarkerCollection) {
                MarkerAnalysisResult markerResult =
                    await activeQuestService.analyzeMarker(marker: afkmarker);
                await handleMarkerAnalysisResult(markerResult);
              }
            }
          }
          log.i("adminMode = $adminMode");
        },
      ),
    );
  }

  void addStartMarkerToMap(
      {required Quest quest, required AFKMarker afkmarker}) {
    markersOnMap.add(
      Marker(
        markerId: MarkerId(afkmarker
            .id), // google maps marker id of start marker will be our quest id
        position: LatLng(afkmarker.lat!, afkmarker.lon!),
        infoWindow: InfoWindow(
            title: afkmarker == quest.startMarker ? "START HERE" : "GO HERE"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () async {
          if (getGoogleMapController != null) {
            // needed to avoid navigating to that marker!
            getGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(
                await getGoogleMapController!.getVisibleRegion(), 0));
          }

          // event triggered when user taps marker
          dynamic adminMode = false;
          if (useSuperUserFeatures) {
            adminMode = await showAdminDialogAndGetResponse();
            if (adminMode == true) {
              String qrCodeString =
                  qrCodeService.getQrCodeStringFromMarker(marker: afkmarker);
              navigationService.navigateTo(Routes.qRCodeView,
                  arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
            }
          }
          if (!useSuperUserFeatures || adminMode == false) if (hasActiveQuest) {
            await dialogService.showDialog(
                title: "You started here",
                description: "This was the beginning");
          } else {
            await dialogService.showDialog(
                title: "The Start",
                description: "Move to this location and start the quest.");
          }
        },
      ),
    );
  }

  void addStartAreaToMap({required Quest quest, required AFKMarker afkmarker}) {
    areasOnMap.add(
      Circle(
        circleId: CircleId(afkmarker
            .id), // google maps marker id of start marker will be our quest id
        center: LatLng(afkmarker.lat!, afkmarker.lon!),
        fillColor: Colors.green.withOpacity(0.5),
        strokeColor: Colors.green.withOpacity(0.6),
        strokeWidth: 2,
        radius: kMaxDistanceFromMarkerInMeter.toDouble(),
        consumeTapEvents: true,
        onTap: () async {
          if (getGoogleMapController != null) {
            // needed to avoid navigating to that marker!
            getGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(
                await getGoogleMapController!.getVisibleRegion(), 0));
          }

          // event triggered when user taps marker
          dynamic adminMode = false;
          if (useSuperUserFeatures) {
            adminMode = await showAdminDialogAndGetResponse();
            if (adminMode == true) {
              String qrCodeString =
                  qrCodeService.getQrCodeStringFromMarker(marker: afkmarker);
              navigationService.navigateTo(Routes.qRCodeView,
                  arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
            }
          }
          if (!useSuperUserFeatures || adminMode == false)
            await dialogService.showDialog(
                title: "The Start",
                description: "Move to this location and start the quest.");
        },
      ),
    );
  }

  void addAreaToMap({required Quest quest, required AFKMarker afkmarker}) {
    // implement the color choice better!
    Color? color;
    if (hasActiveQuest) {
      if (activeQuestService.isMarkerCollected(marker: afkmarker)) {
        color = Colors.green;
      } else {
        color = Colors.red;
      }
    }
    areasOnMap.add(
      Circle(
        circleId: CircleId(afkmarker
            .id), // google maps marker id of start marker will be our quest id
        center: LatLng(afkmarker.lat!, afkmarker.lon!),
        fillColor: color?.withOpacity(0.5) ?? Colors.red.withOpacity(0.5),
        strokeColor: color?.withOpacity(0.6) ?? Colors.red.withOpacity(0.6),
        strokeWidth: 2,
        radius: 50,
        consumeTapEvents: true,
        onTap: () async {
          if (getGoogleMapController != null) {
            // needed to avoid navigating to that marker!
            getGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(
                await getGoogleMapController!.getVisibleRegion(), 0));
          }

          // event triggered when user taps on circle
          if (hasActiveQuest) {
            if (flavorConfigProvider.allowDummyMarkerCollection) {
              MarkerAnalysisResult markerResult =
                  await activeQuestService.analyzeMarker(marker: afkmarker);
              await handleMarkerAnalysisResult(markerResult);
            }
          } else {
            await dialogService.showDialog(
                title: "Walk to this area to collect the checkpoint");
          }
        },
      ),
    );
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    log.i("Handling marker analysis result");
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return false;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      // if (result.errorType != MarkerCollectionFailureType.alreadyCollected) {
      await dialogService.showDialog(
        title: "Can't collect marker!",
        description: result.errorMessage!,
      );
      // }
      return false;
    } else {
      if (!hasActiveQuest && result.quests == null) {
        await dialogService.showDialog(
            title:
                "The scanned marker is not a start of a quest. Please go to the starting point");
        return false;
      }

      if (result.marker != null) {
        if (hasActiveQuest) {
          log.i("Scanned marker sucessfully collected!");
          if (currentQuest?.type == QuestType.QRCodeHike) {
            await showCollectedMarkerDialog();
          }
          await handleCollectedMarkerEvent(afkmarker: result.marker!);
        }
        return true;
      }

      if (result.quests != null && result.quests!.length > 0) {
        // TODO: Handle case where more than one quest is returned here!
        // For now, just start first quest!
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
  }

  Future handleCollectedMarkerEvent({required AFKMarker afkmarker}) async {
    if (hasActiveQuest == true) {
      questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        pushToNotion: true,
        userEventDescription:
            "collected marker " + getNumberMarkersCollectedString(),
      );

      // Move this to isQuestCompleted function and remove stuff from service!
      if (isQuestCompleted()) {
        handleQuestCompletedEvent(afkmarker: afkmarker);
        return;
      } else {
        // animate camera to preview next marker
        animateCameraToPreviewNextMarker();
      }
    } else {
      dialogService.showDialog(
          title: "Quest Not Running",
          description: "Verify Your Quest Because is not running");
    }
  }

  Future handleQuestCompletedEvent({required AFKMarker afkmarker}) async {
    //checkQuestAndFinishWhenCompleted();
    updateMapDisplay(afkmarker: afkmarker);
    await animateCameraToQuestMarkers(getGoogleMapController);
    setBusy(true);
    questFinished = true;
    activeQuestService.setSuccessAsQuestStatus();

    CollectCreditsStatus collectCreditsStatus = CollectCreditsStatus.todo;
    try {
      // Upload quest but give it at least 4 seconds while the camera is animating
      // for some sweet UX experience
      final results = await Future.wait(
        [
          handleSuccessfullyFinishedQuest(showDialogs: false),
          Future.delayed(Duration(milliseconds: 3500))
        ],
      );
      collectCreditsStatus = results[0];
    } catch (e) {
      log.e(e);
      showGenericInternalErrorDialog();
      collectCreditsStatus = CollectCreditsStatus.todo;
    }

    setBusy(false);
    // quest succesfully completed
    await showSuccessDialog(collectCreditsStatus: collectCreditsStatus);
  }

  @override
  void resetPreviousQuest() {
    //isInAreaOfMarker = false;
    // markersOnMap = {};
    // areasOnMap = {};
    validatingMarkerInArea = false;
    isAnimatingCamera = false;
    markerInArea = null;
    questCenteredOnMap = true;
    super.resetPreviousQuest();
  }

  void onMapCreated(GoogleMapController controller) async {
    if (hasActiveQuest) {
      setBusy(true);
      try {
        _googleMapController = controller;
        // await Future.delayed(Duration(milliseconds: 50));
        controller.setMapStyle(mapStyle);
        // for camera position

        //Add Starter Marker
        // loadQuestMarkers();

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
      controller.setMapStyle(mapStyle);
      if (currentQuest != null) {
        // animate camera to markers
        animateCameraToQuestMarkers(controller);
        if (currentQuest!.type == QuestType.QRCodeHike) {
          showInfoWindowOfNextMarker(quest: currentQuest!);
        }
      }
    }
  }

  void showInfoWindowOfNextMarker({Quest? quest, AFKMarker? marker}) async {
    if (quest == null && marker == null) return;
    late MarkerId markerId;
    if (quest != null) {
      if (quest.markers.length > 1) {
        markerId = MarkerId(quest.markers[1].id);
      }
    }
    if (marker != null) {
      markerId = MarkerId(marker.id);
    }
    try {
      Future.delayed(
        Duration(seconds: marker != null ? 0 : 1),
        () {
          getGoogleMapController?.showMarkerInfoWindow(markerId);
          notifyListeners();
        },
      );
    } catch (e) {
      log.e(
          "This is a weird error from google maps when showing the marker info: $e");
      log.wtf(
          "We tried to circumvent it with a delay and didn't bother about it any longer");
      return;
    }
  }

  Future animateCameraToQuestMarkers(GoogleMapController? controller,
      {int delay = 200}) async {
    if (controller == null && getGoogleMapController == null) {
      log.wtf(
          "Cannot animate camera because no google maps controller present");
      return;
    }
    List<LatLng> latLngListToAnimate = activeQuestService
        .markersToShowOnMap(questIn: currentQuest)
        .map((m) => LatLng(m.lat!, m.lon!))
        .toList();
    if ((hasActiveQuest == false || latLngListToAnimate.length == 1) &&
            currentQuest?.type == QuestType.QRCodeHunt ||
        currentQuest?.type == QuestType.GPSAreaHunt) {
      latLngListToAnimate.add(geolocationService.getUserLatLng);
    }

    // add ghost latLong positions (in-place) to avoid  zooming
    // too far if only two positions very close by are shown!
    potentiallyAddGhostLatLng(latLngList: latLngListToAnimate);

    Future.delayed(
      Duration(milliseconds: delay),
      () => animateCameraToBetweenCoordinates(
        controller: controller ?? getGoogleMapController!,
        latLngList: latLngListToAnimate,
      ),
    );
  }

  Future animateCameraToBetweenCoordinates(
      {required GoogleMapController controller,
      required List<LatLng> latLngList,
      double padding = 100}) async {
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          mapsService.boundsFromLatLngList(latLngList: latLngList), padding),
    );
  }

  void potentiallyAddGhostLatLng({required List<LatLng> latLngList}) {
    if (latLngList.length == 2) {
      if (geolocationService.distanceBetween(
              lat1: latLngList[0].latitude,
              lon1: latLngList[0].longitude,
              lat2: latLngList[1].latitude,
              lon2: latLngList[1].longitude) <
          150) {
        // add ghost latLng positions for padding of camera!
        latLngList.add(geolocationService.getLatLngShiftedLon(
            latLng: latLngList[0], offset: 80));
        latLngList.add(geolocationService.getLatLngShiftedLon(
            latLng: latLngList[0], offset: -80));
      }
    }
  }

  void updateMapMarkers({required AFKMarker afkmarker}) {
    markersOnMap = markersOnMap
        .map((item) => item.markerId == MarkerId(afkmarker.id)
            ? item.copyWith(
                iconParam:
                    defineMarkersColour(afkmarker: afkmarker, quest: null),
                infoWindowParam: InfoWindow(title: "ALREADY COLLECTED"))
            : item)
        .toSet();
    notifyListeners();
  }

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
    updateMapArea(afkmarker: afkmarker);
    updateMapMarkers(afkmarker: afkmarker);
  }

  Future animateCameraToPreviewNextMarker() async {
    isAnimatingCamera = true;
    notifyListeners();
    if (getGoogleMapController == null) {
      log.e("Can't animate camera because google maps controller is null");
      return;
    }
    // LatLng = getGoogleMapController.getZoomLevel()
    // getGoogleMapController!.
    AFKMarker? nextMarker = activeQuestService.getNextMarker();
    AFKMarker? previousMarker = activeQuestService.getPreviousMarker();
    if (nextMarker != null &&
        nextMarker.lat != null &&
        nextMarker.lon != null &&
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
      await Future.delayed(Duration(milliseconds: 800));
      if (currentQuest?.type == QuestType.GPSAreaHike) {
        await showCollectedMarkerDialog();
        await Future.delayed(Duration(milliseconds: 200));
      }
      await getGoogleMapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(nextMarker.lat!, nextMarker.lon!),
        ),
      );
      if (currentQuest?.type == QuestType.GPSAreaHike) {
        await Future.delayed(Duration(milliseconds: 800));
        addNextArea(marker: nextMarker);
        maybeAddFinishMarker(marker: nextMarker);
        await Future.delayed(Duration(milliseconds: 600));
        double currentZoom = await getGoogleMapController!.getZoomLevel();
        showInfoWindowOfNextMarker(marker: nextMarker);
        await getGoogleMapController!.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(nextMarker.lat!, nextMarker.lon!), currentZoom + 1));
        await Future.delayed(Duration(milliseconds: 600));
      } else {
        if (currentQuest!.type == QuestType.QRCodeHike) {
          await Future.delayed(Duration(milliseconds: 600));
          showInfoWindowOfNextMarker(marker: nextMarker);
          await Future.delayed(Duration(milliseconds: 600));
        } else {
          await Future.delayed(Duration(milliseconds: 1200));
        }
      }
      await animateCameraToBetweenCoordinates(
        controller: getGoogleMapController!,
        latLngList: [
          //LatLng(pos.latitude, pos.longitude),
          LatLng(previousMarker.lat!, previousMarker.lon!),
          LatLng(nextMarker.lat!, nextMarker.lon!),
        ],
      );
    }
    await Future.delayed(Duration(milliseconds: 1200));
    if (currentQuest?.type == QuestType.GPSAreaHike) {
      await Future.delayed(Duration(milliseconds: 600));
    }
    isAnimatingCamera = false;
    notifyListeners();
    if (currentQuest?.type == QuestType.GPSAreaHike) {
      dialogService.showDialog(
          title: "New checkpoint spotted!",
          description: "Find the next location!");
    } else {
      snackbarService.showSnackbar(
          title: "Let's go", message: "The next marker is waiting!");
    }
  }

  void addNextArea({Quest? quest, AFKMarker? marker}) {
    AFKMarker? actualMarker =
        marker ?? activeQuestService.getNextMarker(quest: quest);
    if (actualMarker != null) {
      addAreaToMap(quest: quest ?? activeQuest.quest, afkmarker: actualMarker);
    }
    notifyListeners();
  }

  void addNextMarker({Quest? quest, AFKMarker? marker}) {
    AFKMarker? actualMarker =
        marker ?? activeQuestService.getNextMarker(quest: quest);
    if (actualMarker != null) {
      addMarkerToMap(
          quest: quest ?? activeQuest.quest, afkmarker: actualMarker);
    }
    notifyListeners();
  }

  void maybeAddFinishMarker({AFKMarker? marker}) {
    if (marker == null) return;
    if (activeQuestService.isFinishMarker(marker)) {
      addMarkerToMap(
          quest: activeQuest.quest, afkmarker: marker, isFinishMarker: true);
    }
  }

  void triggerCollectedMarkerAnimation() {
    showCollectedMarkerAnimation = true;
    notifyListeners();
  }

  Future animateToUserPosition(GoogleMapController? controller) async {
    if (controller == null) return;
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
    return activeQuestService.isAllMarkersCollected;
  }

  @override
  dispose() {
    resetPreviousQuest();
    _googleMapController?.dispose();
    super.dispose();
  }
}
