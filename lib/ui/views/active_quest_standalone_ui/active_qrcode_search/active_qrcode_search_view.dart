import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class ActiveQrCodeSearchView extends StatefulWidget {
  final Quest quest;
  const ActiveQrCodeSearchView({Key? key, required this.quest})
      : super(key: key);

  @override
  State<ActiveQrCodeSearchView> createState() => _ActiveQrCodeSearchViewState();
}

class _ActiveQrCodeSearchViewState extends State<ActiveQrCodeSearchView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
    return ViewModelBuilder<ActiveQrCodeSearchViewModel>.reactive(
      viewModelBuilder: () => locator<ActiveQrCodeSearchViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) => model.initialize(quest: widget.quest),
      builder: (context, model, child) {
        if (model.animateProgress) {
          _controller.reset();
          _controller.forward();
          model.animateProgress = false;
        }
        return WillPopScope(
          onWillPop: () async {
            if (!model.hasActiveQuest && !model.questSuccessfullyFinished) {
              model.navigateBackFromSingleQuestView();
            }
            return false;
          },
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: "Treasure Hunt",
                onBackButton: model.navigateBackFromSingleQuestView,
                showRedLiveButton: true,
                onAppBarButtonPressed: model.hasActiveQuest
                    ? null
                    : () => model.showQuestInfoDialog(quest: widget.quest),
              ),
              endDrawer: SizedBox(
                width: screenWidth(context, percentage: 0.8),
                child: const ActiveQuestDrawerView(),
              ),
              floatingActionButton: !model.hasActiveQuest
                  ? SizedBox(height: 0, width: 0)
                  : Container(
                      height: 100,
                      width: 100,
                      child: Align(
                        child: AFKFloatingActionButton(
                          // title1: "SCAN",
                          // onPressed2: model.hasActiveQuest
                          //     ? null
                          //     : () => model.maybeStartQuest(quest: quest),
                          // title2: "START",
                          //iconData2: Icons.star,
                          onPressed: model.scanQrCode,
                          backgroundColor: Colors.orange[300],
                          icon: Shimmer.fromColors(
                            baseColor: model.hasActiveQuest
                                ? Colors.black
                                : Colors.grey[400]!,
                            highlightColor: Colors.white,
                            period: const Duration(milliseconds: 1000),
                            enabled: model.hasActiveQuest,
                            child: Icon(Icons.qr_code_scanner_rounded,
                                size: 36, color: Colors.grey[100]),
                          ),
                          //yOffset: 0,
                          //isShimmering: true,

                          // title2: "LIST",
                          // onPressed2: model.navigateBack,
                          // iconData2: Icons.list_rounded,
                        ),
                      ),
                    ),
              body: model.isBusy
                  ? AFKProgressIndicator()
                  : model.questSuccessfullyFinished
                      ? EmptyNote(
                          onMoreButtonPressed: () => model.replaceWithMainView(
                              index: BottomNavBarIndex.quest),
                        )
                      : Stack(
                          children: [
                            Column(
                              children: [
                                // TODO: This whole container should be made a widget!
                                Container(
                                  // decoration: BoxDecoration(
                                  //   boxShadow: [
                                  //     BoxShadow(
                                  //         offset: Offset(0, 100),
                                  //         blurRadius: 4,
                                  //         spreadRadius: 2,
                                  //         color: kShadowColor)
                                  //   ],
                                  // ),
                                  alignment: Alignment.center,
                                  height: 100,
                                  child: model.questFinished &&
                                          !model.questSuccessfullyFinished
                                      ? model.isBusy
                                          ? AFKProgressIndicator()
                                          : SizedBox(height: 0, width: 0)
                                      : model.questSuccessfullyFinished
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "You mastered this mission!", // "You are the best, you successfully finished the quest",
                                                    textAlign: TextAlign.center,
                                                    style: textTheme(context)
                                                        .headline5),
                                                verticalSpaceTiny,
                                                ElevatedButton(
                                                    onPressed: () => model
                                                        .replaceWithMainView(
                                                            index:
                                                                BottomNavBarIndex
                                                                    .quest),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "More Quests",
                                                      ),
                                                    )),
                                              ],
                                            )
                                          : model.isBusy ||
                                                  model.distanceToStartMarker <
                                                      0
                                              ? AFKProgressIndicator()
                                              : Stack(
                                                  children: [
                                                    AnimatedOpacity(
                                                      opacity:
                                                          model.showStartSwipe
                                                              ? 1
                                                              : 0,
                                                      duration: Duration(
                                                          milliseconds: 50),
                                                      child: model
                                                              .isNearStartMarker
                                                          ? AFKSlideButton(
                                                              //alignment: Alignment(0, 0),
                                                              quest:
                                                                  widget.quest,
                                                              canStartQuest: model
                                                                  .hasEnoughSponsoring(
                                                                      quest: widget
                                                                          .quest),
                                                              onSubmit: () => model
                                                                  .maybeStartQuest(
                                                                      quest: widget
                                                                          .quest))
                                                          : Container(
                                                              color:
                                                                  Colors.white,
                                                              child:
                                                                  NotCloseToQuestNote(
                                                                questType:
                                                                    widget.quest
                                                                        .type,
                                                              ),
                                                            ),
                                                    ),
                                                    IgnorePointer(
                                                      ignoring:
                                                          !model.hasActiveQuest,
                                                      child: AnimatedOpacity(
                                                        opacity:
                                                            model.hasActiveQuest
                                                                ? 1
                                                                : 0,
                                                        duration: Duration(
                                                            seconds: 1),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            LiveQuestStatistic(
                                                                title:
                                                                    "Duration",
                                                                statistic: model
                                                                    .timeElapsed),
                                                            LiveQuestStatistic(
                                                              title:
                                                                  "Codes Found",
                                                              statistic: model
                                                                  .getCurrentProgressString(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                ),
                                Expanded(
                                    child: Stack(
                                  children: [
                                    NextClueCard(
                                        model: model, quest: widget.quest),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedOpacity(
                                          opacity: model.hasActiveQuest &&
                                                  model.foundObjects.length -
                                                          1 <
                                                      1
                                              ? 1
                                              : 0,
                                          duration: Duration(seconds: 1),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text("Find & Scan",
                                                  style: textTheme(context)
                                                      .headline6),
                                              Icon(Icons.arrow_forward,
                                                  size: 40),
                                              SizedBox(width: 110),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 45),
                                      ],
                                    ),
                                  ],
                                )),
                                // SizedBox(height: 5),
                                if (model.useSuperUserFeatures)
                                  Container(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Text("Scrollable list of Markers"),
                                        Expanded(
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              ...widget.quest.markers
                                                  .map(
                                                    (e) => TextButton(
                                                      onPressed: () => model
                                                          .displayQrCode(e),
                                                      child: Text(e.id),
                                                    ),
                                                  )
                                                  .toList(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            if (model.validatingMarker) AFKProgressIndicator(),
                            if (model.validatingMarker)
                              Container(
                                  color: Colors.grey[400]!.withOpacity(0.6))
                          ],
                        ),
            ),
          ),
        );
      },
    );
  }
}

