import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:afkcredits/utils/markers/markers.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class CreateQuestViewModel extends FormViewModel with NavigationMixin {
  List<AFKMarker?>? _afkMarkers;
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final _questService = locator<QuestService>();
  final _markerService = locator<MarkerService>();
  CameraPosition? _initialCameraPosition;
  final displaySnackBars = DisplaySnackBars();
  final markers = Marks();
  final _log = getLogger('CreateQuestViewModel');

  bool found = false;

  Marker? starterMarker;
  int index = 0;
  Marker? finishedMarker;
  //Set<AFKMarker?>? afkCredits = {};
  List<AFKMarker> afkCredits = [];
  Set<Marker> markersOnMap = {};

  List<String>? markerIds = [];
  @override
  void setFormStatus() {
    _log.i('Set the Form With Data: $formValueMap');
    if (nameValue?.isEmpty ?? true) {
      setValidationMessage('You Must Give a Value into this field');
    }
    // TODO: implement setFormStatus
  }

  void resetMarkersValues() {
    starterMarker = null;
    //  markers = null;
    markersOnMap = {};
    finishedMarker = null;
    notifyListeners();
  }

  Future<bool?> createQuest({required Quest quest}) async {
    if (quest != null) {
      bool? added = await _questService.createQuest(quest: quest);
      if (added!) {
        displaySnackBars.snackBarCreatedQuest(quest: quest);
        this.navBackToPreviousView();
      } else {
        displaySnackBars.snackBarNotCreatedQuest(quest: quest);
      }
    }
  }

  void displayMarkersOnMap(LatLng pos) {
    setBusy(true);
    try {
      var id = Uuid();
      var id2 = Uuid();
      final markerId = id.v1().toString().replaceAll('-', '');
      final qrdCdId = id2.v1().toString().replaceAll('-', '');

      _log.i('The Current Marker Id is: ${markerId}');

      if (markersOnMap.length > 0) {
        for (Marker marker in markersOnMap) {
          if (marker.markerId.toString() == markerId) {
            found = true;
            removeMarker(marker: marker);
            break;
          }
        }
      } else {
        markersOnMap.add(markers.addMarkers(markerId: markerId, pos: pos));
        afkCredits.add(
          markers.returnAFK(pos: pos, markerId: markerId, qrCode: qrdCdId),
        );
      }

      if (!found) {
        markersOnMap.add(markers.addMarkers(markerId: markerId, pos: pos));
        afkCredits.add(
          markers.returnAFK(pos: pos, markerId: markerId, qrCode: qrdCdId),
        );
      }
      // _log.i('This is the Started Marker $markersOnMap');

      //Add Starter Marker
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured when creating the map',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, sorry, please try again later.");
    }
    setBusy(false);
    notifyListeners();
  }

  //TODO: Refactor: This code might end up extending from an abstract class so far This is the approach.
  //Or End up creating a common Map Layout for all the views that involves Map.
  CameraPosition initialCameraPosition() {
    //if (_geolocationService.getUserPosition != null) {
    _initialCameraPosition = CameraPosition(
      target: LatLng(37.773972, -122.431297)

      /* LatLng(_geolocationService.getUserPosition!.latitude,
              _geolocationService.getUserPosition!.longitude) */
      ,
      zoom: 11.5,
    );
    return _initialCameraPosition!;
  }

  void onMapCreated(GoogleMapController controller) {
    setBusy(true);
    try {
      _googleMapController = controller;
      //Add Starter Marker
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured when creating the map',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, sorry, please try again later.");
    }
    setBusy(false);
    notifyListeners();
  }

/*   void setMarkersId({required AFKMarker? startOrFinishMarker}) {
    setBusy(true);
    //_startMarker = startOrFinishMarker;
    setBusy(false);
    notifyListeners();
    _log.i("Harguilar You Have tried Look at the code Below");
    _log.i(nameValue);
    //_log.i(_startMarker!);
  } */

  List<AFKMarker?>? get getAFKMarkers => _afkMarkers;

  Future<void> getQuestMarkers() async {
    setBusy(true);
    // ignore: await_only_futures
    _afkMarkers = await _markerService.getQuestMarkers();
    setBusy(false);
    notifyListeners();
  }

  //TODO: Refactor the Code Below with the Abstract Class.

  void removeMarker({required Marker marker}) {
    markersOnMap.remove(marker);
    notifyListeners();
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
