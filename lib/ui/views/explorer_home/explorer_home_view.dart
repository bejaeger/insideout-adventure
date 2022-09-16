import 'package:afkcredits/ui/views/credits_overlay/credits_overlay_view.dart';
import 'package:afkcredits/ui/views/explorer_account/explorer_account_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/main_footer_overlay_view.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/main_header_overlay.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/quest_details_overlay_view.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/switch_to_parents_overlay.dart';
import 'package:afkcredits/ui/views/map/main_map_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/animations/fade_transition_animation.dart';
import 'package:afkcredits/ui/widgets/animations/map_loading_overlay.dart';
import 'package:afkcredits/ui/widgets/quest_reload_button.dart';
import 'package:afkcredits/ui/widgets/round_close_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/app/app.logger.dart';

final log = getLogger("REBUILD LOGGER");

class ExplorerHomeView extends StatefulWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  State<ExplorerHomeView> createState() => _ExplorerHomeViewState();
}

class _ExplorerHomeViewState extends State<ExplorerHomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
      viewModelBuilder: () => ExplorerHomeViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        bool showMainWidgets =
            (!(model.isShowingQuestDetails || model.hasActiveQuest) ||
                    model.isFadingOutQuestDetails) &&
                (model.previouslyFinishedQuest == null);

        //log.wtf("==>> Rebuild ExplorerHomeView");
        return WillPopScope(
          onWillPop: () async {
            model.maybeRemoveExplorerAccountOverlay();
            model.maybeRemoveQuestListOverlay();
            return false;
          },
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  // bottom layer
                  //if (!model.isBusy)
                  if (!model.isBusy)
                    MainMapView(callback: () => model.notifyListeners()),

                  if (!model.isAvatarView)
                    ReloadQuestsButton(
                      show: model.showReloadQuestButton,
                      onPressed: model.loadNewQuests,
                      isBusy: model.isReloadingQuests,
                    ),

                  if (model.currentUserNullable?.createdByUserWithId != null &&
                      model.userService.sponsorReference != null)
                    SwitchToParentsAreaButton(
                      onTap: () async =>
                          await model.handleSwitchToSponsorEvent(),
                      show: showMainWidgets,
                    ),

                  if (model.showLoadingScreen)
                    MapLoadingOverlay(show: model.showFullLoadingScreen),

                  // TODO: Can also make MainHeader a view!
                  if (!model.isBusy)
                    MainHeader(
                        percentageOfNextLevel: model.percentageOfNextLevel,
                        currentLevel: model.currentLevel(),
                        onAvatarPressed: model.showExplorerAccountOverlay,
                        show: showMainWidgets,
                        onDevFeaturePressed: model
                            .openSuperUserSettingsDialog, // model.showNotImplementedSnackbar,
                        onCreditsPressed: model.showCreditsOverlay,
                        balance: model.currentUserStats.afkCreditsBalance),

                  if (!model.isBusy)
                    MainFooterOverlayView(
                        show: showMainWidgets,
                        isUsingScreenTime:
                            model.currentScreenTimeSession != null),

                  if (!model.isBusy) ExplorerAccountView(),

                  if (!model.isBusy) CreditsOverlayView(),

                  QuestListOverlayView(),

                  if (model.isShowingQuestDetails || model.hasActiveQuest)
                    QuestDetailsOverlayView(
                        startFadeOut: model.isFadingOutQuestDetails),

                  // StepCounterOverlay(),

                  // only used for quest view at the moment!
                  OverlayedCloseButton(),

                  if (model.isFadingOutOverlay) FadeTransitionAnimation(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OverlayedCloseButton extends StatelessWidget {
  const OverlayedCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestListOverlayViewModel>.reactive(
      viewModelBuilder: () => QuestListOverlayViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => model.isShowingQuestList
          ? Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 20),
              child: RoundCloseButton(onTap: model.removeQuestListOverlay),
            )
          : SizedBox(height: 0, width: 0),
    );
  }
}
