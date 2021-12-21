import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class QuestsOverviewViewModel extends QuestViewModel {
  List<QuestType> get questTypes => questService.allQuestTypes;

  Future initialize({bool? force}) async {
    setBusy(true);
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await Future.wait([
          getLocation(),
          questService.loadNearbyQuests(),
        ]);
        await questService.sortNearbyQuests();
        questService.extractAllQuestTypes();
      }
    } catch (e) {
      log.wtf("Error when loading quest, this should never happen. Error: $e");
      await showGenericInternalErrorDialog();
    }
    setBusy(false);
  }

  void navigateToQuestsOfSpecificTypeView(QuestType type) {
    // Use the below to have the nav bottom bar visible!
    navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
        userRole: currentUser.role,
        initialBottomNavBarIndex: BottomNavBarIndex.quest,
        questViewIndex: QuestViewType.singlequest,
        questType: type,
      ),
    );
  }

  void navigateToMapView() {
    navigationService.navigateTo(Routes.bottomBarLayoutTemplateView,
        arguments: BottomBarLayoutTemplateViewArguments(
            userRole: currentUser.role,
            initialBottomNavBarIndex: BottomNavBarIndex.quest,
            questViewIndex: QuestViewType.map));
  }
}
