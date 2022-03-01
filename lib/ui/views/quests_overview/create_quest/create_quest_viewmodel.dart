import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:afkcredits/utils/markers/markers.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../../datamodels/quests/quest.dart';
import '../../../../enums/quest_type.dart';
import '../../../../services/geolocation/geolocation_service.dart';

class CreateQuestViewModel extends AFKMarks with NavigationMixin {
  final _log = getLogger('CreateQuestViewModel');
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final _navigationService = locator<NavigationService>();
  final _questService = locator<QuestService>();
  final _geoLocationService = locator<GeolocationService>();
  //CameraPosition? _initialCameraPosition;
  final _displaySnackBars = DisplaySnackBars();
  bool isLoading = false;
  bool result = false;
  QuestType? _questType;

  List<String>? markerIds = [];
  @override
  void setFormStatus() {
    _log.i('Set the Form With Data: $formValueMap');
    if (nameValue?.isEmpty ?? true) {
      setValidationMessage('You Must Give a Value into this field');
    }
  }

  Future<void> currentUserPosition() async {
    setBusy(true);
    await _geoLocationService.setCurrentUserPosition();
    setBusy(false);
    notifyListeners();
  }

  Future<bool?> _createQuest() async {
    if (afkCreditAmountValue?.toString() == null ||
        nameValue?.toString() == null ||
        descriptionValue?.toString() == null) {
      _log.wtf('You Are Giving me Empty Fields');
      displayEmptyTextsSnackBar();
      return false;
    } else {
      isLoading = true;
      notifyListeners();
      num afkCreditAmount = num.parse(afkCreditAmountValue.toString());
      var id = Uuid();
      final questId = id.v1().toString().replaceAll('-', '');
      final added = await _questService.createQuest(
        quest: Quest(
            id: questId,
            startMarker: getAFKMarkers.first,
            finishMarker: getAFKMarkers.last,
            name: nameValue.toString(),
            description: descriptionValue.toString(),
            type: _questType ?? QuestType.Hunt,
            markers: getAFKMarkers,
            afkCredits: afkCreditAmount),
      );
      isLoading = false;
      notifyListeners();
      if (added!) {
        _displaySnackBars.snackBarCreatedQuest();
        return true;
      }
    }
    return false;
  }

  Future<void> clearFieldsAndNavigate() async {
    result = await _createQuest() ?? false;
    if (result) {
      resetMarkersValues();
      _navigationService.back();
    } else {
      _displaySnackBars.snackBarNotCreatedQuest();
    }
  }

  void displayMarkersOnMap(LatLng pos) {
    setBusy(true);
    addMarkersOnMap(pos: pos);
    setBusy(false);
    notifyListeners();
  }

  void displayEmptyTextsSnackBar() {
    _displaySnackBars.snackBarTextBoxEmpty();
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

  void setQuestType({required QuestType questType}) {
    _questType = questType;
  }
}
