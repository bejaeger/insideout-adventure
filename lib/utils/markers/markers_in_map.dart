/* import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/utils/markers/markers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MarkersInMap {
  final _afkMarkers = AFKMarks();
  //Set<Marker> _markersOnMap = {};
  List<AFKMarker> _afkCredits = [];
  Marker? _singleMarkerOnMap;
  AFKMarker? _singleAfkCredits;

  bool found = false;
  //Set<Marker> get getMarkersOnMap => _markersOnMap;
  Marker get getSingleMarkersOnMap => _singleMarkerOnMap!;
  List<AFKMarker> get getAFKMarkers => _afkCredits;
  AFKMarker get getSingleAFKMarkers => _singleAfkCredits!;

  final questService = locator<QuestService>();

  void addMarkersOnMap({required LatLng pos}) {
    try {
      var id = Uuid();
      var id2 = Uuid();
      final markerId = id.v1().toString().replaceAll('-', '');
      final qrdCdId = id2.v1().toString().replaceAll('-', '');

      addMarkersAndAFKCredits(
          markerId: markerId, position: pos, qrdCodeId: qrdCdId);
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured when creating the map',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, sorry, please try again later.");
    }
  }

  void addMarkerOnMap({required LatLng pos}) {
    try {
      var id = Uuid();
      var id2 = Uuid();
      final markerId = id.v1().toString().replaceAll('-', '');
      final qrdCdId = id2.v1().toString().replaceAll('-', '');

      _addSingleMarkerAndAFKCredits(
          markerId: markerId, position: pos, qrdCodeId: qrdCdId);
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured when creating the map',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, sorry, please try again later.");
    }
  }

  void addMarkersAndAFKCredits(
      {required String markerId,
      required LatLng position,
      required String qrdCodeId}) {
    _afkMarkers.addMarkersAndAFKCredits(
        markerId: markerId, position: position, qrdCodeId: qrdCodeId);
    /*    _markersOnMap.add(
      _afkMarkers.addMarkers(markerId: markerId, pos: position),
    ); */

    /* _afkCredits.add(
      _afkMarkers.returnAFK(
          pos: position, markerId: markerId, qrCode: qrdCodeId),
    ); */
  }

  void _addSingleMarkerAndAFKCredits(
      {required String markerId,
      required LatLng position,
      required String qrdCodeId}) {
    _singleMarkerOnMap =
        _afkMarkers.addMarkers(markerId: markerId, pos: position);

    _singleAfkCredits = _afkMarkers.returnAFK(
        pos: position, markerId: markerId, qrCode: qrdCodeId);
  }

  void resetMarkersValues() {
    // _markersOnMap = {};
    _afkCredits = [];
  }

  /*  void removeMarker({required Marker marker}) {
    if (_markersOnMap.contains(marker)) {
      _markersOnMap.remove(marker);
    }
  } */
}
 */