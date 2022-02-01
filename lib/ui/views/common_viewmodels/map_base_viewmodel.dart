import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// TODO: Could abstract the controller here by leaving it in the UI and
// TODO: using callback functions to the constructor

abstract class MapBaseViewModel extends QuestViewModel {
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker});
  void onMapCreated(GoogleMapController controller);
}
