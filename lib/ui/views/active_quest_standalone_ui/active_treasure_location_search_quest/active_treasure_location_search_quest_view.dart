import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/ui/widgets/not_enough_sponsoring_note.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class ActiveTreasureLocationSearchQuestView extends StatelessWidget {
  final Quest quest;
  const ActiveTreasureLocationSearchQuestView({
    Key? key,
    required this.quest,
  }) : super(key: key);

  static const bool withMaps = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<
        ActiveTreasureLocationSearchQuestViewModel>.reactive(
      viewModelBuilder: () =>
          locator<ActiveTreasureLocationSearchQuestViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) => model.initialize(quest: quest),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Search for the Trohpy!",
            onBackButton: model.navigateBack,
          ),
          body: Align(
            alignment: Alignment.center,
            child: model.isBusy
                ? AFKProgressIndicator()
                // : model.activeQuestNullable?.status == QuestStatus.success
                //     ? Text(
                //         "Successfully finished quest! Finish above when you have data",
                //         style: textTheme(context)
                //             .headline6!
                //             .copyWith(color: kPrimaryColor))
                : Container(
                    alignment: Alignment.center,
                    height: screenHeight(context),
                    child: Stack(
                      children: [
                        if (!model.questSuccessfullyFinished)
                          withMaps
                              ? Container(
                                  height:
                                      screenHeight(context, percentage: 0.6) -
                                          kAppBarExtendedHeight,
                                  child: GoogleMap(
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
                                )
                              : Container(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      verticalSpaceLarge,
                                      verticalSpaceMedium,
                                      Image.network(
                                          "https://thumbs.gfycat.com/IndolentDistantBuffalo-max-1mb.gif",
                                          alignment: Alignment.center,
                                          height: 150),
                                      verticalSpaceSmall,
                                    ],
                                  )),
                        // Container(color: Colors.cyan),
                        // Align(
                        //   alignment: Alignment.topCenter,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Colors.white.withOpacity(0.8),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(20.0),
                        //       child: Text("Goal: Find the Trophy!",
                        //           style: textTheme(context)
                        //               .headline6!
                        //               .copyWith(color: kPrimaryColor)),
                        //     ),
                        //   ),
                        // ),
                        model.questSuccessfullyFinished
                            ? EmptyNote(
                                onMoreButtonPressed: () =>
                                    model.replaceWithMainView(
                                        index: BottomNavBarIndex.quest),
                              )
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        // gradient: LinearGradient(
                                        //     begin: Alignment.topCenter,
                                        //     end: Alignment.bottomCenter,
                                        //     colors: [
                                        //       kNiceBeige,
                                        //       kNiceBeige,
                                        //       // Colors.white.withOpacity(0.4),
                                        //       // Colors.white,
                                        //     ]),
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16.0),
                                            topLeft: Radius.circular(16.0)),
                                        //color: Colors.white.withOpacity(0.5),
                                      ),
                                      width: screenWidth(context),
                                      // 2 * kHorizontalPadding,
                                      height: screenHeight(context,
                                          percentage: 0.4),
                                      child: ListView(
                                        children: [
                                          verticalSpaceSmall,
                                          if (!model.hasActiveQuest)
                                            Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed:
                                                      model.showInstructions,
                                                  child: Text(
                                                    "Instructions",
                                                    style: textTheme(context)
                                                        .headline6!
                                                        .copyWith(
                                                            color:
                                                                kWhiteTextColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (!model.hasActiveQuest)
                                            verticalSpaceSmall,
                                          !model.hasActiveQuest
                                              ? Column(
                                                  children: [
                                                    AnimatedOpacity(
                                                      duration:
                                                          Duration(seconds: 1),
                                                      opacity: (model.closeby !=
                                                                  null &&
                                                              model.closeby ==
                                                                  true)
                                                          ? 1.0
                                                          : 0.5,
                                                      child: ElevatedButton(
                                                        onPressed: model.hasEnoughSponsoring(
                                                                    quest:
                                                                        quest) &&
                                                                (model.closeby !=
                                                                        null &&
                                                                    model.closeby ==
                                                                        true)
                                                            ? () => model
                                                                .maybeStartQuest(
                                                                    quest:
                                                                        quest)
                                                            : null,
                                                        child: Text(
                                                            "Start Quest",
                                                            style: textTheme(
                                                                    context)
                                                                .headline6!
                                                                .copyWith(
                                                                    color:
                                                                        kWhiteTextColor)),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: model
                                                            .checkNewDistance,
                                                        child: !model
                                                                .isCheckingDistance
                                                            ? Text(
                                                                "Check Distance",
                                                                style: textTheme(
                                                                        context)
                                                                    .headline6!
                                                                    .copyWith(
                                                                        color:
                                                                            kWhiteTextColor))
                                                            : CircularProgressIndicator(
                                                                color: Colors
                                                                    .white)),
                                                    // Text(
                                                    //  "Your start position has been tagged"),
                                                  ],
                                                ),
                                          if (model.closeby != null &&
                                              model.closeby == true)
                                            NotCloseToQuestNote(),
                                          if (!model.hasEnoughSponsoring(
                                              quest: quest))
                                            NotEnoughSponsoringNote(),
                                          verticalSpaceMedium,
                                          if (model.activeQuestNullable
                                                  ?.currentDistanceInMeters !=
                                              null)
                                            Text("Current Distance",
                                                textAlign: TextAlign.center,
                                                style: textTheme(context)
                                                    .headline6),
                                          if (model.activeQuestNullable
                                                  ?.currentDistanceInMeters !=
                                              null)
                                            Text(
                                                "${model.activeQuestNullable?.currentDistanceInMeters?.toStringAsFixed(1)} m",
                                                textAlign: TextAlign.center,
                                                style: textTheme(context)
                                                    .headline2),
                                          if (model.activeQuestNullable
                                                  ?.lastDistanceInMeters !=
                                              null)
                                            Text("Last Distance",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18)),
                                          if (model.activeQuestNullable
                                                  ?.lastDistanceInMeters !=
                                              null)
                                            Text(
                                                "${model.activeQuestNullable?.lastDistanceInMeters?.toStringAsFixed(1)} m",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18)),
                                          if (model.hasActiveQuest)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          kHorizontalPadding,
                                                      vertical: 10),
                                              child: Text(
                                                  "${model.directionStatus}",
                                                  textAlign: TextAlign.center,
                                                  style: textTheme(context)
                                                      .headline6),
                                            ),
                                          verticalSpaceSmall,
                                        ],
                                      ),
                                    ),
                                    //verticalSpaceMediumLarge,
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
