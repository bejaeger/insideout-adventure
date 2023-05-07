import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/active_quest_overlays/active_search_quest/active_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_overlays/gps_area_hike/gps_area_hike_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/quest_details_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/common_quest_details_footer.dart';
import 'package:afkcredits/ui/widgets/common_quest_details_header.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/search_quest_widgets.dart';
import 'package:insideout_ui/insideout_ui.dart';
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
      onModelReady: (model) => model.initialize(
        quest: null,
      ),
      builder: (context, model, child) {
        if (widget.startFadeOut) {
          _controller.reverse(from: 0.5);
        }
        final Quest? quest = model.selectedQuest ??
            model.activeQuestNullable?.quest ??
            model.previouslyFinishedQuest?.quest ??
            model.questToBeStarted?.quest ??
            null;
        final bool showStartSlider = !model.showCompletedQuestNote() &&
            model.isNearStartMarker &&
            model.previouslyFinishedQuest == null &&
            !model.hasActiveQuest &&
            !model.hasActivatedQuestToBeStarted;
        return FadeTransition(
          opacity: _animation,
          child: MainStack(
            onBackPressed: model.popQuestDetails,
            showBackButton: !model.hasActiveQuest,
            child: Stack(
              children: [
                CommonQuestDetailsHeader(
                  isParentAccount: model.isParentAccount,
                  quest: quest,
                  // maybe instead of parsing activatedQuest to "hasActiveQuest" parse separately and use progress indicator as long as activatedQuestFromLocalStorage is loaded"
                  hasActiveQuest: model.hasActiveQuest,
                  hasActiveQuestToBeStarted: model.hasActivatedQuestToBeStarted,
                  showInstructionsDialog: model.showQuestInstructionDialog,
                  openSuperUserSettingsDialog:
                      model.openSuperUserSettingsDialog,
                  finishedQuest: model.previouslyFinishedQuest,
                  completed: model.showCompletedQuestNote(),
                ),

                if (model.hasActiveQuest)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: IconButton(
                        icon: Icon(Icons.close, size: 30),
                        onPressed: model.cancelOrFinishQuest,
                      ),
                    ),
                  ),

                if (quest != null && !model.hasActivatedQuestToBeStarted)
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
                  SearchQuestView(
                    showStartSlider: showStartSlider,
                    notifyParentCallback: model.notifyListeners,
                    quest: quest,
                  ),
                if (quest != null && quest.type == QuestType.GPSAreaHike)
                  GPSAreaHike(
                    showStartSlider: showStartSlider,
                    notifyParentCallback: model.notifyListeners,
                    quest: quest,
                  ),
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
  final Widget? bottomWidget;

  const SpecificQuestLayout({
    Key? key,
    required this.children,
    required this.showStartSlider,
    required this.maybeStartQuest,
    required this.model,
    this.bottomWidget,
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
        if (bottomWidget != null) bottomWidget!,
        if (showStartSlider)
          aboveBottomBackButton(
            child: StartButtonOverlay(
                maybeStartQuest: maybeStartQuest, model: model),
          ),
      ],
    );
  }
}

class SearchQuestView extends StatelessWidget {
  final Quest quest;
  final bool showStartSlider;
  final void Function() notifyParentCallback;
  const SearchQuestView({
    Key? key,
    required this.quest,
    required this.showStartSlider,
    required this.notifyParentCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchQuestViewModel>.reactive(
      viewModelBuilder: () => SearchQuestViewModel(),
      onModelReady: (model) => model.initialize(
        quest: quest,
        notifyParentCallback: notifyParentCallback,
      ),
      builder: (context, model, child) {
        return SpecificQuestLayout(
          maybeStartQuest: () => model.maybeStartQuest(
              quest: quest, notifyParentCallback: notifyParentCallback),
          model: model,
          showStartSlider: showStartSlider,
          bottomWidget: FadingWidget(
            show: model.hasActiveQuest,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AFKFloatingActionButton(
                  icon: Image.asset(kPinInAreaIcon,
                      color: kcWhiteTextColor, height: 34),
                  onPressed: model.manualCheckIfInAreaOfMarker,
                  width: 65,
                  height: 65,
                ),
              ),
            ),
          ),
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
                isBusy: model.isCheckingDistance,
                isFirstDistanceCheck: model.isFirstDistanceCheck,
                currentDistance: model.currentDistanceInMeters,
                previousDistance: model.previousDistanceInMeters,
                activatedQuest: model.activeQuestNullable,
                directionStatus: model.directionStatus,
                numCheckpointsReached: model.numCheckpointsCollected,
                numMarkers: model.numCheckpointsToCollect,
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
        model.initialize(
            quest: widget.quest,
            notifyParentCallback: widget.notifyParentCallback);
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
          bottomWidget: FadingWidget(
            show: model.hasActiveQuest,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AFKFloatingActionButton(
                  icon: Image.asset(kPinInAreaIcon,
                      color: kcWhiteTextColor, height: 34),
                  onPressed: model.manualCheckIfInAreaOfMarker,
                  width: 65,
                  height: 65,
                ),
              ),
            ),
          ),
          children: [
            // ACTIVE QUEST CARD
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
            if (model.showStartSwipe && !model.isBusy)
              Expanded(
                child: AFKSlideButton(
                  alignment: Alignment.bottomCenter,
                  canStartQuest: true,
                  onSubmit: maybeStartQuest,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
