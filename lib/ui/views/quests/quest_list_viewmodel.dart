

import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_category.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class QuestListViewModel extends BaseModel {

  void navigateToSingleQuestView() {
    navigationService.navigateTo(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(
      userRole: currentUser.role,
      initialBottomNavBarIndex: BottomNavBarIndex.map.index,
      questViewIndex: QuestViewIndex.singlequest, 
      questCategory: QuestCategory.minigame,
      ));
  }

  void navigateToMapView() {
    navigationService.navigateTo(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(
      userRole: currentUser.role,
      initialBottomNavBarIndex: BottomNavBarIndex.map.index,
      questViewIndex: QuestViewIndex.map));
  }
}