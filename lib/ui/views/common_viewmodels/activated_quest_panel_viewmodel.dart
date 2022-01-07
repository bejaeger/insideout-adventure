import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_ui_style.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class ActivatedQuestPanelViewModel extends QuestViewModel {
  final log = getLogger("CustomAppBarViewModel");

  bool expanded = false;

  void toggleExpanded() {
    log.v("Toggle expanded");
    expanded = !expanded;
    notifyListeners();
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }

  Future openSuperUserSettingsDialog() async {
    await dialogService.showCustomDialog(variant: DialogType.SuperUserSettings);
  }
  //////////////////////////
  /// Navigate to the view that shows the currently activated quest
  ///
  ///

  void navigateToRelevantActiveQuestView() {
    log.i("Navigating to view with currently active quest");
    final questViewIndex =
        questService.getQuestUIStyle(quest: activeQuest.quest) ==
                QuestUIStyle.map
            ? QuestViewType.map
            : QuestViewType.singlequest;

    navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
        userRole: currentUser.role,
        questViewIndex: questViewIndex,
        initialBottomNavBarIndex: BottomNavBarIndex.quest,
        questType: activeQuest.quest.type,
      ),
    );
  }
}
