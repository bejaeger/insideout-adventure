import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:afkcredits/utils/markers/markers.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateQuestViewModel extends AFKMarks with NavigationMixin {
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final _questService = locator<QuestService>();
  //CameraPosition? _initialCameraPosition;
  final _displaySnackBars = DisplaySnackBars();

  final _log = getLogger('CreateQuestViewModel');

  List<String>? markerIds = [];
  @override
  void setFormStatus() {
    _log.i('Set the Form With Data: $formValueMap');
    if (nameValue?.isEmpty ?? true) {
      setValidationMessage('You Must Give a Value into this field');
    }
  }

  Future<bool?> createQuest({required Quest quest}) async {
    final added = await _questService.createQuest(quest: quest);
    if (added!) {
      _displaySnackBars.snackBarCreatedQuest();
      return true;
    } else {
      _displaySnackBars.snackBarNotCreatedQuest();
    }
    return false;
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
    _googleMapController!.dispose();
    super.dispose();
  }
}
