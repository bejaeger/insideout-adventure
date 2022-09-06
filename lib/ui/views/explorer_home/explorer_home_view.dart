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
        //log.wtf("==>> Rebuild ExplorerHomeView");
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                // bottom layer
                //if (!model.isBusy)
                if (!model.isBusy) MainMapView(),

                if (model.currentUser.createdByUserWithId != null)
                  SwitchToParentsAreaButton(
                    onTap: model.handleSwitchToSponsorEvent,
                    show: !(model.isShowingQuestDetails ||
                            model.hasActiveQuest) ||
                        model.isFadingOutQuestDetails,
                  ),

                if (model.showLoadingScreen)
                  MapLoadingOverlay(show: model.showFullLoadingScreen),

                if (!model.isBusy)
                  MainHeader(
                      show: (!model.isShowingQuestDetails &&
                              !model.hasActiveQuest) ||
                          model.isFadingOutQuestDetails,
                      onPressed: model
                          .openSuperUserSettingsDialog, // model.showNotImplementedSnackbar,
                      onCreditsPressed: model.showNotImplementedSnackbar,
                      balance: model.currentUserStats.afkCreditsBalance),

                if (!model.isBusy) MainFooterOverlayView(),

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
          ? Align(
              alignment: Alignment(0, 0.91),
              child: RoundCloseButton(onTap: model.removeQuestListOverlay),
            )
          : SizedBox(height: 0, width: 0),
    );
  }
}
