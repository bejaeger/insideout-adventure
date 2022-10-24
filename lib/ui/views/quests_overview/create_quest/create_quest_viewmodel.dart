import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/markers/markers.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../../datamodels/quests/quest.dart';
import '../../../../services/geolocation/geolocation_service.dart';

class CreateQuestViewModel extends AFKMarks with NavigationMixin {
  // member vars
  bool fromMap;
  void Function() disposeController;

  // if this is set, the user wants to start a quest here!
  final List<double>? latLng;
  CreateQuestViewModel(
      {required this.fromMap,
      required this.disposeController,
      required this.latLng});

  // -------------------------------------------------------
  // services
  final _log = getLogger('CreateQuestViewModel');
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final _questService = locator<QuestService>();
  final _geoLocationService = locator<GeolocationService>();
  final _userService = locator<UserService>();
  Geoflutterfire geo = Geoflutterfire();

  //CameraPosition? _initialCameraPosition;
  final _displaySnackBars = DisplaySnackBars();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final MapViewModel mapViewModel = locator<MapViewModel>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  // ------------------------------------------
  // state
  int pageIndex = 0;
  bool isLoading = false;
  bool result = false;
  QuestType selectedQuestType = QuestType.TreasureLocationSearch;

  String? afkCreditsInputValidationMessage;
  String? nameInputValidationMessage;
  String? questTypeInputValidationMessage;
  String? afkMarkersInputValidationMessage;
  num? screenTimeEquivalent;

  // to show loading indicator when screen shots are downloaded
  bool laodingScreenShots = false;

  Map<QuestType, List<dynamic>> get exampleScreenShots =>
      _cloudStorageService.exampleScreenShots;

  List<dynamic>? get exampleScreenShotsWithType =>
      _cloudStorageService.exampleScreenShots[selectedQuestType];

  Future loadExampleScreenshots() async {
    notifyListeners();
    laodingScreenShots = true;
    await _cloudStorageService.loadExampleScreenshots(
        questType: selectedQuestType);
    laodingScreenShots = false;
    notifyListeners();
  }

  List<String>? markerIds = [];
  @override
  void setFormStatus() {
    _log.i('Set the Form With Data: $formValueMap');
    if (afkCreditAmountValue != null && afkCreditAmountValue != "") {
      if (isValidUserInputs(credits: true)) {
        num tmpamount = int.parse(afkCreditAmountValue!);
        screenTimeEquivalent = creditsToScreenTime(tmpamount);
      }
    }
    if (nameValue?.isEmpty ?? true) {
      setValidationMessage('You Must Give a Value into this field');
    }
    resetValidationMessages();
  }

  Future onBackButton(PageController controller) async {
    if (pageIndex > 0) {
      controller.previousPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      pageIndex = pageIndex - 1;
      notifyListeners();
    } else {
      popView();
      disposeController();
    }
  }

  Future navigateToMap(PageController controller) async {
    pageIndex = 1;
    controller.jumpToPage(pageIndex);
    notifyListeners();
  }

  // ----------------------------------------------
  // Back or next navigations
  Future onNextButton(PageController controller) async {
    if (pageIndex == 2) {
      // Name and description inputs
      if (isValidUserInputs(name: true, description: true)) {
        controller.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        pageIndex = pageIndex + 1;
        notifyListeners();
      }
    } else if (pageIndex == 0) {
      if (userLocation == null) {
        isLoading = true;
        notifyListeners();
        await geolocationService.getAndSetCurrentLocation();
        isLoading = false;
        notifyListeners();
      }
      // quest type selection input
      controller.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      pageIndex = pageIndex + 1;
      notifyListeners();
    } else if (pageIndex == 1) {
      // quest marker selection
      if (getAFKMarkers.length < 2) {
        return null;
      } else {
        // ? for some reason this caused an error in the google map library
        // ? However, I don't know why I added this anyways!
        // isLoading = true;
        // notifyListeners();
        await controller.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        pageIndex = pageIndex + 1;
        // isLoading = false;
        // notifyListeners();
      }
    } else if (pageIndex == 3) {
      // number credits selection
      if (isValidUserInputs(credits: true)) {
        await createQuestAndNavigateToMap(controller: controller);
      }
    }
  }

  Future<void> currentUserPosition() async {
    setBusy(true);
    await _geoLocationService.setCurrentUserPosition();
    setBusy(false);
    notifyListeners();
  }

