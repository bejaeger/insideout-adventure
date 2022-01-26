import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_viewmodel.dart';
import 'package:flutter/services.dart' show rootBundle;

class ActiveMapQuestViewModel extends MapViewModel {
  @override
  Future initialize({required Quest quest}) async {
    setBusy(true);
    await super.initialize(quest: quest);
    await rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
    setBusy(false);

    if (quest.type == QuestType.QRCodeHike) {
      addMarkers(quest: quest);
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

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null && !hasActiveQuest) {
      final result =
          await startQuestMain(quest: quest, countStartMarkerAsCollected: true);
      if (result == false) {
        log.wtf("Not starting quest, due to an unknown reason");

        return;
      }
      // quest started
      questService.listenToPosition(
          distanceFilter: kDistanceFilterHikeQuest, pushToNotion: true);
      await Future.delayed(Duration(seconds: 1));
      showStartSwipe = false;
      notifyListeners();
      resetSlider();
    }
  }

  String getNumberMarkersCollectedString() {
    // minus one because start marker is counted as collected from the start!
    return (numMarkersCollected - 1).toString() +
        " / " +
        (activeQuest.markersCollected.length - 1).toString();
  }
}
