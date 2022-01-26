import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_view.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class ActiveMapQuestView extends StatelessWidget {
  final Quest quest;
  const ActiveMapQuestView({Key? key, required this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveMapQuestViewModel>.reactive(
      viewModelBuilder: () => ActiveMapQuestViewModel(),
      onModelReady: (model) {
        // TODO: change to initialize
        model.initialize(quest: quest);
        return;
      },
      disposeViewModel: false,
      builder: (context, model, child) {
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
                    : () => model.showQuestInfoDialog(quest: quest),
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
                              : Container()
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
                                            model.replaceWithMainView(
                                                index: BottomNavBarIndex.quest),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "More Quests",
                                          ),
                                        )),
                                  ],
                                )
                              : model.isBusy
                                  ? AFKProgressIndicator()
                                  : model.showStartSwipe
                                      ? model.isNearStartMarker
                                          ? AFKSlideButton(
                                              //alignment: Alignment(0, 0),
                                              quest: quest,
                                              canStartQuest:
                                                  model.hasEnoughSponsoring(
                                                      quest: quest),
                                              onSubmit: () =>
                                                  model.maybeStartQuest(
                                                      quest: quest))
                                          : Container(
                                              color: Colors.white,
                                              child: NotCloseToQuestNote(
                                                  controller: model
                                                      .getGoogleMapController))
                                      : model.hasActiveQuest
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                LiveQuestStatistic(
                                                  title: "Duration",
                                                  statistic: model.timeElapsed,
                                                ),
                                                LiveQuestStatistic(
                                                  title: "Markers collected",
                                                  statistic: model
                                                      .getNumberMarkersCollectedString(),
                                                ),
                                              ],
                                            )
                                          : Container(),
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

                            //onTap: model.handleTap(),
                            //Enable Traffic Mode.
                            //trafficEnabled: true,
                          ),
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
                                      color: kShadowColor.withOpacity(0.15))
                                ],
                              ),
                            ),
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
                        // @see: https://stackoverflow.com/questions/55989773/how-to-zoom-between-two-google-map-markers-in-flutter
                        model.getGoogleMapController!.animateCamera(
                            // CameraUpdate.newLatLngBounds(
                            //   LatLngBounds(
                            //     southwest: LatLng(quest.markers[1].lat!,
                            //         quest.markers[1].lon!),
                            //     northeast: LatLng(quest.markers[0].lat!,
                            //         quest.markers[0].lon!),
                            //   ),
                            //   15));
                            CameraUpdate.newCameraPosition(
                                model.initialCameraPosition()));
                        await model.scanQrCode();
                      },
                      iconData1: Icons.qr_code_scanner_rounded,
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
