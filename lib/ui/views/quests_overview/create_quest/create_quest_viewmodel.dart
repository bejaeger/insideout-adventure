import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/user_role.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../../datamodels/quests/quest.dart';
import '../../../../services/geolocation/geolocation_service.dart';

class CreateQuestViewModel extends AFKMarks with NavigationMixin {
  final _log = getLogger('CreateQuestViewModel');
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final _questService = locator<QuestService>();
  final _geoLocationService = locator<GeolocationService>();
  final _userService = locator<UserService>();
  //CameraPosition? _initialCameraPosition;
  final _displaySnackBars = DisplaySnackBars();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final MapViewModel mapViewModel = locator<MapViewModel>();

  int pageIndex = 0;
  bool creatingQuest = false;
  bool result = false;
  QuestType selectedQuestType = QuestType.TreasureLocationSearch;

  String? afkCreditsInputValidationMessage;
  String? nameInputValidationMessage;
  String? questTypeInputValidationMessage;
  String? afkMarkersInputValidationMessage;

  List<String>? markerIds = [];
  @override
  void setFormStatus() {
    _log.i('Set the Form With Data: $formValueMap');
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
    }
  }

  // ----------------------------------------------
  // Back or next navigations
  Future onNextButton(PageController controller) async {
    if (pageIndex == 0) {
      // Name and description inputs
      if (isValidUserInputs(name: true, description: true)) {
        controller.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        pageIndex = pageIndex + 1;
        notifyListeners();
      }
    } else if (pageIndex == 1) {
      // quest type selection input
      controller.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      pageIndex = pageIndex + 1;
      notifyListeners();
    } else if (pageIndex == 2) {
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
        await createQuestAndNavigateBack(controller: controller);
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
    selectedQuestType = type;
    notifyListeners();
  }

  String getQuestTypeExplanation() {
    switch (selectedQuestType) {
      case QuestType.DistanceEstimate:
        return kDistanceEstimateDescription;
      case QuestType.TreasureLocationSearch:
        return kLocationSearchDescription;
      case QuestType.QRCodeHunt:
        return kGPSAreaHikeDescription;
      case QuestType.QRCodeHike:
        return kGPSAreaHikeDescription;
      case QuestType.GPSAreaHike:
        return kGPSAreaHikeDescription;
      case QuestType.GPSAreaHunt:
        return kGPSAreaHikeDescription;
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
          finishMarker: getAFKMarkers.last,
          name: nameValue.toString(),
          description: descriptionValue.toString(),
          type: selectedQuestType,
          markers: getAFKMarkers,
          afkCredits: afkCreditAmount),
    );

    final afkQuestAdded = await _questService.createAFKQuest(
      afkQuest: AFKQuest(
          id: questId,
          name: nameValue.toString(),
          description: descriptionValue.toString(),
          type: selectedQuestType.toSimpleString(),
          //type: _questType.toString().split('.').elementAt(1),
          afkCredits: afkCreditAmount,
          afkMarkersPositions: getAfkMarkersPosition,
          startAfkMarkersPositions: getAfkMarkersPosition.first,
          finishAfkMarkersPositions: getAfkMarkersPosition.last),
    );
    if (added || afkQuestAdded) {
      _log.i("Quest added successfully!");
      return true;
    }

    _displaySnackBars.snackBarNotCreatedQuest();
    return false;
  }

  Future<bool> createQuestAndNavigateBack(
      {required PageController controller}) async {
    creatingQuest = true;
    result = await _createQuest() ?? false;
    if (result) {
      AFKMarker startMarker = getAFKMarkers.first;
      resetMarkersValues();
      onBackButton(controller);
      await Future.delayed(Duration(milliseconds: 210));
      setBusy(true);
      await Future.delayed(Duration(milliseconds: 1000));
      addMarkerOnMap(
          pos: LatLng(startMarker.lat!, startMarker.lon!),
          number: 0); // number 0 gets green marker!
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 500));
      creatingQuest = false;
      notifyListeners();
      _displaySnackBars.snackBarCreatedQuest();
      await Future.delayed(Duration(milliseconds: 2000));
      setBusy(false);
      replaceWithParentHomeView();
    }
    return result;
  }

  void displayMarkersOnMap(LatLng pos) {
    if (selectedQuestType == QuestType.TreasureLocationSearch) {
      if (getAFKMarkers.length == 2) {
        snackbarService.showSnackbar(
            title: "Oops...",
            message: "Search quests only allow for two markers",
            duration: Duration(seconds: 1));
        return;
      }
    }
    addMarkerOnMap(pos: pos, number: getAFKMarkers.length);
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

  void showCreditsSuggestionDialog() {
    double totalDistanceInMeter = getTotalDistanceOfMarkers();
    int durationQuestInMinutes = getExpectedDurationOfQuestInMinutes(
        distanceMarkers: totalDistanceInMeter);
    int recommendedCredits =
        getRecommendedCredits(durationQuestInMinutes: durationQuestInMinutes);
    _dialogService.showDialog(
        title: "Recommendation",
        description:
            "Your markers are ${totalDistanceInMeter.toStringAsFixed(0)} meter apart. Your ${getShortQuestType(selectedQuestType)} is therefore expected to take about $durationQuestInMinutes minutes. We recommend giving $recommendedCredits credits which amounts to a default of ${creditsToScreenTime(recommendedCredits)} min screen time.");
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
    setBusy(false);
    notifyListeners();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
