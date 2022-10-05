import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/active_quest_overlays/gps_area_hike/gps_area_hike_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/quest_details_overlay_viewmodel.dart';
import 'package:afkcredits/ui/views/hike_quest/hike_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/common_quest_details_footer.dart';
import 'package:afkcredits/ui/widgets/common_quest_details_header.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/ui/widgets/quest_completed_note.dart';
import 'package:afkcredits/ui/widgets/quest_specifications_row.dart';
import 'package:afkcredits/ui/widgets/quest_success_card.dart';
import 'package:afkcredits/ui/widgets/quest_type_tag.dart';
import 'package:afkcredits/ui/widgets/treasure_location_search_widgets.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestDetailsOverlayView extends StatefulWidget {
  final bool startFadeOut;
  const QuestDetailsOverlayView({Key? key, required this.startFadeOut})
      : super(key: key);

  @override
  State<QuestDetailsOverlayView> createState() =>
      _QuestDetailsOverlayViewState();
}

class _QuestDetailsOverlayViewState extends State<QuestDetailsOverlayView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  // ..repeat(reverse: true);
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestDetailsOverlayViewModel>.reactive(
      viewModelBuilder: () => QuestDetailsOverlayViewModel(),
      onModelReady: (model) => model.initialize(quest: null),
      builder: (context, model, child) {
        if (widget.startFadeOut) {
          _controller.reverse(from: 0.5);
        }
        final Quest? quest = model.selectedQuest ??
            model.activeQuestNullable?.quest ??
            model.previouslyFinishedQuest?.quest ??
            null;
        return FadeTransition(
          opacity: _animation,
          child: MainStack(
            onBackPressed: model.popQuestDetails,
            showBackButton: !model.hasActiveQuest,
            child: Stack(
              children: [
                // Quest Info on top of screen
                CommonQuestDetailsHeader(
                    quest: quest,
                    hasActiveQuest: model.hasActiveQuest,
                    showInstructionsDialog: model.showInstructions,
                    openSuperUserSettingsDialog:
                        model.openSuperUserSettingsDialog),

                // cancel button
                if (model.hasActiveQuest)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.close, size: 30),
                          ),
                          onTap: model.cancelOrFinishQuest),
                    ),
                  ),

                // Quest info on bottom of screen
                if (quest != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: CommonQuestDetailsFooter(
                      model: model,
                      quest: quest,
                    ),
                  ),

                // Individual widgets for different types of quest
                // To be shown below the header once quest has started
                if (quest != null &&
                    quest.type == QuestType.TreasureLocationSearch)
                  TreasureLocationSearch(
                      showStartSlider: !model.showCompletedQuestNote() &&
                          model.isNearStartMarker &&
                          model.previouslyFinishedQuest == null,
                      notifyParentCallback: model.notifyListeners,
                      quest: quest),
                // ? Takes same arguments as above, could be improved to have common widget
                if (quest != null && quest.type == QuestType.GPSAreaHike)
                  GPSAreaHike(
                      showStartSlider: !model.showCompletedQuestNote() &&
                          model.isNearStartMarker &&
                          model.previouslyFinishedQuest == null,
                      notifyParentCallback: model.notifyListeners,
                      quest: quest),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SpecificQuestLayout extends StatelessWidget {
  final List<Widget> children;
  final bool showStartSlider;
  final void Function() maybeStartQuest;
  final ActiveQuestBaseViewModel model;

  const SpecificQuestLayout({
    Key? key,
    required this.children,
    required this.showStartSlider,
    required this.maybeStartQuest,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: model.hasActiveQuest
              ? kTopQuestDetailsHeaderPaddingActive
              : kTopQuestDetailsHeaderPadding,
          width: screenWidth(context),
        ),
        ...children,
        Spacer(),
        if (showStartSlider)
          aboveBottomBackButton(
            child: StartButtonOverlay(
                maybeStartQuest: maybeStartQuest, model: model),
          ),
      ],
    );
  }
}