  bool isValidUserInputs(
      {bool name = false,
      bool description = false,
      bool type = false,
      bool credits = false}) {
    resetValidationMessages();
    bool isValid = true;
    if (credits && afkCreditAmountValue == null) {
      afkCreditsInputValidationMessage = 'Choose AFK Credits amount';
      isValid = false;
    }
    // also check type of afkCredits input
    if (credits) {
      try {
        num tmpValue = num.parse(afkCreditAmountValue.toString());
      } catch (e) {
        if (e is FormatException) {
          afkCreditsInputValidationMessage = "Please provide a numerical value";
          isValid = false;
        } else {
          rethrow;
        }
      }
    }
    if (name && nameValue == null) {
      nameInputValidationMessage = 'Please choose a valid quest name';
      isValid = false;
    }
    if (name && nameValue == "") {
      nameInputValidationMessage = 'Please choose a valid quest name';
      isValid = false;
    }
    if (description && descriptionValue == null) {
      nameInputValidationMessage = 'Please choose a valid quest description';
      isValid = false;
    }
    if (type && selectedQuestType == null) {
      questTypeInputValidationMessage = "Please choose a valid quest type";
      isValid = false;
    }
    if (!isValid) {
      _log.e("Input not valid");
      //displayEmptyTextsSnackBar();
      notifyListeners();
    }
    return isValid;
  }

  bool isValidMarkerInput() {
    if (getAFKMarkers.length < 2) {
      afkMarkersInputValidationMessage = "Choose at least 2 markers";
      return false;
    }
    return true;
  }

  // quest types
  void selectQuestType({required QuestType type}) {
    removeAllMarkers();
    selectedQuestType = type;
    notifyListeners();
  }

  String getQuestTypeExplanation() {
    switch (selectedQuestType) {
      case QuestType.DistanceEstimate:
        return kDistanceEstimateDescription;
      case QuestType.TreasureLocationSearch:
        return kLocationSearchDescriptionParents;
      case QuestType.QRCodeHunt:
        return kGPSAreaHikeDescriptionParents;
      case QuestType.QRCodeHike:
        return kGPSAreaHikeDescription;
      case QuestType.GPSAreaHike:
        return kGPSAreaHikeDescriptionParents;
      case QuestType.GPSAreaHunt:
        return kGPSAreaHikeDescriptionParents;
      default:
        return kGPSAreaHikeDescription;
    }
  }

  Future<bool?> _createQuest() async {
    if (!isValidUserInputs(credits: true)) return false;
    notifyListeners();
    num afkCreditAmount = num.parse(afkCreditAmountValue.toString());
    var id = Uuid();
    final questId = id.v1().toString().replaceAll('-', '');
    final added = await _questService.createQuest(
      quest: Quest(
        id: questId,
        createdBy: _userService.getUserRole == UserRole.adminMaster
            ? null
            : _userService.currentUser.uid,
        startMarker: getAFKMarkers.first,
        location: geo.point(
            latitude: getAFKMarkers.first.lat!,
            longitude: getAFKMarkers.first.lon!),
        finishMarker: getAFKMarkers.last,
        name: nameValue.toString(),
        description: descriptionValue.toString(),
        type: selectedQuestType,
        repeatable:
            selectedQuestType == QuestType.TreasureLocationSearch ? 0 : 1,
        markers: getAFKMarkers,
        afkCredits: afkCreditAmount,
        distanceMarkers: getTotalDistanceOfMarkers(),
      ),
    );
    if (added is String) {
      // this means something went wrong or timedout when uploading the quest
      if (added == WarningFirestoreCallTimeout) {
        await _dialogService.showDialog(
            title: "Unstable network connection",
            description:
                "Your quest was nevertheless created and will be uploaded later.");
        return true;
      } else {
        return false;
      }
    }
    if (added) {
      _log.i("Quest added successfully!");
      return true;
    }

    _displaySnackBars.snackBarNotCreatedQuest();
    return false;
  }

