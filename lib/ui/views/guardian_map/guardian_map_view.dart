import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/guardian_map/guardian_map_viewmodel.dart';
import 'package:afkcredits/ui/views/map/google_map_screen.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/animations/map_loading_overlay.dart';
import 'package:afkcredits/ui/widgets/common_quest_details_header.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/custom_safe_area.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/quest_reload_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GuardianMapView extends StatelessWidget {
  const GuardianMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GuardianMapViewModel>.reactive(
      viewModelBuilder: () => GuardianMapViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        return CustomSafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              title: model.selectedQuest == null ? "Quests" : "Quest Details",
              onBackButton: model.selectedQuest == null ? model.popView : null,
            ),
            floatingActionButton: model.selectedQuest != null
                ? null
                : AFKFloatingActionButton(
                    icon: Icon(Icons.add, size: 32, color: Colors.white),
                    onPressed: () => model.navToCreateQuest(fromMap: true),
                  ),
            body: MainStack(
              onBackPressed: model.popQuestDetails,
              showBackButton: model.selectedQuest != null,
              child: Stack(
                children: [
                  model.isBusy
                      ? MapLoadingOverlay(
                          show: true,
                          loadingQuests: false,
                        )
                      : GoogleMapScreen(
                          model: locator<MapViewModel>(),
                          callback: () => model.notifyListeners(),
                          showCreateQuestDialog: model.showCreateQuestDialog,
                        ),
                  ReloadQuestsButton(
                    show: model.showReloadQuestButton,
                    onPressed: model.loadNewQuests,
                    isBusy: model.isReloadingQuests,
                  ),
                  if (model.selectedQuest != null)
                    CommonQuestDetailsHeader(
                      quest: model.selectedQuest,
                      isGuardianAccount: model.isGuardianAccount,
                      showInstructionsDialog: model.showQuestInstructionDialog,
                    ),
                  if (model.isDeletingQuest || model.isBusy)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: AFKProgressIndicator(
                        alignment: Alignment.bottomCenter,
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
