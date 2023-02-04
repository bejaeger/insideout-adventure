import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';
import '../../../app/app.locator.dart';
import '../../../datamodels/dummy_data.dart';
import '../../../exceptions/mapviewmodel_exception.dart';
import '../../../services/geolocation/geolocation_service.dart';
import '../../../services/markers/marker_service.dart';

abstract class QuestMarkerViewModel extends FormViewModel {
  final GeolocationService geolocationService = locator<GeolocationService>();
  final MarkerService markersServices = locator<MarkerService>();
  final QuestService questService = locator<QuestService>();
  final logger = getLogger('QuestMarkerViewModel');

  Position? get userLocation => geolocationService.getUserLivePositionNullable;
  Set<Marker> get getMarkersOnMap => _markersOnMap;
  List<AFKMarker> get getAFKMarkers => _afkMarkers;

  Set<Marker> _markersOnMap = {};
  List<AFKMarker> _afkMarkers = [];

  CameraPosition initialCameraPosition() {
    if (userLocation != null) {
      if (questService.lonAtLatestQuestDownload == null &&
          questService.latAtLatestQuestDownload == null)
        return CameraPosition(
            target: LatLng(userLocation!.latitude, userLocation!.longitude),
            zoom: kInitialZoomBirdsView);
      else {
        return CameraPosition(
            target: LatLng(questService.latAtLatestQuestDownload!,
                questService.lonAtLatestQuestDownload!),
            zoom: kInitialZoomBirdsView);
      }
    } else {
      return CameraPosition(
        target: getDummyCoordinates(),
        zoom: 15,
      );
    }
  }

  void getLocation() async {
    await geolocationService.getAndSetCurrentLocation();
  }

  Marker _getMapMarker(
      {required LatLng pos,
      required String markerId,
      required int number,
      QuestType? questType}) {
    return Marker(
      markerId: MarkerId(markerId),
      icon: number == 0
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          : (questType == QuestType.GPSAreaHike ||
                  questType == QuestType.GPSAreaHunt)
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange)
              : questType == QuestType.TreasureLocationSearch
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
      position: pos,
      onTap: () {
        removeMarker(
          markerId: markerId,
        );
      },
    );
  }

  void resetMarkersValues() {
    _markersOnMap.clear();
    _afkMarkers = [];
    notifyListeners();
  }

  void removeMarker({required String markerId}) {
    _markersOnMap
        .removeWhere((element) => element.markerId == MarkerId(markerId));
    _afkMarkers.removeWhere((element) => element.id == markerId);
    notifyListeners();
  }

  void removeAllMarkers() {
    List<AFKMarker> markers = List.from(getAFKMarkers);
    for (AFKMarker m in markers) {
      removeMarker(markerId: m.id);
    }
  }

  void addMarkerOnMap(
      {required LatLng pos, required int number, QuestType? questType}) {
    try {
      var id = Uuid();
      var id2 = Uuid();
      final markerId = id.v1().toString().replaceAll('-', '');
      final qrdCdId = id2.v1().toString().replaceAll('-', '');

      _markersOnMap.add(
        _getMapMarker(
            markerId: markerId, pos: pos, number: number, questType: questType),
      );
      _afkMarkers.add(
        AFKMarker(
            id: markerId,
            qrCodeId: qrdCdId,
            lat: pos.latitude,
            lon: pos.longitude),
      );
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured when adding a marker on the map',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, sorry, please try again later.");
    }
  }
}
