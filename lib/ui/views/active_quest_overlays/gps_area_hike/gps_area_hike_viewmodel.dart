import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/hike_quest/hike_quest_viewmodel.dart';

class GPSAreaHikeViewModel extends HikeQuestViewModel {
  Future addQuestMarkers({required Quest quest}) async {
    animateCameraToQuestMarkers();
    if (quest.startMarker != null) {
      mapViewModel.resetMapMarkers();
      // add start marker & area
      mapViewModel.addMarkerToMap(
          quest: quest,
          afkmarker: quest.startMarker!,
          isStartMarker: true,
          handleMarkerAnalysisResultCustom: handleMarkerAnalysisResult);
      mapViewModel.addAreaToMap(
          quest: quest, afkmarker: quest.startMarker!, isStartArea: true);
      // add other potential markers and areas
      mapViewModel.addMarkers(
          quest: quest,
          handleMarkerAnalysisResultCustom: handleMarkerAnalysisResult);
      mapViewModel.addAreas(quest: quest);
    }
    //mapStateService.notify();
  }
}
