import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RaiseQuestBottomSheetViewModel extends BaseModel {
  final log = getLogger("RaiseQuestBottomSheetViewModel");
  //final NavigationService? _navigationService = locator<NavigationService>();
  BitmapDescriptor? sourceIcon;
  Quest? _startedQuest;

  Set<Marker> _markersTmp = {};
  GoogleMapController? _googleMapController;

  Future navigateToAcceptPaymentsView() async {
    log.i("Clicked navigating to accept payments view (not yet implemented!)");
  }

  Set<Marker>? get getMarkers => _markersTmp;

  // ignore: non_constant_identifier_names
  CameraPosition initialCameraPosition() {
    final CameraPosition _initialCameraPosition = CameraPosition(
      //In Future I will change these values to dynamically Change the Initial Camera Position
      //Based on teh city
      target: LatLng(
          _startedQuest!.startMarker.lat!, _startedQuest!.startMarker.lon!),
      zoom: 9,
    );

    return _initialCameraPosition;
  }

  void initilizeStartedQuest() {
    sourceIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    if (questService.getStartedQuest! != null) {
      _startedQuest = questService.getStartedQuest!;
    }
  }

  void getQuestMarkers() {
    setBusy(true);
    if (_startedQuest != null) {
      for (AFKMarker _m in _startedQuest!.markers) {
        addMarker(afkmarker: _m);
      }
      _markersTmp = _markersTmp;
    } else {
      log.i('This started Quest Value is Null $_startedQuest!');
    }

    setBusy(false);
    notifyListeners();
  }

  BitmapDescriptor defineMarkersColour({required AFKMarker afkmarker}) {
    final index =
        activeQuest.quest.markers.indexWhere((element) => element == afkmarker);
    if (!activeQuest.markersCollected[index]) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    setBusy(true);
    try {
      _googleMapController = controller;
      //Add Starter Marker
      getQuestMarkers();
      //addMarker(markers: _startedQuest!.startMarker);
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured in the defining ',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
    setBusy(false);
    notifyListeners();
  }

  void addMarker({required AFKMarker afkmarker}) {
    try {
      _markersTmp.add(
        Marker(
          markerId: MarkerId(afkmarker.id),
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
        ),
      );
    } catch (e) {
      log.i("markers added {$e}");
    }
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
