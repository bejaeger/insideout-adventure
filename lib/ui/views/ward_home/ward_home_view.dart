import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/credits_overlay/credits_overlay_view.dart';
import 'package:afkcredits/ui/views/map/main_map_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_viewmodel.dart';
import 'package:afkcredits/ui/views/ward_account/ward_account_view.dart';
import 'package:afkcredits/ui/views/ward_home/overlays/main_footer_overlay_view.dart';
import 'package:afkcredits/ui/views/ward_home/overlays/main_header_overlay_view.dart';
import 'package:afkcredits/ui/views/ward_home/overlays/quest_details_overlay_view.dart';
import 'package:afkcredits/ui/views/ward_home/overlays/switch_to_guardian_overlay.dart';
import 'package:afkcredits/ui/views/ward_home/ward_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/animations/fade_transition_animation.dart';
import 'package:afkcredits/ui/widgets/animations/map_loading_overlay.dart';
import 'package:afkcredits/ui/widgets/quest_reload_button.dart';
import 'package:afkcredits/ui/widgets/round_close_button.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

import '../../../datamodels/screentime/screen_time_session.dart';

final log = getLogger("REBUILD LOGGER");

class WardHomeView extends StatefulWidget {
  final bool showBewareDialog;
  final bool showNumberQuestsDialog;
  final ScreenTimeSession? screenTimeSession;
  const WardHomeView(
      {Key? key,
      this.showBewareDialog = false,
      this.screenTimeSession,
      this.showNumberQuestsDialog = false})
      : super(key: key);

  @override
  State<WardHomeView> createState() => _WardHomeViewState();
}

class _WardHomeViewState extends State<WardHomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WardHomeViewModel>.reactive(
      // viewModelBuilder: () => WardHomeViewModel(),
      viewModelBuilder: () => WardHomeViewModel(),
      // using singleton was kind of unstable :ooo
      // disposeViewModel: false,
      onModelReady: (model) {
        model.initialize(
          showBewareDialog: widget.showBewareDialog,
          showNumberQuestsDialog: widget.showNumberQuestsDialog,
          showSelectAvatarDialog: model.currentUser.newUser,
          screenTimeSession: widget.screenTimeSession,
        );
      },
      builder: (context, model, child) {
        bool showMainWidgets =
            (!(model.isShowingQuestDetails || model.hasActiveQuest) ||
                    model.isFadingOutQuestDetails) &&
                (model.previouslyFinishedQuest == null);
        return WillPopScope(
          onWillPop: () async {
            model.maybeRemoveWardAccountOverlay();
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
                      model.userService.guardianReference != null)
                    SwitchToGuardianAreaButton(
                      onTap: () async =>
                          await model.handleSwitchToGuardianEvent(),
                      show: showMainWidgets,
                    ),

                  //if (model.showLoadingScreen)
                  MapLoadingOverlay(
                    show: model.showFullLoadingScreen,
                    loadingQuests: model.showQuestLoadingScreen,
                  ),

                  if (!model.isBusy)
                    MainHeaderOverlayView(
                      show: showMainWidgets,
                      avatarIdx: model.avatarIdx,
                    ),

                  if (!model.isBusy)
                    MainFooterOverlayView(
                        show: showMainWidgets,
                        isUsingScreenTime:
                            model.currentScreenTimeSession != null),

                  if (!model.isBusy) WardAccountView(),

                  if (!model.isBusy) CreditsOverlayView(),

                  QuestListOverlayView(),

                  if (model.isShowingQuestDetails ||
                      model.hasActiveQuest ||
                      model.hasActivatedQuestToBeStarted)
                    QuestDetailsOverlayView(
                      startFadeOut: model.isFadingOutQuestDetails,
                    ),

                  // StepCounterOverlay(),

                  // only used for quest view at the moment!
                  OverlayedCloseButton(),

                  if (model.isFadingOutOverlay) FadeTransitionAnimation(),

                  // to test notifications during development
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: CreditsButton(
                  //     title: model.notId != null
                  //         ? "Dismiss notification"
                  //         : "Create notification",
                  //     onTap:
                  //     model.notId != null
                  //         ? model.dismissTestNotification
                  //         : model.createTestNotification,
                  //   ),
                  // )
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
              padding: const EdgeInsets.only(bottom: 12),
              child: RoundCloseButton(
                onTap: model.removeQuestListOverlay,
                color: kcCultured,
              ),
            )
          : SizedBox(height: 0, width: 0),
    );
  }
}
