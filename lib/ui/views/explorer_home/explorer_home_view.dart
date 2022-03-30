import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/enums/quests/direction_status.dart';
import 'package:afkcredits/enums/stats_type.dart';
import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/shared/maps/maps_controller_mixin.dart';
import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/main_footer_viewmodel.dart';
import 'package:afkcredits/ui/views/drawer_widget/drawer_widget_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/quest_details_overlay.dart';
import 'package:afkcredits/ui/views/map/main_map_view.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_viewmodel.dart';
import 'package:afkcredits/ui/views/step_counter/step_counter_overlay.dart';
import 'package:afkcredits/ui/widgets/achievement_card.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/animations/fade_transition_animation.dart';
import 'package:afkcredits/ui/widgets/animations/map_loading_overlay.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/afk_credits_display.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits/ui/widgets/finished_quest_card.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/large_button.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/main_avatar_view.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/outline_box.dart';
import 'package:afkcredits/ui/widgets/round_close_button.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dart:math' as m;

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
          log.wtf("==>> Rebuild ExplorerHomeView");
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  // bottom layer
                  //if (!model.isBusy)
                  if (!model.isBusy) MainMapView(),
                  if (model.showLoadingScreen)
                    MapLoadingOverlay(show: model.showFullLoadingScreen),
                  MainHeader(
                    show: (!model.isShowingQuestDetails &&
                            !model.hasActiveQuest) ||
                        model.isFadingOutQuestDetails,
                    onPressed: model
                        .openSuperUserSettingsDialog, // model.showNotImplementedSnackbar,
                    onCreditsPressed: model.showNotImplementedSnackbar,
                  ),
                  MainFooterView(),
                  QuestListOverlayView(),

                  if (model.isShowingQuestDetails || model.hasActiveQuest)
                    QuestDetailsOverlay(
                        startFadeOut: model.isFadingOutQuestDetails),

                  // StepCounterOverlay(),

                  // only used for quest view at the moment!
                  OverlayedCloseButton(),

                  if (model.isShowingARView) FadeTransitionAnimation(),
                ],
              ),
            ),
          );
        });
  }
}

