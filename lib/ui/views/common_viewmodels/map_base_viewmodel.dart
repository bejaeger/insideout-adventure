import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapBaseViewModel extends QuestViewModel {
  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;
  final GeolocationService _geolocationService = locator<GeolocationService>();

  Set<Marker> markersOnMap = {};

  // Functions to override!
  void loadQuestMarkers();
  void updateMapMarkers({required AFKMarker afkmarker}) {}
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker});
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest});

  void onMapCreated(GoogleMapController controller) {
    if (hasActiveQuest) {
      setBusy(true);
      try {
        _googleMapController = controller;
        //Add Starter Marker
        loadQuestMarkers();
      } catch (error) {
        throw MapViewModelException(
            message: 'An error occured when creating the map',
            devDetails: "Error message from Map View Model $error ",
            prettyDetails:
                "An internal error occured on our side, sorry, please try again later.");
      }
      setBusy(false);
      notifyListeners();
    } else {
      _googleMapController = controller;
    }
  }

  CameraPosition initialCameraPosition() {
    if (hasActiveQuest) {
      return CameraPosition(
          target: LatLng(activeQuest.quest.startMarker!.lat!,
              activeQuest.quest.startMarker!.lon!),
          zoom: 16);
    } else {
      if (_geolocationService.getUserPosition != null) {
        final CameraPosition _initialCameraPosition = CameraPosition(
            target: LatLng(_geolocationService.getUserPosition!.latitude,
                _geolocationService.getUserPosition!.longitude),
            zoom: 16);
        return _initialCameraPosition;
      } else {
        return CameraPosition(
          target: getDummyCoordinates(),
          zoom: 16,
        );
      }
    }
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
