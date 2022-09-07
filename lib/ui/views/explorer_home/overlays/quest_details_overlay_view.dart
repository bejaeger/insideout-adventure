import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/active_quest_overlays/gps_area_hike/gps_area_hike_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/hike_quest/hike_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/ui/widgets/quest_success_card.dart';
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
    return ViewModelBuilder<HikeQuestViewModel>.reactive(
      viewModelBuilder: () => HikeQuestViewModel(),
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
                // color gradient
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.5),
                        ],
                        stops: [0.0, 1.0],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                // closing button
                if (model.hasActiveQuest)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                          child: Icon(Icons.close),
                          onTap: model.cancelOrFinishQuest),
                    ),
                  ),

                // if (quest != null)
                //   InstructionsAndStartButtonsOverlay(
                //       quest: quest,
                //       onStartQuest: () => model.notifyListeners(),
                //       model: model),

                // Quest Info
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: model.openSuperUserSettingsDialog,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        //color: Colors.purple.withOpacity(0.2),
                                        border: Border.all(
                                            color: Colors.grey[600]!),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: AfkCreditsText.tag(
                                        getShortQuestType(quest?.type),
                                      ),
                                    ),
                                  ),
                                  // horizontalSpaceSmall,
                                  // CreditsAmount(
                                  //   amount: quest?.afkCredits ?? -1,
                                  //   height: 20,
                                  // ),
                                ],
                              ),
                              if (quest != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: model.hasActiveQuest ? 4.0 : 0,
                                      right: model.hasActiveQuest ? 40.0 : 0),
                                  child: GestureDetector(
                                      onTap: () =>
                                          model.showInstructions(quest.type),
                                      //title: "Tutorial",
                                      //color: kPrimaryColor.withOpacity(0.7),
                                      child: Icon(Icons.help,
                                          color: Colors.black, size: 24)),
                                ),
                            ],
                          ),
                          verticalSpaceSmall,
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Row(
                              children: [
                                CreditsAmount(
                                  amount: quest?.afkCredits ?? -1,
                                  height: 24,
                                  textColor: kcPrimaryColor,
                                ),
                                horizontalSpaceSmall,
                                AfkCreditsText.headingThree("-"),
                                horizontalSpaceSmall,
                                AfkCreditsText.headingThree(
                                    quest?.name ?? "QUEST"),
                              ],
                            ),
                          ),
                          verticalSpaceSmall,
                          if (quest != null)
                            if (quest.type == QuestType.TreasureLocationSearch)
                              // TODO: Make this a specific new View for each type of quest
                              Expanded(
                                child: TreasureLocationSearch(
                                    onStartQuest: () => model.notifyListeners(),
                                    quest: quest),
                              ),
                          if (quest != null)
                            if (quest.type == QuestType.GPSAreaHike)
                              // TODO: Make this a specific new View for each type of quest
                              Expanded(
                                child: GPSAreaHike(
                                    onStartQuest: () => model.notifyListeners(),
                                    quest: quest),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// TODO: I can make that more general for the different types of quests!
class TreasureLocationSearch extends StatelessWidget {
  final Quest quest;
  final void Function() onStartQuest;
  const TreasureLocationSearch({
    Key? key,
    required this.quest,
    required this.onStartQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<
        ActiveTreasureLocationSearchQuestViewModel>.reactive(
      viewModelBuilder: () => ActiveTreasureLocationSearchQuestViewModel(),
      onModelReady: (model) => model.initialize(quest: quest),
      builder: (context, model, child) {
        // bool activeDetector = model.hasActiveQuest &&
        //     !model.isCheckingDistance &&
        //     model.allowCheckingPosition;
        return Stack(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (model.previouslyFinishedQuest != null)
              Align(
                alignment: Alignment.topCenter,
                child:
                    QuestSuccessCard(onContinuePressed: model.popQuestDetails),
              ),
            if (model.previouslyFinishedQuest == null)
              IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
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
              ),
            if (model.useSuperUserFeatures)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    model.checkDistance();
                  },
                  child: Container(
                      width: 30,
                      height: 30,
                      color: Colors.green,
                      child: Icon(Icons.arrow_forward_ios)),
                ),
              ),
            model.isNearStartMarker
                ? model.previouslyFinishedQuest == null
                    ? StartButtonOverlay(
                        quest: quest, onStartQuest: onStartQuest, model: model)
                    : SizedBox(height: 0, width: 0)
                : aboveBottomBackButton(
                    child: NotCloseToQuestNote(
                      animateCameraToQuestMarkers:
                          model.animateCameraToQuestMarkers,
                      animateCameraToUserPosition:
                          model.animateCameraToUserPosition,
                    ),
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
  final void Function() onStartQuest;
  const GPSAreaHike({
    Key? key,
    required this.quest,
    required this.onStartQuest,
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
      duration: const Duration(milliseconds: 500),
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
      viewModelBuilder: () => GPSAreaHikeViewModel(quest: widget.quest),
      onModelReady: (model) => model.initialize(quest: widget.quest),
      builder: (context, model, child) {
        if (model.showCollectedMarkerAnimation) {
          _controller.reset();
          _controller.forward();
          model.showCollectedMarkerAnimation = false;
        }
        print("========================================");
        print(model.previouslyFinishedQuest);
        return Stack(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (model.isAnimatingCamera)
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: AFKProgressIndicator(
                  alignment: Alignment.topCenter,
                ),
              ),

            if (model.previouslyFinishedQuest != null)
              Align(
                alignment: Alignment.topCenter,
                child:
                    QuestSuccessCard(onContinuePressed: model.popQuestDetails),
              ),

            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(width: 200, height: 50),
              ),
            ),
            IgnorePointer(
              ignoring: !model.hasActiveQuest,
              child: Align(
                alignment: Alignment.topCenter,
                child: AnimatedOpacity(
                  opacity: model.hasActiveQuest ? 1 : 0,
                  duration: Duration(seconds: 1),
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
                              statistic: model.hasActiveQuest
                                  ? model.timeElapsed
                                  : "0",
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
            ),

            // if (model.useSuperUserFeatures)
            //   Align(
            //     alignment: Alignment.topRight,
            //     child: GestureDetector(
            //       onTap: () {
            //         model.checkDistance();
            //       },
            //       child: Container(
            //           width: 30,
            //           height: 30,
            //           color: Colors.green,
            //           child: Icon(Icons.arrow_forward_ios)),
            //     ),
            //   ),
            model.isNearStartMarker
                ? model.previouslyFinishedQuest == null
                    ? StartButtonOverlay(
                        quest: widget.quest,
                        onStartQuest: widget.onStartQuest,
                        model: model)
                    : SizedBox(height: 0, width: 0)
                : aboveBottomBackButton(
                    child: NotCloseToQuestNote(
                      animateCameraToQuestMarkers:
                          model.animateCameraToQuestMarkers,
                      animateCameraToUserPosition:
                          model.animateCameraToUserPosition,
                    ),
                  ),
            // StartButtonOverlay(
            //     quest: quest, onStartQuest: onStartQuest, model: model),
          ],
        );
      },
    );
  }
}

class StartButtonOverlay extends StatelessWidget {
  final Quest quest;
  final void Function() onStartQuest;
  final ActiveQuestBaseViewModel model;

  const StartButtonOverlay({
    Key? key,
    required this.quest,
    required this.onStartQuest,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: model.hasActiveQuest ? 0 : kBottomBackButtonPadding),
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
              // model.distanceToStartMarker < 0
              //     ? AFKProgressIndicator()
              //     :
              Expanded(
                child: AFKSlideButton(
                  alignment: Alignment.bottomCenter,
                  canStartQuest: true, // model.isNearStartMarker == true,
                  quest: quest,
                  onSubmit: () => model.maybeStartQuest(
                      quest: quest, onStartQuestCallback: onStartQuest),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