class MainHeader extends StatelessWidget {
  final bool show;
  final void Function()? onPressed;
  final void Function()? onCreditsPressed;
  const MainHeader(
      {Key? key, this.onPressed, required this.show, this.onCreditsPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //log.wtf("Rebuilding MainHeader");
    return IgnorePointer(
      ignoring: !show,
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Container(
          height: 70,
          //color: Colors.blue.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MainAvatarView(percentage: 0.4, level: 3, onPressed: onPressed),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, top: 14),
                child: AFKCreditsDisplay(
                    balance: 130, onPressed: onCreditsPressed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RightFloatingButtons extends StatelessWidget {
  final void Function() onZoomPressed;
  final void Function() onCompassTap;

  // !!! Temporary
  final void Function()? onChangeCharacterTap;

  final double bearing;
  final bool zoomedIn;
  final bool hasActiveQuest;
  final bool isShowingQuestDetails;
  const RightFloatingButtons({
    Key? key,
    required this.bearing,
    required this.onZoomPressed,
    required this.zoomedIn,
    required this.onCompassTap,
    required this.isShowingQuestDetails,
    this.onChangeCharacterTap,
    this.hasActiveQuest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (onChangeCharacterTap != null)
          Align(
            alignment: Alignment(-1, 0.65),
            child: Container(
              color: Colors.grey[200]!.withOpacity(0.3),
              width: 55,
              height: 55,
              child: GestureDetector(onTap: onChangeCharacterTap!),
            ),
          ),
        Align(
          alignment: Alignment(1, -0.75),
          child: Padding(
            padding: const EdgeInsets.only(right: 15, top: 100),
            child: AnimatedOpacity(
              opacity: (bearing > 5 || bearing < -5) ? 1 : 1,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: onCompassTap,
                child: Transform.rotate(
                  angle: -bearing * m.pi / 180,
                  child: Image.asset(
                    kCompassIcon,
                    height: 38,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IgnorePointer(
            ignoring: hasActiveQuest,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: (isShowingQuestDetails || hasActiveQuest) ? 0 : 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 120,
                  right: 10,
                ),
                child: GestureDetector(
                  onTap: (isShowingQuestDetails || hasActiveQuest)
                      ? null
                      : onZoomPressed,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: kShadowColor,
                              //offset: Offset(1, 1),
                              blurRadius: 0.5,
                              spreadRadius: 0.2)
                        ],
                        border:
                            Border.all(color: Colors.grey[800]!, width: 2.0),
                        borderRadius: BorderRadius.circular(90.0),
                        color: Colors.white.withOpacity(0.9)),
                    alignment: Alignment.center,
                    child: zoomedIn == true
                        ? Icon(Icons.my_location_rounded)
                        : Icon(Icons.location_searching),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MainFooterView extends StatelessWidget {
  const MainFooterView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log.wtf("==>> Rebuild MainFooterView");
    return ViewModelBuilder<MainFooterViewModel>.reactive(
      viewModelBuilder: () => MainFooterViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          //alignment: Alignment.bottomCenter,
          child: FadingWidget(
            show: !(model.isShowingQuestDetails || model.hasActiveQuest) ||
                model.isFadingOutQuestDetails,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: model.isMenuOpen ? 0 : 1,
                    child: OutlineBox(
                      width: 80,
                      height: 60,
                      borderWidth: 0,
                      text: "SCREEN TIME",
                      onPressed: model.navToCreditsScreenTimeView,
                      color: kDarkTurquoise.withOpacity(0.8),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: model.isMenuOpen ? 200 : 130,
                  curve: Curves.linear,
                  child: CircularMenu(
                    toggleButtonOnPressed: () {
                      model.isMenuOpen = !model.isMenuOpen;
                      model.notifyListeners();
                    },
                    alignment: Alignment.bottomCenter,
                    //backgroundWidget: OutlineBox(text: "MENU"),
                    startingAngleInRadian: 1.3 * 3.14,
                    endingAngleInRadian: 1.7 * 3.14,
                    toggleButtonColor: kDarkTurquoise.withOpacity(0.8),
                    toggleButtonMargin: 0,
                    toggleButtonBoxShadow: [],
                    toggleButtonSize: 35,
                    radius: model.isSuperUser ? 120 : 80,
                    items: [
                      CircularMenuItem(
                        icon: Icons.settings,
                        color: Colors.grey[600],
                        margin: 0,
                        boxShadow: [],
                        onTap: () {
                          model.showNotImplementedSnackbar();
                        },
                      ),
                      CircularMenuItem(
                        icon: Icons.logout,
                        color: Colors.redAccent.shade700.withOpacity(0.9),
                        margin: 0,
                        boxShadow: [],
                        onTap: model.logout,
                        //model.logout();
                      ),
                      if (model.isSuperUser)
                        CircularMenuItem(
                          icon: Icons.person,
                          color: Colors.orange.shade700.withOpacity(0.9),
                          margin: 0,
                          boxShadow: [],
                          onTap: model.openSuperUserSettingsDialog,
                          //model.logout();
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: model.isMenuOpen ? 0 : 1,
                    child: OutlineBox(
                      width: 80,
                      height: 60,
                      text: "QUESTS",
                      color: kDarkTurquoise.withOpacity(0.8),
                      textColor: Colors.white,
                      borderWidth: 0,
                      onPressed: model.showQuestListOverlay,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

// !!! DEPRECATED VERSION

/*

class ExplorerHomeView extends StatelessWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
      viewModelBuilder: () => ExplorerHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Hi ${model.name}!",
          drawer: true,
        ),
        endDrawer: SizedBox(
          width: screenWidth(context, percentage: 0.8),
          child: const DrawerWidgetView(),
        ),
        body: model.isBusy
            ? AFKProgressIndicator()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: RefreshIndicator(
                  onRefresh: () async => model.listenToData(),
                  child: ListView(
                    children: [
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 10,
                            child: StatsCard(
                                onCardPressed:
                                    model.showToEarnExplanationDialog,
                                statsType: StatsType.lockedCredits,
                                height: 140,
                                statistic:
                                    // availableSponsoring IN CENTS!!!!!!
                                    formatAfkCreditsFromCents(model
                                        .currentUserStats.availableSponsoring),
                                title: kCreditsToEarnDescription),
                          ),
                          Spacer(),
                          Flexible(
                            flex: 10,
                            child: StatsCard(
                                onCardPressed:
                                    model.showEarnedExplanationDialog,
                                statsType: StatsType.unlockedCredits,
                                height: 140,
                                statistic: model
                                    .currentUserStats.afkCreditsBalance
                                    .toString(),
                                title: kCurrentAFKCreditsDescription),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      LargeButton(
                        title: "GET REWARDS",
                        onPressed: model.navigateToRewardsView,
                        imageUrl: kRewardImpageUrl,
                        backgroundColor: kDarkTurquoise.withOpacity(0.9),
                        titleColor: kWhiteTextColor,
                      ),
                      verticalSpaceSmall,
                      verticalSpaceSmall,
                      SectionHeader(
                        horizontalPadding: 0,
                        title: "Achievements",
                        onButtonTap: model.navigateToAchievementsView,
                      ),
                      if (model.achievements.length > 0)
                        AchievementsGrid(
                          achievements: model.achievements,
                          onPressed: () => null,
                        ),
                      verticalSpaceSmall,
                      verticalSpaceSmall,
                      SectionHeader(
                        horizontalPadding: 0,
                        title: "Quest History",
                        onButtonTap: model.navigateToQuestHistoryView,
                      ),
                      if (model.activatedQuestsHistory.length > 0)
                        QuestsGrid(
                          activatedQuests: model.activatedQuestsHistory,
                          onPressed: () => null,
                        ),
                      // verticalSpaceLarge,
                      //SectionHeader(title: "Achievements"),
                      verticalSpaceMassive,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class ExplorerCreditStats extends StatelessWidget {
  final UserStatistics userStats;
  const ExplorerCreditStats({Key? key, required this.userStats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: StatsCard(
                  statsType: StatsType.lockedCredits,
                  height: 140,
                  statistic:
                      // availableSponsoring IN CENTS!!!!!!
                      formatAfkCreditsFromCents(userStats.availableSponsoring),
                  title: kCreditsToEarnDescription),
            ),
            Spacer(),
            Flexible(
              flex: 5,
              child: StatsCard(
                  statsType: StatsType.unlockedCredits,
                  height: 140,
                  statistic: userStats.afkCreditsBalance.toString(),
                  title: kCurrentAFKCreditsDescription),
            ),
          ],
        ),
        verticalSpaceMedium,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Flexible(
        //       child: StatsCard(
        //           height: 80,
        //           statistic: userStats.lifetimeEarnings.toString(),
        //           subtitle: kLifetimeEarningsDescription),
        //     ),
        //     Flexible(
        //       child: StatsCard(
        //           height: 80,
        //           statistic: userStats.numberQuestsCompleted.toString(),
        //           subtitle: kNumberCompletedQuestsDescription),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class QuestsGrid extends StatelessWidget {
  final List<ActivatedQuest> activatedQuests;
  final void Function() onPressed;
  const QuestsGrid({
    Key? key,
    required this.activatedQuests,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
        ),
        itemCount: activatedQuests.length,
        itemBuilder: (context, index) {
          final ActivatedQuest data = activatedQuests[index];
          return FinishedQuestCard(
            quest: data,
            onTap: () => null,
          );
        },
      ),
    );
  }
}

class AchievementsGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final void Function() onPressed;
  const AchievementsGrid({
    Key? key,
    required this.achievements,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final Achievement data = achievements[index];
          return AchievementCard(
            achievement: data,
            //onTap: () => null,
          );
        },
      ),
    );
  }
}
*/
