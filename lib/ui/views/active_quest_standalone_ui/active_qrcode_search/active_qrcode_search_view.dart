import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  // late final AnimationController _controller;
  // late final Animation<double> _animation;
  late final FlipCardController _flipCardController;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // );
    // _animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInOut,
    // );
    _flipCardController = FlipCardController();
    // _controller.forward();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  final flipDuration = 500;
  bool isShowClue = true;
  bool isFlipping = false;
  bool flipCard(
      {Future Function()? animateCamera, bool? flipToMap, bool? flipToClue}) {
    if (isFlipping) return false;
    // flip only if the clue is shown at the moment
    if (flipToMap == true && !isShowClue) return false;
    // flip only if the map is shown at the moment
    if (flipToClue == true && isShowClue) return false;
    isShowClue = !isShowClue;
    setState(() {});
    isFlipping = true;
    _flipCardController.toggleCard();
    Future.delayed(Duration(milliseconds: flipDuration + 10), () {
      isFlipping = false;
    });
    if (isShowClue == false && animateCamera != null) {
      animateCamera();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveQrCodeSearchViewModel>.reactive(
      viewModelBuilder: () => ActiveQrCodeSearchViewModel(flipCard: flipCard),
      disposeViewModel: false,
      onModelReady: (model) => model.initialize(quest: widget.quest),
      builder: (context, model, child) {
        // if (model.animateProgress) {
        //   _controller.reset();
        //   _controller.forward();
        //   model.animateProgress = false;
        // }

        // TODO: handle this in viewmodel
        if (!model.isNearStartMarker &&
            !model.isCalculatingDistanceToStartMarker) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (isShowClue == true) {
              Future.delayed(Duration(milliseconds: 0), () => flipCard());
            }
          });
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
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: Align(
                            child: AFKFloatingActionButton(
                              onPressed: () => flipCard(
                                  animateCamera: () =>
                                      model.animateCameraToQuestMarkers(
                                          model.getGoogleMapController)),
                              backgroundColor: Colors.orange[300],
                              icon: Column(
                                children: [
                                  Icon(
                                      isShowClue == true
                                          ? Icons.map
                                          : Icons.list,
                                      size: 36,
                                      color: Colors.grey[800]),
                                  Text(isShowClue == true ? "Map" : "Clue")
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
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
                              onPressed:
                                  widget.quest.type == QuestType.QRCodeHunt
                                      ? model.scanQrCode
                                      : model.collectMarkerFromGPSLocation,
                              backgroundColor: Colors.orange[300],
                              icon: Shimmer.fromColors(
                                  baseColor: model.hasActiveQuest
                                      ? Colors.black
                                      : Colors.grey[400]!,
                                  highlightColor: Colors.white,
                                  period: const Duration(milliseconds: 1000),
                                  enabled: model.hasActiveQuest,
                                  child:
                                      widget.quest.type == QuestType.QRCodeHunt
                                          ? Icon(Icons.qr_code_scanner_rounded,
                                              size: 36, color: Colors.grey[100])
                                          : model.validatingMarkerInArea
                                              ? AFKProgressIndicator()
                                              : Image.asset(kPinInAreaIcon,
                                                  color: kWhiteTextColor,
                                                  height: 40)),
                              //yOffset: 0,
                              //isShimmering: true,

                              // title2: "LIST",
                              // onPressed2: model.navigateBack,
                              // iconData2: Icons.list_rounded,
                            ),
                          ),
                        ),
                      ],
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
                                                  model
                                                      .isCalculatingDistanceToStartMarker
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
                                    FlipCard(
                                      flipOnTouch: false,
                                      speed: flipDuration,
                                      controller: _flipCardController,
                                      fill: Fill
                                          .fillBack, // Fill the back side of the card to make in the same size as the front.
                                      direction:
                                          FlipDirection.HORIZONTAL, // default
                                      front: NextClueCard(
                                          model: model, quest: widget.quest),
                                      back: NextClueCard(
                                          model: model,
                                          quest: widget.quest,
                                          showMap: true),
                                    ),
                                    IgnorePointer(
                                      ignoring: !model.displayButtonNewClue,
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        opacity:
                                            model.displayButtonNewClue ? 1 : 0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 30.0,
                                              left: 30,
                                              right: 30),
                                          child: Align(
                                            alignment:
                                                model.currentQuest?.type ==
                                                        QuestType.GPSAreaHunt
                                                    ? Alignment.bottomLeft
                                                    : Alignment.center,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.orange),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        10),
                                                // shadowColor:
                                                //     MaterialStateProperty.all(
                                                //         Colors.black),
                                              ),
                                              onPressed: () async {
                                                await model
                                                    .setDisplayNewClue(true);
                                                // _controller.forward();
                                                // await Future.delayed(Duration(seconds: 2));
                                                // _controller.reset();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Shimmer.fromColors(
                                                  baseColor: kWhiteTextColor,
                                                  highlightColor: kGreyTextColor
                                                      .withOpacity(0.6),
                                                  period: const Duration(
                                                      milliseconds: 1000),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          size: 36,
                                                          color:
                                                              kWhiteTextColor),
                                                      Text("New Clue",
                                                          style: textTheme(
                                                                  context)
                                                              .headline6!
                                                              .copyWith(
                                                                  color:
                                                                      kWhiteTextColor)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // AnimatedOpacity(
                                        //   opacity: model.hasActiveQuest &&
                                        //           model.getNumberMarkersCollected -
                                        //                   1 <
                                        //               1
                                        //       ? 1
                                        //       : 0,
                                        //   duration: Duration(seconds: 1),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.end,
                                        //     children: [
                                        //       Text("Find & Scan",
                                        //           style: textTheme(context)
                                        //               .headline6),
                                        //       Icon(Icons.arrow_forward,
                                        //           size: 40),
                                        //       SizedBox(width: 110),
                                        //     ],
                                        //   ),
                                        // ),
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
  final bool showMap;
  const NextClueCard(
      {Key? key,
      required this.model,
      required this.quest,
      this.showMap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: !showMap
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
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showMap)
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (model.getNumberMarkersCollected > 0 &&
                          model.displayClue)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Clue Nr. " +
                                    (model.getNumberMarkersCollected)
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
          if (!showMap)
            !model.isNearStartMarker || model.isCalculatingDistanceToStartMarker
                ? AFKProgressIndicator(
                    alignment: Alignment.center,
                  )
                : Expanded(
                    child: model.displayClue
                        ? DisplayClue(
                            hintString: model.getCurrentClue(),
                            onNextCluePressed: () =>
                                model.setDisplayNewClue(true),
                            animateProgress: model.animateProgress,
                          )
                        : SizedBox(height: 0, width: 0),
                  ),
          if (showMap)
            Expanded(
              child: Container(
//                       margin: const EdgeInsets.all(20),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4, spreadRadius: 2, color: kShadowColor)
                  ],
                ),
                child: Stack(
                  children: [
                    GoogleMap(
                      //mapType: MapType.hybrid,
                      initialCameraPosition: model.initialCameraPosition(),
                      //Place Markers in the Map
                      markers: model.markersOnMap,
                      circles: model.areasOnMap,
                      //callback that’s called when the map is ready to us.
                      onMapCreated: model.onMapCreated,
                      //For showing your current location on Map with a blue dot.
                      myLocationEnabled: true,
                      // Button used for bringing the user location to the center of the camera view.
                      myLocationButtonEnabled: false,
                      //Remove the Zoom in and out button
                      zoomControlsEnabled: false,
                      //onTap: model.handleTap(),
                      //Enable Traffic Mode.
                      //trafficEnabled: true,
                      mapToolbarEnabled: false,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: model.isAnimatingCamera
                            ? AFKProgressIndicator(
                                alignment: Alignment.topCenter)
                            : Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(16.0)),
                                child: Text(
                                    model.hasActiveQuest
                                        ? "Your collected areas"
                                        : "Go to the highlighted area and start the quest",
                                    textAlign: TextAlign.center,
                                    style: textTheme(context).headline6),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DisplayClue extends StatefulWidget {
  final String hintString;
  final bool animateProgress;
  final void Function() onNextCluePressed;
  const DisplayClue(
      {Key? key,
      required this.hintString,
      required this.onNextCluePressed,
      required this.animateProgress})
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
    // TODO: THIS IS REBUILDING EVERY SECOND!!!!!!!!!!!!!!!!!
    // TODO SHOULD NOT BE THE CASE!
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment(0, -0.1),
      child: RotationTransition(
        turns: _animation,
        child: Text(widget.hintString,
            //overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme(context).headline6!.copyWith(fontSize: 30)),
      ),
    );
  }
}
