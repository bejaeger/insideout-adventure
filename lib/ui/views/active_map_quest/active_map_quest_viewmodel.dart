import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_viewmodel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

class ActiveMapQuestViewModel extends MapViewModel {
  @override
  Future initialize({required Quest quest}) async {
    setBusy(true);
    await super.initialize(quest: quest);
    await rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
    setBusy(false);

    addMarkers(quest: quest);
    if (quest.type == QuestType.QRCodeHike) {
      addAreas(quest: quest);
    } else if (quest.type == QuestType.GPSAreaHike) {
      addNextArea(quest: quest);
    } else {
      log.e("Code will crash, unknown quest type");
      return;
    }
    addStartMarkerToMap(quest: quest, afkmarker: quest.startMarker!);
    addStartAreaToMap(quest: quest, afkmarker: quest.startMarker!);
    notifyListeners();
  }

  void addStartMarkers({required Quest quest}) {
    for (AFKMarker _m in quest.markers) {
      addMarkerToMap(quest: quest, afkmarker: _m);
    }
    // notifyListeners();
  }

  void addMarkers({required Quest quest}) {
    for (AFKMarker _m in questService.markersToShowOnMap(questIn: quest)) {
      addMarkerToMap(quest: quest, afkmarker: _m);
    }
    // notifyListeners();
  }

  void addAreas({required Quest quest}) {
    for (AFKMarker _m in questService.markersToShowOnMap(questIn: quest)) {
      addAreaToMap(quest: quest, afkmarker: _m);
    }
    // notifyListeners();
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null && !hasActiveQuest) {
      final result =
          await startQuestMain(quest: quest, countStartMarkerAsCollected: true);
      if (result == false) {
        log.wtf("Not starting quest, due to an unknown reason");
        resetSlider();
        return;
      }
      // quest started
      questService.listenToPosition(
        distanceFilter: kDistanceFilterHikeQuest,
        pushToNotion: true,
        viewModelCallback: (userLivePosition) async {
          log.wtf("Updating position!");
          checkIfInAreaOfMarker(
              marker: questService.getNextMarker(), position: userLivePosition);
        },
      );
      await Future.delayed(Duration(seconds: 1));
      showStartSwipe = false;
      notifyListeners();
      //resetSlider();
    }
  }

  Future checkIfInAreaOfMarker(
      {required AFKMarker? marker, required Position position}) async {
    if (marker != null) {
      if (marker.lat != null && marker.lon != null) {
        bool isCloseby = geolocationService.countAsCloseByMarker(
            position: position,
            lat: marker.lat!,
            lon: marker.lon!,
            threshold: kDistanceFromCenterOfArea);
        if (isCloseby) {
          vibrateAlert();
          questService.pausePositionListener();
          await showQrCodeIsInAreaDialog();
          questService.resumePositionListener();
        }
      }
    }
  }

  Future showQrCodeIsInAreaDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.QrCodeInArea,
      data: {
        "scanQrCodeFunction": scanQrCode,
      },
    );
  }

  String getNumberMarkersCollectedString() {
    // minus one because start marker is counted as collected from the start!
    return (numMarkersCollected - 1).toString() +
        " / " +
        (activeQuest.markersCollected.length - 1).toString();
  }
}
