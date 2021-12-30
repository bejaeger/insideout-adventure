import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class QuestsOverviewViewModel extends QuestViewModel with NavigationMixin {
  List<QuestType> get questTypes => questService.allQuestTypes;

  Future initialize({bool? force}) async {
    setBusy(true);
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await getLocation(forceAwait: true);
        await questService.loadNearbyQuests();
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
    navToQuestsOfSpecificTypeView(role: currentUser.role, type: type);
/*     navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
        userRole: currentUser.role,
        initialBottomNavBarIndex: BottomNavBarIndex.quest,
        questViewIndex: QuestViewType.singlequest,
        questType: type,
      ),
    ); */
  }

  void navigateToMapView() {
    navToMapView(role: currentUser.role);
/*     navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
          userRole: currentUser.role,
          initialBottomNavBarIndex: BottomNavBarIndex.quest,
          questViewIndex: QuestViewType.map),
    ); */
  }
}
