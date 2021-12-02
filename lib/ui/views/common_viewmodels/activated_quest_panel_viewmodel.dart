import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart';

class ActivatedQuestPanelViewModel extends QuestViewModel {
  final log = getLogger("CustomAppBarViewModel");
  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }

  //////////////////////////
  /// Navigate to the view that shows the currently activated quest
  ///
  ///

  void navigateToRelevantActiveQuestView() {
    log.i("Navigating to view with currently active quest");
    final questViewIndex = activeQuest.quest.type == QuestType.Minigame
        ? QuestViewType.singlequest
        : QuestViewType.map;
    
    
    navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
        userRole: currentUser.role,
        questViewIndex: questViewIndex,
        initialBottomNavBarIndex: BottomNavBarIndex.map,
        questType: activeQuest.quest.type,
      ),
    );
  }

}
