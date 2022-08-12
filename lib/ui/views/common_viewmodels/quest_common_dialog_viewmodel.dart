import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';

class QuestCommonDialogViewModel extends ActiveQuestBaseViewModel {
  final log = getLogger("QuestCommonDialogViewModel");
  CollectCreditsStatus status;
  QuestCommonDialogViewModel({required this.status});

  bool get isCollectedCredits => status == CollectCreditsStatus.done;
  bool get isNeedToCollectCredits =>
      status == CollectCreditsStatus.todo ||
      status == CollectCreditsStatus.noNetwork;
  bool get isNoNetwork => status == CollectCreditsStatus.noNetwork;

  bool hasCollectedCreditsInDialog = false;

  Future getCredits() async {
    setBusy(true);
    final result = await handleSuccessfullyFinishedQuest();
    if (result == CollectCreditsStatus.done) {
      log.i("Credits succesfully collected");
      if (isNeedToCollectCredits) {
        hasCollectedCreditsInDialog = true;
      }
      status = CollectCreditsStatus.done;
    } else if (result == CollectCreditsStatus.todo) {
      setBusy(false);
      return;
    }
    setBusy(false);
  }

  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
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
  void loadQuestMarkers() {
    // TODO: implement loadQuestMarkers
  }

  @override
  Future maybeStartQuest(
      {required Quest? quest, void Function()? onStartQuestCallback}) {
    // TODO: implement maybeStartQuest
    throw UnimplementedError();
  }

  @override
  Future showInstructions() {
    // TODO: implement showInstructions
    throw UnimplementedError();
  }
}
