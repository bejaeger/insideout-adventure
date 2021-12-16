import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class QuestsOverviewViewModel extends QuestViewModel {
  List<QuestType> questTypes = [];

  Future initialize() async {
    setBusy(true);
    try {
      await loadQuests();
      extractQuestTypes();
    } catch (e) {
      log.wtf("Error when loading quest, this should never happen. Error: $e");
      await showGenericInternalErrorDialog();
    }
    setBusy(false);
  }

  void extractQuestTypes() {
    if (nearbyQuests.isNotEmpty) {
      for (Quest _q in nearbyQuests) {
        if (!questTypes.any((element) => element == _q.type)) {
          questTypes.add(_q.type);
        }
      }
    } else {
      log.w('No nearby quests found');
    }
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