class NextClueCard extends StatelessWidget {
  final ActiveQrCodeSearchViewModel model;
  final Quest quest;
  const NextClueCard({Key? key, required this.model, required this.quest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quest.type != QuestType.QRCodeSearch
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.orange[100], //Colors.grey[200],
              boxShadow: [
                BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 1,
                    color: kShadowColor,
                    offset: Offset(1, 1))
              ],
            )
          : null,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (quest.type != QuestType.QRCodeSearch)
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (model.foundObjects.length > 0 && model.displayNewClue)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Clue Nr. " +
                                    (model.foundObjects.length)
                                        .toStringAsFixed(0),
                                style: textTheme(context)
                                    .headline4!
                                    .copyWith(fontSize: 24)),
                            GestureDetector(
                              onTap: model.showNotImplementedSnackbar,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.help_outline,
                                      color: Colors.grey[700], size: 30),
                                  Text("Need hint?",
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      // Text("Wo ist der nächste Code?",
                      //     textAlign: TextAlign.left,
                      //     style: textTheme(context)
                      //         .headline4!
                      //         .copyWith(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          if (quest.type == QuestType.QRCodeHunt)
            Expanded(
              child: DisplayClue(
                hintString: model.getCurrentClue(),
                displayNewHint: model.displayNewClue,
                onNextCluePressed: () => model.setDisplayNewClue(true),
              ),
            ),
//           if (quest.type == QuestType.QRCodeSearch)
//             Expanded(
//               child: Container(
// //                       margin: const EdgeInsets.all(20),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.0),
//                   boxShadow: [
//                     BoxShadow(
//                         blurRadius: 4, spreadRadius: 2, color: kShadowColor)
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     GoogleMap(
//                       //mapType: MapType.hybrid,
//                       initialCameraPosition: model.initialCameraPosition(),
//                       //Place Markers in the Map
//                       markers: model.markersOnMap,
//                       //callback that’s called when the map is ready to us.
//                       onMapCreated: model.onMapCreated,
//                       //For showing your current location on Map with a blue dot.
//                       myLocationEnabled: true,
//                       // Button used for bringing the user location to the center of the camera view.
//                       myLocationButtonEnabled: false,
//                       //Remove the Zoom in and out button
//                       zoomControlsEnabled: false,
//                       //onTap: model.handleTap(),
//                       //Enable Traffic Mode.
//                       //trafficEnabled: true,
//                     ),
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Container(
//                           padding: const EdgeInsets.all(20.0),
//                           decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.9),
//                               borderRadius: BorderRadius.circular(16.0)),
//                           child:
//                               Column(mainAxisSize: MainAxisSize.min, children: [
//                             Text("Find codes in the displayed area",
//                                 textAlign: TextAlign.center,
//                                 style: textTheme(context).headline6),
//                           ]),
//                         ),
//                       ),
//                     ),
//                     Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Container(
//                             height: 200,
//                             width: 200,
//                             padding: const EdgeInsets.all(20.0),
//                             decoration: BoxDecoration(
//                                 //border: Border.all(color: kPrimaryColor),
//                                 color: kPrimaryColor.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(180.0)),
//                           ),
//                         ))
//                   ],
//                 ),
//               ),
//             ),
        ],
      ),
    );
  }
}

