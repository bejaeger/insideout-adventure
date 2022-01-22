import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_viewmodel.dart';
import 'package:stacked/src/state_management/reactive_service_mixin.dart';

class ActiveMapQuestViewModel extends MapViewModel {
  @override
  void initialize({required Quest quest}) {
    super.initialize(quest: quest);

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
    for (AFKMarker _m in quest.markers) {
      addMarkerToMap(quest: quest, afkmarker: _m);
    }
    // notifyListeners();
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null && !hasActiveQuest) {
      final result = await startQuestMain(quest: quest, countStartMarkerAsCollected: true);
      if (result is bool && result == true) {
        await Future.delayed(Duration(seconds: 1));
        showStartSwipe = false;
        notifyListeners();
      } else {
        log.wtf("Not starting quest, due to an unknown reason");
      }
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
