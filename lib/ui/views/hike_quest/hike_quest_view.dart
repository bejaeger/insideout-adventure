import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_view.dart';
import 'package:afkcredits/ui/views/hike_quest/hike_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class HikeQuestView extends StatefulWidget {
  final Quest quest;
  const HikeQuestView({Key? key, required this.quest}) : super(key: key);

  @override
  State<HikeQuestView> createState() => _HikeQuestViewState();
}

class _HikeQuestViewState extends State<HikeQuestView>
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
    return ViewModelBuilder<HikeQuestViewModel>.reactive(
      viewModelBuilder: () => HikeQuestViewModel(),
      onModelReady: (model) {
        model.initialize(quest: widget.quest);
        return;
      },
      fireOnModelReadyOnce: true,
      builder: (context, model, child) {
        if (model.showCollectedMarkerAnimation) {
          _controller.reset();
          _controller.forward();
          model.showCollectedMarkerAnimation = false;
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
                title: 'Hike Quest',
                onBackButton: model.navigateBackFromSingleQuestView,
                showRedLiveButton: true,
                onAppBarButtonPressed: model.hasActiveQuest
                    ? null
                    : () => model.showQuestInfoDialog(quest: widget.quest),
                appBarButtonIcon: Icons.help,
                //drawer: model.hasActiveQuest ? true : false,
                // onAppBarButtonPressed: model.hasActiveQuest
                //     ? null
                //     : () => model.showQuestInfoDialog(quest: quest),
                // drawerIcon: Icons.help,
              ),
              endDrawer: SizedBox(
                width: screenWidth(context, percentage: 0.8),
                child: const ActiveQuestDrawerView(),
              ),
              body:
                  //  model.questSuccessfullyFinished
                  //     ? EmptyNote(
                  //         onMoreButtonPressed: () => model.replaceWithMainView(
                  //             index: BottomNavBarIndex.quest),
                  //       )
                  //     :
                  Container(
                height: screenHeight(context) - kAppBarExtendedHeight,
                child: Column(
                  children: [
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "You mastered this mission!", // "You are the best, you successfully finished the quest",
                                        textAlign: TextAlign.center,
                                        style: textTheme(context).headline5),
                                    verticalSpaceTiny,
                                    ElevatedButton(
                                      onPressed: () =>
                                          model.navigateBackFromSingleQuestView(
                                              replaceView: true),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Go back",
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : model.isBusy || model.distanceToStartMarker < 0
                                  ?
                                  //Text(
                                  //  "Du Dumm!? ${model.distanceToStartMarker}")
                                  AFKProgressIndicator()
                                  : Stack(
                                      children: [
                                        AnimatedOpacity(
                                          opacity: model.showStartSwipe ? 1 : 0,
                                          duration: Duration(milliseconds: 50),
                                          child: model.isNearStartMarker
                                              ? AFKSlideButton(
                                                  //alignment: Alignment(0, 0),
                                                  quest: widget.quest,
                                                  canStartQuest:
                                                      model.hasEnoughSponsoring(
                                                          quest: widget.quest),
                                                  onSubmit: () =>
                                                      model.maybeStartQuest(
                                                          quest: widget.quest))
                                              : Container(
                                                  color: Colors.white,
                                                  child: NotCloseToQuestNote(
                                                      questType:
                                                          widget.quest.type,
                                                      animateCameraToUserPosition:
                                                          () => model
                                                              .animateToUserPosition(
                                                                  model
                                                                      .getGoogleMapController),
                                                      animateCameraToQuestMarkers:
                                                          () {
                                                        model.animateCameraToQuestMarkers(
                                                            model
                                                                .getGoogleMapController,
                                                            delay: 0);
                                                      }),
                                                ),
                                        ),
                                        IgnorePointer(
                                          ignoring: !model.hasActiveQuest,
                                          child: AnimatedOpacity(
                                            opacity:
                                                model.hasActiveQuest ? 1 : 0,
                                            duration: Duration(seconds: 1),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                LiveQuestStatistic(
                                                  title: "Duration",
                                                  statistic:
                                                      model.hasActiveQuest
                                                          ? model.timeElapsed
                                                          : "0",
                                                ),
                                                ScaleTransition(
                                                  scale: _animation,
                                                  child: LiveQuestStatistic(
                                                    title: "Markers collected",
                                                    statistic: model
                                                            .hasActiveQuest
                                                        ? model
                                                            .getNumberMarkersCollectedString()
                                                        : "0",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                    ),
                    // if (model.isBusy)
                    //   Align(
                    //       alignment: Alignment.center,
                    //       child: CircularProgressIndicator()),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            circles: model.areasOnMap,
                            //mapType: MapType.hybrid,
                            initialCameraPosition:
                                model.initialCameraPosition(),
                            //Place Markers in the Map
                            markers: model.markersOnMap,
                            //callback that’s called when the map is ready to us.
                            onMapCreated: model.onMapCreated,
                            //For showing your current location on Map with a blue dot.
                            myLocationEnabled: true,

                            // Button used for bringing the user location to the center of the camera view.
                            myLocationButtonEnabled: false,

                            //Remove the Zoom in and out button
                            zoomControlsEnabled: false,

                            mapToolbarEnabled: false,
                            //onTap: model.handleTap(),
                            //Enable Traffic Mode.
                            //trafficEnabled: true,
                          ),
                          if (!model.hasActiveQuest)
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey[50]!,
                                      Colors.grey[50]!.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (model.hasActiveQuest)
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 0.2,
                                        spreadRadius: 0,
                                        color: kcShadowColor.withOpacity(0.15))
                                  ],
                                ),
                              ),
                            ),
                          if (model.isAnimatingCamera)
                            AFKProgressIndicator(
                              alignment: Alignment.topCenter,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: !model.questSuccessfullyFinished
                  ? AFKFloatingActionButtons(
                      // onPressed2: !model.hasActiveQuest
                      //     ? () => model.startQuestMain(quest: quest)
                      //     : null,
                      // title2: "START",
                      // iconData2: Icons.star,
                      onPressed1: () async {
                        // model.triggerCollectedMarkerAnimation();
                        // @see: https://stackoverflow.com/questions/55989773/how-to-zoom-between-two-google-map-markers-in-flutter
                        // model.getGoogleMapController!.animateCamera(
                        // //     // CameraUpdate.newLatLngBounds(
                        // //     //   LatLngBounds(
                        // //     //     southwest: LatLng(quest.markers[1].lat!,
                        // //     //         quest.markers[1].lon!),
                        // //     //     northeast: LatLng(quest.markers[0].lat!,
                        // //     //         quest.markers[0].lon!),
                        // //     //   ),
                        // //     //   15));
                        //     CameraUpdate.newCameraPosition(
                        //         model.initialCameraPosition()));
                        if (widget.quest.type == QuestType.QRCodeHike)
                          await model.scanQrCode();
                        if (widget.quest.type == QuestType.GPSAreaHike)
                          await model.collectMarkerFromGPSLocation();
                      },
                      icon1: widget.quest.type == QuestType.QRCodeHike
                          ? Icon(Icons.qr_code_scanner_rounded,
                              size: 34, color: Colors.white)
                          : Image.asset(kPinInAreaIcon,
                              color: kcWhiteTextColor, height: 40))
                  : null,
            ),
          ),
        );
      },
    );
  }
}
