import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_overlays/gps_area_hike/gps_area_hike_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/utils/string_utils.dart';
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
    return ViewModelBuilder<ActiveMapQuestViewModel>.reactive(
      viewModelBuilder: () => ActiveMapQuestViewModel(),
      builder: (context, model, child) {
        if (widget.startFadeOut) {
          _controller.reverse(from: 0.5);
        }
        final Quest? quest =
            model.selectedQuest ?? model.activeQuestNullable?.quest ?? null;
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

                if (quest != null)
                  InstructionsAndStartButtonsOverlay(
                      quest: quest,
                      onStartQuest: () => model.notifyListeners(),
                      model: model),

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
                              GestureDetector(
                                onTap: model.openSuperUserSettingsDialog,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    //color: Colors.purple.withOpacity(0.2),
                                    border:
                                        Border.all(color: Colors.grey[600]!),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: AfkCreditsText.tag(
                                    getStringFromEnum(quest?.type),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceTiny,
                          AfkCreditsText.headingTwo(quest?.name ?? "QUEST"),
                          verticalSpaceTiny,
                          CreditsAmount(amount: quest?.afkCredits ?? -1),
                          verticalSpaceMedium,
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
        bool activeDetector = model.hasActiveQuest &&
            !model.isCheckingDistance &&
            model.allowCheckingPosition;

        return Stack(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            // InstructionsAndStartButtonsOverlay(
            //     quest: quest, onStartQuest: onStartQuest, model: model),
          ],
        );
      },
    );
  }
}

// TODO: I can make that more general for the different types of quests!
class GPSAreaHike extends StatelessWidget {
  final Quest quest;
  final void Function() onStartQuest;
  const GPSAreaHike({
    Key? key,
    required this.quest,
    required this.onStartQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GPSAreaHikeViewModel>.reactive(
      viewModelBuilder: () => GPSAreaHikeViewModel(),
      onModelReady: (model) => model.initialize(quest: quest),
      builder: (context, model, child) {
        return Stack(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(width: 200, height: 50),
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
            // InstructionsAndStartButtonsOverlay(
            //     quest: quest, onStartQuest: onStartQuest, model: model),
          ],
        );
      },
    );
  }
}

class InstructionsAndStartButtonsOverlay extends StatelessWidget {
  final Quest quest;
  final void Function() onStartQuest;
  final ActiveQuestBaseViewModel model;

  const InstructionsAndStartButtonsOverlay({
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
        padding: EdgeInsets.only(bottom: model.hasActiveQuest ? 0 : 80.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!model.hasActiveQuest)
              Expanded(
                child: AfkCreditsButton(
                    onTap: () => model.showInstructions(quest),
                    title: "Tutorial",
                    color: kPrimaryColor.withOpacity(0.7),
                    leading: Icon(Icons.help, color: Colors.grey[100])),
              ),
            if (!model.hasActiveQuest) horizontalSpaceSmall,
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
