import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RaiseQuestBottomSheetViewModel extends BaseModel {
  final Quest quest;
  RaiseQuestBottomSheetViewModel({required this.quest});

  final log = getLogger("RaiseQuestBottomSheetViewModel");

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
      target: LatLng(quest.startMarker!.lat!, quest.startMarker!.lon!),
      zoom: 14,
    );

    return _initialCameraPosition;
  }

  void getQuestMarkers() {
    setBusy(true);
    for (AFKMarker _m in quest.markers!) {
      addMarker(afkmarker: _m);
    }
    setBusy(false);
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
  }

  void addMarker({required AFKMarker afkmarker}) {
    try {
      _markersTmp.add(
        Marker(
          markerId: MarkerId(afkmarker.id),
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    } catch (e) {
      log.i("markers added {$e}");
    }
  }

  String? checkSponsoringSentence() {
    if (hasEnoughSponsoring(quest: quest)) {
      return null;
    } else {
      return "You don't have enough AFK Credits funds to earn ${quest.afkCredits} credits. Ask a sponsor to support you :)";
    }
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
