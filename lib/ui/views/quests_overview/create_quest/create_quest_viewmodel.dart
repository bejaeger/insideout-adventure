import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:afkcredits/utils/markers/markers.dart';
import 'package:afkcredits/utils/markers/markers_in_map.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class CreateQuestViewModel extends FormViewModel with NavigationMixin {
  List<AFKMarker?>? _afkMarkers;
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final _questService = locator<QuestService>();
  final _markerService = locator<MarkerService>();
  CameraPosition? _initialCameraPosition;
  final displaySnackBars = DisplaySnackBars();
  final markersInMap = locator<MarkersInMap>();
  final markers = AFKMarks();

  final _log = getLogger('CreateQuestViewModel');

  Marker? starterMarker;
  int index = 0;
  Marker? finishedMarker;

  List<String>? markerIds = [];
  @override
  void setFormStatus() {
    _log.i('Set the Form With Data: $formValueMap');
    if (nameValue?.isEmpty ?? true) {
      setValidationMessage('You Must Give a Value into this field');
    }
  }

  void resetMarkersValues() {
    markersInMap.resetMarkersValues();
    notifyListeners();
  }

  Future<bool?> createQuest({required Quest quest}) async {
    if (quest != null) {
      final added = await _questService.createQuest(quest: quest);
      if (added!) {
        displaySnackBars.snackBarCreatedQuest(/* quest: quest */);
        await Future.delayed(
          const Duration(seconds: 4),
          () {
            this.navBackToPreviousView();
          },
        );
      } else {
        displaySnackBars.snackBarNotCreatedQuest(/* quest: quest */);
      }
    }
  }

  void displayMarkersOnMap(LatLng pos) {
    setBusy(true);
    markersInMap.addMarkersOnMap(pos: pos);
    setBusy(false);
    notifyListeners();
  }

  //TODO: Refactor: This code might end up extending from an abstract class so far This is the approach.
  //Or End up creating a common Map Layout for all the views that involves Map.
  CameraPosition initialCameraPosition() {
    _initialCameraPosition = CameraPosition(
      target: LatLng(37.773972, -122.431297),
      zoom: 11.5,
    );
    return _initialCameraPosition!;
  }

  void onMapCreated(GoogleMapController controller) {
    setBusy(true);
    _googleMapController = controller;
    setBusy(false);
    notifyListeners();
  }

  List<AFKMarker?>? get getAFKMarkers => _afkMarkers;

  Future<void> getQuestMarkers() async {
    setBusy(true);
    // ignore: await_only_futures
    _afkMarkers = await _markerService.getQuestMarkers();
    setBusy(false);
    notifyListeners();
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
