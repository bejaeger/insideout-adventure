import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_viewmodel.dart';
import 'package:stacked/src/state_management/reactive_service_mixin.dart';

class ActiveMapQuestViewModel extends MapViewModel {
  void addMarkers({required Quest quest}) {
    for (AFKMarker _m in quest.markers) {
      addMarkerToMap(quest: quest, afkmarker: _m);
    }
    notifyListeners();
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null && !hasActiveQuest) {
      final result = await startQuestMain(quest: quest);
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
}
