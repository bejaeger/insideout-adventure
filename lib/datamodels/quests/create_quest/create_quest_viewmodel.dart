import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class CreateQuestViewModel extends FormViewModel with NavigationMixin {
  List<AFKMarker?>? _afkMarkers;
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final _questService = locator<QuestService>();
  final _markerService = locator<MarkerService>();
  CameraPosition? _initialCameraPosition;
  final _log = getLogger('CreateQuestViewModel');

  Marker? starterMarker;
  Marker? finishedMarker;

  CreateQuestViewModel(
      {required this.starterMarker, required this.finishedMarker});

  AFKMarker? _startMarker;
  AFKMarker? _finishMarker;

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
    finishedMarker = null;
    notifyListeners();
  }

  Future<void> createQuest({required Quest quest}) async {
    await _questService.createQuest(quest: quest);
  }

  void displayMarkersOnMap(LatLng pos) {
    setBusy(true);
    try {
      if (starterMarker == null ||
          (starterMarker != null && finishedMarker != null)) {
        starterMarker = returnMarkers(markerId: 'start', pos: pos);
        _log.i('This is the Started Marker $starterMarker');

        // Reset finish
        finishedMarker = null;
      } else {
        finishedMarker = returnMarkers(markerId: 'finish', pos: pos);
        _log.i('This is the Started Marker $finishedMarker');
      }
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

  //Get Start and Finish Markers;

  /*  Marker get getStartMarker => _starterMarker!;
  Marker get getFinishedMarker => _finishedMarker!; */
  //TODO: Refactor: This code might end up extending from an abstract class so far This is the approach.
  //Or End up creating a common Map Layout for all the views that involves Map.
  CameraPosition initialCameraPosition() {
    //if (_geolocationService.getUserPosition != null) {
    _initialCameraPosition = CameraPosition(
      target: LatLng(37.773972,
          -122.431297) /* LatLng(_geolocationService.getUserPosition!.latitude,
              _geolocationService.getUserPosition!.longitude) */
      ,
      zoom: 11.5,
    );
    return _initialCameraPosition!;
    /* } else {
      _log.wtf(
          'You Cannot Supply Empty Position ${_geolocationService.getUserPosition}');
    }
    return _initialCameraPosition!; */
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

  void setMarkersId({required AFKMarker? startOrFinishMarker}) {
    setBusy(true);
    _startMarker = startOrFinishMarker;
    setBusy(false);
    notifyListeners();
    _log.i("Harguilar You Have tried Look at the code Below");
    _log.i(nameValue);
    _log.i(_startMarker!);
  }

  List<AFKMarker?>? get getAFKMarkers => _afkMarkers;

  Future<void> getQuestMarkers() async {
    setBusy(true);
    // ignore: await_only_futures
    _afkMarkers = await _markerService.getQuestMarkers();
    setBusy(false);
    notifyListeners();
  }

  //TODO: Refactor the Code Below with the Abstract Class.
  Marker? returnMarkers({required LatLng pos, required String markerId}) {
    return Marker(
      markerId: MarkerId(markerId),
      infoWindow: InfoWindow(title: markerId),
      icon: markerId == 'start'
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: pos,
    );
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