// Quest details for treasure location search!
class TreasureLocationSearch extends StatelessWidget {
  final Quest quest;
  final bool showStartSlider;
  final void Function() notifyParentCallback;
  // final void Function() onStartQuest;
  const TreasureLocationSearch({
    Key? key,
    required this.quest,
    required this.showStartSlider,
    required this.notifyParentCallback,
    // required this.onStartQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<
        ActiveTreasureLocationSearchQuestViewModel>.reactive(
      viewModelBuilder: () => ActiveTreasureLocationSearchQuestViewModel(),
      onModelReady: (model) => model.initialize(
          quest: quest, notifyParentCallback: notifyParentCallback),
      builder: (context, model, child) {
        // bool activeDetector = model.hasActiveQuest &&
        //     !model.isCheckingDistance &&
        //     model.allowCheckingPosition;
        return SpecificQuestLayout(
          maybeStartQuest: () => model.maybeStartQuest(
              quest: quest, notifyParentCallback: notifyParentCallback),
          model: model,
          showStartSlider: showStartSlider,
          children: [
            if (model.isAnimatingCamera)
              AFKProgressIndicator(
                alignment: Alignment.center,
              ),
            FadingWidget(
              ignorePointer: true,
              show: model.previouslyFinishedQuest == null &&
                  !model.questFinished &&
                  model.hasActiveQuest,
              child: CurrentQuestStatusInfo(
                // isBusy: false,
                // isFirstDistanceCheck: true,
                // currentDistance: 100,
                // previousDistance: 110,
                // directionStatus: DirectionStatus.unknown,
                isBusy: model.isCheckingDistance,
                isFirstDistanceCheck: model.isFirstDistanceCheck,
                currentDistance: model.currentDistanceInMeters,
                previousDistance: model.previousDistanceInMeters,
                activatedQuest: model.activeQuestNullable,
                directionStatus: model.directionStatus,
              ),
            ),
            if (model.useSuperUserFeatures &&
                model.hasActiveQuest &&
                !model.isAnimatingCamera)
              GestureDetector(
                onTap: () {
                  model.checkDistance();
                },
                child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.green,
                    child: Icon(Icons.arrow_forward_ios)),
              ),
          ],
        );
      },
    );
  }
}

// TODO: I can make that more general for the different types of quests!
class GPSAreaHike extends StatefulWidget {
  final Quest quest;
  final bool showStartSlider;
  final void Function() notifyParentCallback;
  const GPSAreaHike({
    Key? key,
    required this.quest,
    required this.showStartSlider,
    required this.notifyParentCallback,
  }) : super(key: key);

  @override
  State<GPSAreaHike> createState() => _GPSAreaHikeState();
}

class _GPSAreaHikeState extends State<GPSAreaHike>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GPSAreaHikeViewModel>.reactive(
      viewModelBuilder: () => GPSAreaHikeViewModel(),
      onModelReady: (model) {
        model.addQuestMarkers(quest: widget.quest);
        model.initialize(quest: widget.quest);
      },
      builder: (context, model, child) {
        if (model.showCollectedMarkerAnimation) {
          _controller.reset();
          _controller.forward();
          model.showCollectedMarkerAnimation = false;
        }
        return SpecificQuestLayout(
          maybeStartQuest: () => model.maybeStartQuest(
              quest: widget.quest,
              notifyParentCallback: widget.notifyParentCallback),
          model: model,
          showStartSlider: widget.showStartSlider,
          children: [
            // ? ACTIVE QUEST CARD
            FadingWidget(
              ignorePointer: true,
              show: model.previouslyFinishedQuest == null &&
                  !model.questFinished &&
                  model.hasActiveQuest,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: kcGreenWhiter,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0.3,
                        spreadRadius: 0.4,
                        offset: Offset(1, 1),
                        color: kcShadowColor,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          LiveQuestStatistic(
                            title: "Duration",
                            statistic:
                                model.hasActiveQuest ? model.timeElapsed : "0",
                          ),
                          ScaleTransition(
                            scale: _animation,
                            child: LiveQuestStatistic(
                              title: "Markers collected",
                              statistic: model.hasActiveQuest
                                  ? model.getNumberMarkersCollectedString()
                                  : "0",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (model.isAnimatingCamera)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: AFKProgressIndicator(
                  alignment: Alignment.topCenter,
                ),
              ),
          ],
        );
      },
    );
  }
}

class StartButtonOverlay extends StatelessWidget {
  final ActiveQuestBaseViewModel model;
  final void Function() maybeStartQuest;

  const StartButtonOverlay({
    Key? key,
    required this.model,
    required this.maybeStartQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // if (!model.hasActiveQuest)
            //   Expanded(
            //     child: AfkCreditsButton(
            //         onTap: () => model.showInstructions(quest.type),
            //         title: "Tutorial",
            //         color: kPrimaryColor.withOpacity(0.7),
            //         leading: Icon(Icons.help, color: Colors.grey[100])),
            //   ),
            // if (!model.hasActiveQuest) horizontalSpaceSmall,
            if (model.showStartSwipe && !model.isBusy)
              Expanded(
                child: AFKSlideButton(
                  alignment: Alignment.bottomCenter,
                  canStartQuest: true, // model.isNearStartMarker == true,
                  onSubmit: maybeStartQuest,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
