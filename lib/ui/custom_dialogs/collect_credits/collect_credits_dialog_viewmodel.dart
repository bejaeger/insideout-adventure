import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_common_dialog_viewmodel.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';

class CollectCreditsDialogViewModel extends QuestCommonDialogViewModel {
  CollectCreditsStatus status;
  CollectCreditsDialogViewModel({required this.status}) : super(status: status);

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    // TODO: implement addMarkerToMap
  }

  @override
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    // TODO: implement defineMarkersColour
    throw UnimplementedError();
  }

  @override
  void loadQuestMarkers() {
    // TODO: implement loadQuestMarkers
  }
}