class DisplayClue extends StatefulWidget {
  final String hintString;
  final bool displayNewHint;
  final void Function() onNextCluePressed;
  const DisplayClue(
      {Key? key,
      required this.hintString,
      required this.displayNewHint,
      required this.onNextCluePressed})
      : super(key: key);

  @override
  State<DisplayClue> createState() => _DisplayClueState();
}

class _DisplayClueState extends State<DisplayClue>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  // ..repeat(reverse: true);
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
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
    _controller.forward();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.displayNewHint
              ? Expanded(
                  child: RotationTransition(
                    turns: _animation,
                    child: Align(
                      child: Text(widget.hintString,
                          //overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: textTheme(context)
                              .headline6!
                              .copyWith(fontSize: 30)),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(10),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () async {
                      widget.onNextCluePressed();
                      // _controller.forward();
                      // await Future.delayed(Duration(seconds: 2));
                      _controller.reset();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Shimmer.fromColors(
                        baseColor: kWhiteTextColor,
                        highlightColor: kGreyTextColor,
                        period: const Duration(milliseconds: 1000),
                        child: Text("New Clue",
                            style: textTheme(context)
                                .headline6!
                                .copyWith(color: kWhiteTextColor)),
                      ),
                    ),
                  ),
                ),
          verticalSpaceMedium,
        ],
      ),
    );
  }
}
