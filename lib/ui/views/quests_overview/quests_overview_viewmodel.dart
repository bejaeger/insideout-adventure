import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class QuestsOverviewViewModel extends QuestViewModel with NavigationMixin {
  List<QuestType> get questTypes => questService.allQuestTypes;
  final logger = getLogger('ManageQuestViewModel');
  final _dialogService = locator<DialogService>();

  Future initializeQuests({bool? force}) async {
    setBusy(true);
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await getLocation(forceAwait: true, forceGettingNewPosition: false);
        await questService.loadNearbyQuests();
        await questService.sortNearbyQuests();
        questService.extractAllQuestTypes();
      }
    } catch (e) {
      log.wtf("Error when loading quests, this should never happen. Error: $e");
      await showGenericInternalErrorDialog();
    }
    setBusy(false);
  }

  void navigateToQuestsOfSpecificTypeView(QuestType type) {
    // Use the below to have the nav bottom bar visible!
    // navToQuestsOfSpecificTypeView(role: currentUser.role, type: type);
    navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
        userRole: currentUser.role,
        initialBottomNavBarIndex: currentUser.role == UserRole.adminMaster
            ? BottomNavBarIndex.home
            : BottomNavBarIndex.quest,
        questViewIndex: QuestViewType.singlequest,
        questType: type,
      ),
    );
  }

  void navigateToQuestViews({required int index}) {
    switch (index) {
      case 0:
        logger.i('User is Navigating to $navToCreateQuest');
        navToCreateQuest();
        break;
      case 1:
        logger.i('User is Navigating to $navToQuestOverView');
        _dialogService.showDialog();

        // navToQuestOverView();
        break;
      case 2:
        logger.i('User is Navigating to $navToQuestOverView');
        //navToQuestOverView();
        break;
      default:
        logger.i('User is Navigating to $navToCreateQuest');

        navToCreateQuest();
        break;
    }
  }

  void navigateToMapView() {
    navToMapView(role: currentUser.role);
  }
}