  Future<bool> createQuestAndNavigateToMap(
      {required PageController controller}) async {
    isLoading = true;
    result = await _createQuest() ?? false;
    if (result) {
      AFKMarker startMarker = getAFKMarkers.first;
      resetMarkersValues();
      navigateToMap(controller);
      //onBackButton(controller);
      await Future.delayed(Duration(milliseconds: 210));
      setBusy(true);
      if (getGoogleMapController != null) {
        getGoogleMapController!.animateCamera(
            CameraUpdate.newLatLng(LatLng(startMarker.lat!, startMarker.lon!)));
      }
      //   await mapViewModel.animateNewLatLon(
      // lat: startMarker.lat!, lon: startMarker.lon!, force: true);
      await Future.delayed(Duration(milliseconds: 1200));
      addMarkerOnMap(
        pos: LatLng(startMarker.lat!, startMarker.lon!),
        number: 1, // needed so color is selected
        questType: selectedQuestType,
      ); // number 0 gets green marker!
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 500));
      isLoading = false;
      notifyListeners();
      _displaySnackBars.snackBarCreatedQuest();
      await Future.delayed(Duration(milliseconds: 2000));
      setBusy(false);
      if (!fromMap) {
        replaceWithParentHomeView();
        disposeController();
      } else {
        await popUntilMapView();
        disposeController();
      }
    }
    return result;
  }

  void displayMarkersOnMap(List<double> pos) {
    if (selectedQuestType == QuestType.TreasureLocationSearch) {
      // At the moment we only support a start and a finish for
      // a search quest!
      // if (getAFKMarkers.length == 2) {
      //   snackbarService.showSnackbar(
      //       title: "Oops...",
      //       message:
      //           "Only two markers are supported for search quests at the moment",
      //       duration: Duration(milliseconds: 1500));
      //   return;
      // }

      // minimum distance of start and finish
      if (getAFKMarkers.length == 1) {
        double distance = _geoLocationService.distanceBetween(
            lat1: getAFKMarkers[0].lat,
            lon1: getAFKMarkers[0].lon,
            lat2: pos[0],
            lon2: pos[1]);
        if (distance < 100) {
          snackbarService.showSnackbar(
              title: "Oops...",
              message: "Markers need to be at least 100m away from each other.",
              duration: Duration(milliseconds: 1500));
          return;
        }
      }
    }
    addMarkerOnMap(pos: LatLng(pos[0], pos[1]), number: getAFKMarkers.length);
    notifyListeners();
  }

  // THE FOLLOWING IS VERY IMPORTANT!
  double getTotalDistanceOfMarkers() {
    AFKMarker? previousMarker;
    double totalDistanceInMeter = 0;
    getAFKMarkers.forEach(
      (marker) {
        if (previousMarker != null) {
          double distance = _geoLocationService.distanceBetween(
              lat1: previousMarker!.lat,
              lon1: previousMarker!.lon,
              lat2: marker.lat,
              lon2: marker.lon);
          totalDistanceInMeter = totalDistanceInMeter + distance;
        }
        previousMarker = marker;
      },
    );
    return totalDistanceInMeter;
  }

  int getExpectedDurationOfQuestInMinutes({double? distanceMarkers}) {
    late double actualDistanceMarkers;
    if (distanceMarkers == null) {
      actualDistanceMarkers = getTotalDistanceOfMarkers();
    } else {
      actualDistanceMarkers = distanceMarkers;
    }
    return (actualDistanceMarkers *
            HerculesWorldCreditSystem
                .kDistanceInMeterToActivityMinuteConversion)
        .round();
  }

  int getRecommendedCredits({int? durationQuestInMinutes}) {
    late int actualDuration;
    if (durationQuestInMinutes == null) {
      actualDuration = getExpectedDurationOfQuestInMinutes();
    } else {
      actualDuration = durationQuestInMinutes;
    }
    return (actualDuration *
            HerculesWorldCreditSystem.kMinuteActivityToCreditsConversion)
        .round();
  }

  void showCreditsSuggestionDialog() async {
    double totalDistanceInMeter = getTotalDistanceOfMarkers();
    int durationQuestInMinutes = getExpectedDurationOfQuestInMinutes(
        distanceMarkers: totalDistanceInMeter);
    int recommendedCredits =
        getRecommendedCredits(durationQuestInMinutes: durationQuestInMinutes);
    final response = await _dialogService.showDialog(
        title: "Recommendation",
        description:
            "Your markers are ${totalDistanceInMeter.toStringAsFixed(0)} meter apart. Your ${getShortQuestType(selectedQuestType)} is therefore expected to take about $durationQuestInMinutes minutes. We recommend giving $recommendedCredits credits which amounts to a default of ${creditsToScreenTime(recommendedCredits)} min screen time.",
        cancelTitle: "Learn more",
        cancelTitleColor: kcOrange);
    if (response?.confirmed == false) {
      await _dialogService.showCustomDialog(
        variant: DialogType.CreditConversionInfo,
        barrierDismissible: true,
      );
    }
  }

  void resetValidationMessages() {
    afkCreditsInputValidationMessage = null;
    nameInputValidationMessage = null;
    questTypeInputValidationMessage = null;
    afkMarkersInputValidationMessage = null;
    notifyListeners();
  }

  void displayEmptyTextsSnackBar([String? message]) {
    _displaySnackBars.snackBarTextBoxEmpty(message);
  }

  void onMapCreated(GoogleMapController controller) {
    setBusy(true);
    _googleMapController = controller;
    if (latLng != null) {
      addMarkerOnMap(
          pos: LatLng(latLng![0], latLng![1]), number: getAFKMarkers.length);
      _googleMapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(latLng![0], latLng![1])));
    }
    setBusy(false);
    notifyListeners();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
