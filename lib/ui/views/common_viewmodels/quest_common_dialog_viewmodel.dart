import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';

class QuestCommonDialogViewModel extends ActiveQuestBaseViewModel {
  final log = getLogger("QuestStatusDialogViewModel");

  bool collectedCredits = false;
  Future getCredits() async {
    setBusy(true);
    final result = await handleSuccessfullyFinishedQuest();
    if (result == true) {
      log.i("Credits succesfully collected");
      collectedCredits = true;
    } else if (result == false) {
      return;
    }
    setBusy(false);
  }

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
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  @override
  void loadQuestMarkers() {
    // TODO: implement loadQuestMarkers
  }
}
