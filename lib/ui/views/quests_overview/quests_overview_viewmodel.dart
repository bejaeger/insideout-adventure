

import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class QuestsOverviewViewModel extends BaseModel {

  void navigateToSingleQuestView() {
    navigationService.navigateTo(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(
      userRole: currentUser.role,
      initialBottomNavBarIndex: BottomNavBarIndex.map,
      questViewIndex: QuestViewType.singlequest, 
      questType: QuestType.Minigame,
      ));
  }

  void navigateToMapView() {
    navigationService.navigateTo(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(
      userRole: currentUser.role,
      initialBottomNavBarIndex: BottomNavBarIndex.map,
      questViewIndex: QuestViewType.map));
  }
}