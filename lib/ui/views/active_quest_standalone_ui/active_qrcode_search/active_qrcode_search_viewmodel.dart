import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_base_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:afkcredits/app/app.logger.dart';

class ActiveQrCodeSearchViewModel extends MapBaseViewModel {
  final MarkerService _markerService = locator<MarkerService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();

  List<AFKMarker> foundObjects = [];
  bool? closeby;
  final log = getLogger("ActiveQrCodeSearchViewModel");

  void initialize({required Quest? quest}) async {
    runBusyFuture(_geolocationService.getAndSetCurrentLocation());
    if (quest != null) {
      closeby = await _markerService.isUserCloseby(marker: quest.startMarker);
      notifyListeners();
    }
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null) {
      resetPreviousQuest();
      log.i("Starting Qr code search quest with name ${quest.name}");
      setBusy(true);
      final position = await _geolocationService.getAndSetCurrentLocation();
      if (!(await checkAccuracy(position: position))) {
        setBusy(false);
        return false;
      }
      final result = await startQuestMain(quest: quest);
      setBusy(false);
      if (result is bool && result == false) {
        navigateBack();
      } else {}
    } else {
      log.w("Not starting quest, quest is probably already running");
    }
  }

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker? afkmarker}) {
    if (afkmarker == null) return;
    markersOnMap.add(
      Marker(
          markerId: MarkerId(afkmarker
              .id), // google maps marker id of start marker will be our quest id
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
          infoWindow: InfoWindow(snippet: foundObjects.length.toString()),
          icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
          onTap: () async {
            bool adminMode = false;
            if (userIsAdmin) {
              adminMode = await showAdminDialogAndGetResponse();
              if (adminMode) {
                String qrCodeString =
                    qrCodeService.getQrCodeStringFromMarker(marker: afkmarker);
                navigationService.navigateTo(Routes.qRCodeView,
                    arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
              }
            }
          }),
    );
    notifyListeners();
  }

  @override
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  @override
  void loadQuestMarkers() {
    // for testing purposes, display location of qr code markers
    if (userIsAdmin) {
      for (AFKMarker _m in activeQuest.quest.markers) {
        addMarkerToMap(quest: activeQuest.quest, afkmarker: _m);
      }
    }

    // TODO:
    // This should be used to specify an area on the map that should
    // be searched through for markers!
    return;
  }

  @override
  Future handleValidQrCodeScanEvent(QuestQRCodeScanResult result) async {
    if (!hasActiveQuest) {
      log.wtf("No quest running");
      return;
    }
    if (result.marker != null) {
      if (hasActiveQuest) {
        log.i("Scanned marker sucessfully collected!");
        // add scanned marker on map!
        addMarkerToMap(quest: activeQuest.quest, afkmarker: result.marker!);

        // this might be redundant as this is also taken care of in quest service
        foundObjects.add(result.marker!);

        if (questService.isAllMarkersCollected) {
          checkQuestAndFinishWhenCompleted();
        } else {
          await dialogService.showDialog(
              title: "Successfully collected marker!",
              description: getActiveQuestProgressDescription());
          if (result.marker!.nextLocationHint != null)
            await dialogService.showDialog(
                title: "Next hint",
                description: result.marker!.nextLocationHint!);
        }
        notifyListeners();
      }
    }
  }

  // -------------------------------------
  void resetPreviousQuest() {
    markersOnMap = {};
    foundObjects = [];
  }
}
