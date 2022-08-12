import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:afkcredits/utils/markers/markers.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  int pageIndex = 0;
  bool isLoading = false;
  bool result = false;
  QuestType? _questType;

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
      // VALIDATE INPUTS
      if (isValidUserInputs()) {
        controller.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        pageIndex = pageIndex + 1;
        notifyListeners();
      }
    } else if (pageIndex == 1) {
      // CREATE QUEST
      if (getAFKMarkers.length < 2) {
        return null;
      } else {
        await clearFieldsAndNavigate();
      }
    }
  }

  Future<void> currentUserPosition() async {
    setBusy(true);
    await _geoLocationService.setCurrentUserPosition();
    setBusy(false);
    notifyListeners();
  }

  bool isValidUserInputs() {
    resetValidationMessages();
    bool isValid = true;
    if (afkCreditAmountValue == null) {
      afkCreditsInputValidationMessage = 'Choose AFK Credits amount';
      isValid = false;
    }
    // also check type of afkCredits input
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
    if (nameValue == null) {
      nameInputValidationMessage = 'Please choose a valid quest name';
      isValid = false;
    }
    if (_questType == null) {
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

  Future<bool?> _createQuest() async {
    if (!isValidUserInputs()) return false;
    isLoading = true;
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
          type: _questType!,
          markers: getAFKMarkers,
          afkCredits: afkCreditAmount),
    );

    final afkQuestAdded = await _questService.createAFKQuest(
      afkQuest: AFKQuest(
          id: questId,
          name: nameValue.toString(),
          description: descriptionValue.toString(),
          type: _questType!.toSimpleString(),
          //type: _questType.toString().split('.').elementAt(1),
          afkCredits: afkCreditAmount,
          afkMarkersPositions: getAfkMarkersPosition,
          startAfkMarkersPositions: getAfkMarkersPosition.first,
          finishAfkMarkersPositions: getAfkMarkersPosition.last),
    );
    isLoading = false;
    notifyListeners();
    if (added || afkQuestAdded) {
      _log.i("Quest added successfully!");
      _displaySnackBars.snackBarCreatedQuest();
      return true;
    }

    _displaySnackBars.snackBarNotCreatedQuest();
    return false;
  }

  Future<bool> clearFieldsAndNavigate() async {
    result = await _createQuest() ?? false;
    if (result) {
      resetMarkersValues();
      replaceWithSponsorHomeView();
    }
    return result;
  }

  void displayMarkersOnMap(LatLng pos) {
    setBusy(true);
    addMarkerOnMap(pos: pos, number: getAFKMarkers.length);
    setBusy(false);
    notifyListeners();
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

  void setQuestType({required QuestType? questType}) {
    _questType = questType!;
  }
}
