import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/marker_status.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/utils/markers/markers_in_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../../../constants/constants.dart';

class AddMarkersViewModel extends BaseViewModel {
  final log = getLogger("AddMarkersViewModel");
  final _geolocationService = locator<GeolocationService>();
  final markersServices = locator<MarkerService>();
  final snackbarService = locator<SnackbarService>();
  final markersInMap = locator<MarkersInMap>();
  final _questService = locator<QuestService>();
  List<Quest>? _getListOfQUest;

  List<AFKMarker>? afkMarkers;
  Set<Marker> markers = {};

  int? _group;

  AddMarkersViewModel();

  CameraPosition initialCameraPosition() {
    if (_geolocationService.getUserLivePositionNullable != null) {
      final CameraPosition _initialCameraPosition =
          CameraPosition(target: LatLng(latitude, longitude), zoom: 14);
      return _initialCameraPosition;
    } else {
      return CameraPosition(
        target: getDummyCoordinates(),
        zoom: 21,
      );
    }
  }

  List<Quest>? get getListOfQuest => _getListOfQUest;

  Future<void> setQuestList() async {
    setBusy(true);
    _getListOfQUest = await _questService.downloadNearbyQuests();
    addStartMarkers(quest: _getListOfQUest!);
    setBusy(false);
    notifyListeners();
  }

  void addStartMarkers({required List<Quest> quest}) {
    int idx = 0;
    bool found = false;
    while (idx < _getListOfQUest!.length) {
      for (AFKMarker _marker in _getListOfQUest![idx].markers) {
        if (_marker.id.isNotEmpty) {
          markers.add(
            Marker(
                markerId: MarkerId(_marker.id),
                position:
                    LatLng(_marker.lat ?? latitude, _marker.lon ?? longitude),
                infoWindow: InfoWindow(snippet: _getListOfQUest![idx].name),
                onTap: () {
                  log.i("TAPPED TAPPED");
                  int i = 0;
                  while (i < _getListOfQUest!.length) {
                    for (int j = 0;
                        j < _getListOfQUest![i].markers.length;
                        j++) {
                      if (_marker.id == _getListOfQUest![i].markers[j].id) {
                        log.i("HARGUILAR LOOK BELOW");
                        //Place This info into a Dialog or Bottosheet.
                        log.i(_getListOfQUest![i].name);
                        if (_marker.id == _getListOfQUest![i].markers.last.id) {
                          log.i(
                              'This Marker is finishing Markers ${_marker.id}');
                        } else if (_marker.id ==
                            _getListOfQUest![i].markers.first.id)
                          log.i('This Marker is Starter Markers ${_marker.id}');
                        else {
                          log.i(
                              'This Marker is In Between Markers ${_marker.id}');
                        }

                        found = true;
                        break;
                      }
                    }
                    if (found) {
                      break;
                    }
                    i++;
                  }
                }
                //icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
                ),
          );
        } else {
          log.i('We are not allowing Empty Values');
        }
      }
      idx++;
    }
    notifyListeners();
  }

  // notifyListeners();

  //add Markers to the Firebase
  Future<void> _addMarkersToDB({required AFKMarker markers}) async {
    try {
      await markersServices.addMarkers(markers: markers);
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

  Future<void> addMarkersToFirebase(
      {required MarkerStatus status, required Marker afkMarker}) async {
    var id = Uuid();
    String afkid = id.v1().toString().replaceAll('-', '');
    log.i("AFKID is: " + afkid);

    String qrCodeId = id.v1() + id.v4();
    await _addMarkersToDB(
      markers: AFKMarker(
          id: afkid,
          qrCodeId: qrCodeId,
          lat: afkMarker.position.latitude,
          lon: afkMarker.position.longitude,
          markerStatus: status),
    );
    markersInMap.resetMarkersValues();
  }

  void checkMarkerStatus({int? checkMarkerStatus}) {
    if (checkMarkerStatus == 1) {
      _group = 1;
    } else {
      _group = 2;
    }
    notifyListeners();
  }

  void setGroupNumber() {
    _group = null;
    notifyListeners();
  }

  int? get getGroupId => _group;

  void addMarkerToMap(LatLng position) {
    setBusy(true);
    markersInMap.addMarkersOnMap(pos: position);
    setBusy(false);
    notifyListeners();
  }
}
