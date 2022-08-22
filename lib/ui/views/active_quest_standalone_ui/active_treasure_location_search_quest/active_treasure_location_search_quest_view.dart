import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/ui/widgets/not_enough_sponsoring_note.dart';
import 'package:afkcredits/ui/widgets/treasure_location_search_widgets.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

// !!! DEPRECATED

class ActiveTreasureLocationSearchQuestView extends StatefulWidget {
  final Quest quest;
  const ActiveTreasureLocationSearchQuestView({
    Key? key,
    required this.quest,
  }) : super(key: key);

  static const bool withMaps = false;

  @override
  State<ActiveTreasureLocationSearchQuestView> createState() =>
      _ActiveTreasureLocationSearchQuestViewState();
}

class _ActiveTreasureLocationSearchQuestViewState
    extends State<ActiveTreasureLocationSearchQuestView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState _notification = AppLifecycleState.detached;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(
        "ActiveTreasureLocationSearchQuestView: New AppLifecycleState: ${state.toString()}");
    setState(() {
      _notification = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<
            ActiveTreasureLocationSearchQuestViewModel>.reactive(
        viewModelBuilder: () => ActiveTreasureLocationSearchQuestViewModel(),
        onModelReady: (model) => model.initialize(quest: widget.quest),
        builder: (context, model, child) {
          bool activeDetector = model.hasActiveQuest &&
              !model.isCheckingDistance &&
              model.allowCheckingPosition;
          if (_notification == AppLifecycleState.resumed) {
            print(
                "ActiveTreasureLocationSearchQuestView: Rebuilding UI because app resumed");
          }
          return WillPopScope(
            onWillPop: () async {
              if (!model.hasActiveQuest) {
                model.navigateBackFromSingleQuestView();
              }
              return false;
            },
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(
                  title: "Find the Treasure!",
                  onBackButton: () {
                    model.navigateBackFromSingleQuestView();
                  },
                  onAppBarButtonPressed: model.hasActiveQuest
                      ? null
                      : () => model.showQuestInfoDialog(quest: widget.quest),
                  appBarButtonIcon: Icons.help,
                ),
                floatingActionButton: !model.questSuccessfullyFinished &&
                        model.hasActiveQuest
                    ? AFKFloatingActionButton(
                        backgroundColor: model.hasActiveQuest
                            ? Colors.orange
                            : Colors.grey[600],
                        width: 100,
                        height: 100,
                        onPressed: !activeDetector
                            ? (model.hasActiveQuest
                                ? model.showReloadingInfo
                                : model.showStartQuestInfo)
                            : model.checkDistance,
                        icon: !model.allowCheckingPosition
                            ? Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, maxHeight: 100),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(kMagnetIconPath,
                                          alignment: Alignment.center,
                                          width: 50,
                                          height: 100,
                                          color: Colors.black),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Opacity(
                                          opacity: 0.7,
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                height: 100,
                                                color: Colors.grey[200],
                                                width: 100,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            : Shimmer.fromColors(
                                baseColor: activeDetector
                                    ? Colors.black
                                    : Colors.grey[200]!,
                                highlightColor: Colors.white,
                                period: const Duration(milliseconds: 1000),
                                enabled: activeDetector,
                                child: model.isCheckingDistance
                                    ? AFKProgressIndicator(color: Colors.white)
                                    : Image.asset(kMagnetIconPath, width: 50),
                              ),
                      )
                    : null,
                body: Column(
                  children: [
                    verticalSpaceMedium,
                    if (model.showStartSwipe && !model.isBusy)
                      model.distanceToStartMarker < 0
                          ? AFKProgressIndicator()
                          : model.isNearStartMarker
                              ? AFKSlideButton(
                                  quest: widget.quest,
                                  canStartQuest: model.hasEnoughSponsoring(
                                          quest: widget.quest) &&
                                      (model.isNearStartMarker == true),
                                  onSubmit: () => model.maybeStartQuest(
                                      quest: widget.quest),
                                )
                              : Container(
                                  color: Colors.white,
                                  child: NotCloseToQuestNote()),
                    if (!model.hasEnoughSponsoring(quest: widget.quest))
                      Container(
                          color: Colors.white,
                          child: NotEnoughSponsoringNote(topPadding: 10)),
                    // if (!model.questSuccessfullyFinished)
                    //   ActiveTreasureLocationSearchQuestView.withMaps
                    //       ? Expanded(
                    //           child: Container(
                    //             height: screenHeight(context, percentage: 0.6) -
                    //                 kAppBarExtendedHeight,
                    //             child: GoogleMap(
                    //               //mapType: MapType.hybrid,
                    //               initialCameraPosition:
                    //                   model.initialCameraPosition(),
                    //               //Place Markers in the Map
                    //               markers: model.markersOnMap,
                    //               //callback that’s called when the map is ready to us.
                    //               onMapCreated: model.onMapCreated,
                    //               //For showing your current location on Map with a blue dot.
                    //               myLocationEnabled: true,
                    //               // Button used for bringing the user location to the center of the camera view.
                    //               myLocationButtonEnabled: false,
                    //               //Remove the Zoom in and out button
                    //               zoomControlsEnabled: false,

                    //               //onTap: model.handleTap(),
                    //               //Enable Traffic Mode.
                    //               //trafficEnabled: true,
                    //             ),
                    //           ),
                    //         )
                    //       : Column(
                    //           children: [
                    //             verticalSpaceMedium,
                    //             SizedBox(height: 0, width: 0),
                    //           ],
                    //         ),
                    // : Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       verticalSpaceMedium,
                    //       Image.network(
                    //           "https://thumbs.gfycat.com/IndolentDistantBuffalo-max-1mb.gif",
                    //           alignment: Alignment.center,
                    //           height: 150),
                    //     ],
                    //   ),
                    model.questSuccessfullyFinished
                        ? EmptyNote(
                            onMoreButtonPressed: () =>
                                model.replaceWithMainView(
                                    index: BottomNavBarIndex.quest),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                verticalSpaceMedium,
                                if (!model.hasActiveQuest)
                                  Column(
                                    children: [
                                      // ElevatedButton(
                                      //   onPressed: model.showInstructions,
                                      //   child: Icon(Icons.help_outline_outlined,
                                      //       size: 50),
                                      //   // Text(
                                      //   //   "Instructions",
                                      //   //   style: textTheme(context)
                                      //   //       .headline6!
                                      //   //       .copyWith(
                                      //   //           color: kWhiteTextColor),
                                      //   // ),
                                      // ),
                                      // verticalSpaceMedium,
                                      // ShortQuestInstruction(
                                      //     description: "Finde den Schatz"),
                                      // Image.asset(kTreasureMapIconPath, width: 80),
                                    ],
                                  ),
                                // verticalSpaceMedium,
                                CurrentQuestStatusInfo(
                                  isBusy: model.isCheckingDistance,
                                  isFirstDistanceCheck:
                                      model.isFirstDistanceCheck,
                                  currentDistance:
                                      model.currentDistanceInMeters,
                                  previousDistance:
                                      model.previousDistanceInMeters,
                                  activatedQuest: model.activeQuestNullable,
                                  directionStatus: model.directionStatus,
                                ),
                              ],
                            ),
                          ),
                    // if (model.isCheckingDistance) DetectorWidget(),
                    // if (!model.isCheckingDistance && model.hasActiveQuest)
                    //   FittedBox(
                    //     child: Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Row(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Image.asset(kMagnetIconPath, width: 100),
                    //             Column(
                    //               children: [
                    //                 Icon(Icons.arrow_forward, size: 60),
                    //                 // Text("Feuer", style: textTheme(context).headline6),
                    //               ],
                    //             ),
                    //             SizedBox(width: 100),
                    //           ],
                    //         )),
                    //   ),
                    // SizedBox(height: 20),
                    //if (model.hasActiveQuest)
                    if (!model.questSuccessfullyFinished &&
                        model.hasActiveQuest)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                                  model.isFirstDistanceCheck
                                      ? "Measure initial distance"
                                      : model.allowCheckingPosition
                                          ? "Measure distance"
                                          : "Walk to reload...",
                                  textAlign: !model.isFirstDistanceCheck
                                      ? TextAlign.center
                                      : TextAlign.right,
                                  style: textTheme(context).headline6)),
                          Icon(Icons.arrow_forward, size: 40),
                          SizedBox(width: 130),
                        ],
                      ),
                    SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
