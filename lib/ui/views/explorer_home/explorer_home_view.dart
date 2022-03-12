import 'dart:io';

import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/enums/stats_type.dart';
import 'package:afkcredits/ui/views/drawer_widget/drawer_widget_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/achievement_card.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/finished_quest_card.dart';
import 'package:afkcredits/ui/widgets/large_button.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ExplorerHomeView extends StatelessWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
      viewModelBuilder: () => ExplorerHomeViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              // bottom layer
              if (!model.isBusy) MainMapView(),
              if (model.isBusy) MapLoadingOverlay(),
              MainHeader(),
              MainFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class MapLoadingOverlay extends StatelessWidget {
  const MapLoadingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.4),
      alignment: Alignment.center,
      child: AfkCreditsText.body("Loading..."),
    );
  }
}

class MainMapView extends StatelessWidget {
  const MainMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    return ViewModelBuilder<MapOverviewViewModel>.reactive(
      viewModelBuilder: () => MapOverviewViewModel(),
      onModelReady: (model) => model.initializeMapAndMarkers(
        devicePixelRatio: devicePixelRatio,
        mapWidth: screenWidth(context),
        mapHeight: screenHeight(context),
      ),
      builder: (context, model, child) => Stack(
        children: [
          RotationGestureWidget(
            ignoreGestures: model.ignoreRotationGestures,
            onRotate: (DragUpdateDetails details) => model.rotate(
              dxPan: details.delta.dx,
              dyPan: details.delta.dy,
              dxGlob: details.globalPosition.dx,
              dyGlob: details.globalPosition.dy,
              screenWidth: screenWidth(context),
              screenHeight: screenHeight(context),
            ),
          ),
          GoogleMapsScreen(model: model),
          CloudOverlay(),
          RightFloatingButtons(
              onPressed: model.changeZoom, zoomedIn: model.zoomedIn),
        ],
      ),
    );
  }
}

class RotationGestureWidget extends StatelessWidget {
  final ignoreGestures;
  final void Function(DragUpdateDetails) onRotate;
  const RotationGestureWidget({
    Key? key,
    required this.ignoreGestures,
    required this.onRotate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoreGestures,
      child: Container(
        color: Colors.white.withOpacity(0.0),
        width: screenWidth(context),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                //behavior: HitTestBehavior.translucent,
                //behavior: HitTestBehavior.translucent,
                onPanUpdate: onRotate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleMapsScreen extends StatelessWidget {
  final MapOverviewViewModel model;
  const GoogleMapsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      child: Column(
        children: [
          Container(height: 150),
          Expanded(
            // transparent pointer needed so that rotation gesture widget
            // receives events!
            child: TransparentPointer(
              child: GoogleMap(
                onTap: (_) => model.notifyListeners(),
                //mapType: MapType.hybrid,
                initialCameraPosition: model.initialCameraPosition(),

                //Place Markers in the Map
                markers: model.markersOnMap,
                // onCameraMove: ,

                //callback that’s called when the map is ready to use.
                onMapCreated: model.onMapCreated,

                //enable zoom gestures
                zoomGesturesEnabled: true,
                //minMaxZoomPreference: MinMaxZoomPreference(13,17)

                //For showing your current location on Map with a blue dot.
                myLocationEnabled: true,
                //Remove the Zoom in and out button
                zoomControlsEnabled: false,

                tiltGesturesEnabled: true,

                // Button used for bringing the user location to the center of the camera view.
                myLocationButtonEnabled: true,

                mapToolbarEnabled: false,

                buildingsEnabled: false,

                // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                //   new Factory<OneSequenceGestureRecognizer>(
                //     () => new EagerGestureRecognizer(),
                //   ),
                // ].toSet(),
                //  Set()
                //   ..add(
                //     Factory<PanGestureRecognizer>(
                //       () {
                //         return PanGestureRecognizer();
                //       },
                //     ),
                //   )
                //   ..add(
                //     Factory<VerticalDragGestureRecognizer>(
                //       () {
                //         return VerticalDragGestureRecognizer();
                //       },
                //     ),
                //   ),
                //onTap: model.handleTap(),
                //Enable Traffic Mode.
                //trafficEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CloudOverlay extends StatelessWidget {
  const CloudOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        child: Container(
          height: 200,
          child: Stack(
            children: [
              Container(
                height: 150,
                width: screenWidth(context),
                color: Colors.blue,
                child: Image.network(
                  "https://prooptimania.s3.us-east-2.amazonaws.com/ckfinder/images/luz-azul-cielo-azul.jpg",
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1)
                    ],
                    // begin: Alignment.bottomCenter,
                    // end: Alignment.topCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: [
                        0.0,
                        0.45,
                        0.55,
                        1.0,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainHeader extends StatelessWidget {
  const MainHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      //color: Colors.blue.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(
          horizontal: kHorizontalPadding, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(width: 80, color: Colors.green),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 60, color: Colors.green),
              horizontalSpaceMedium,
              Container(width: 60, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}

class RightFloatingButtons extends StatelessWidget {
  final void Function() onPressed;
  final bool zoomedIn;
  const RightFloatingButtons(
      {Key? key, required this.onPressed, required this.zoomedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 100,
          right: 10,
        ),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 80,
            height: 60,
            color: Colors.green.withOpacity(0.8),
            alignment: Alignment.center,
            child: zoomedIn == true ? Text("Zoom Out") : Text("Zoom In"),
          ),
        ),
      ),
    );
  }
}

class MainFooter extends StatelessWidget {
  const MainFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        //color: Colors.blue.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(width: 80, color: Colors.green),
            horizontalSpaceLarge,
            Expanded(
              child: Container(color: Colors.black),
            ),
            horizontalSpaceLarge,
            Container(width: 80, color: Colors.green),
          ],
        ),
      ),
    );
  }
}



// !!! DEPRECATED VERSION


/*

class ExplorerHomeView extends StatelessWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
      viewModelBuilder: () => ExplorerHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Hi ${model.name}!",
          drawer: true,
        ),
        endDrawer: SizedBox(
          width: screenWidth(context, percentage: 0.8),
          child: const DrawerWidgetView(),
        ),
        body: model.isBusy
            ? AFKProgressIndicator()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: RefreshIndicator(
                  onRefresh: () async => model.listenToData(),
                  child: ListView(
                    children: [
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 10,
                            child: StatsCard(
                                onCardPressed:
                                    model.showToEarnExplanationDialog,
                                statsType: StatsType.lockedCredits,
                                height: 140,
                                statistic:
                                    // availableSponsoring IN CENTS!!!!!!
                                    formatAfkCreditsFromCents(model
                                        .currentUserStats.availableSponsoring),
                                title: kCreditsToEarnDescription),
                          ),
                          Spacer(),
                          Flexible(
                            flex: 10,
                            child: StatsCard(
                                onCardPressed:
                                    model.showEarnedExplanationDialog,
                                statsType: StatsType.unlockedCredits,
                                height: 140,
                                statistic: model
                                    .currentUserStats.afkCreditsBalance
                                    .toString(),
                                title: kCurrentAFKCreditsDescription),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      LargeButton(
                        title: "GET REWARDS",
                        onPressed: model.navigateToRewardsView,
                        imageUrl: kRewardImpageUrl,
                        backgroundColor: kDarkTurquoise.withOpacity(0.9),
                        titleColor: kWhiteTextColor,
                      ),
                      verticalSpaceSmall,
                      verticalSpaceSmall,
                      SectionHeader(
                        horizontalPadding: 0,
                        title: "Achievements",
                        onButtonTap: model.navigateToAchievementsView,
                      ),
                      if (model.achievements.length > 0)
                        AchievementsGrid(
                          achievements: model.achievements,
                          onPressed: () => null,
                        ),
                      verticalSpaceSmall,
                      verticalSpaceSmall,
                      SectionHeader(
                        horizontalPadding: 0,
                        title: "Quest History",
                        onButtonTap: model.navigateToQuestHistoryView,
                      ),
                      if (model.activatedQuestsHistory.length > 0)
                        QuestsGrid(
                          activatedQuests: model.activatedQuestsHistory,
                          onPressed: () => null,
                        ),
                      // verticalSpaceLarge,
                      //SectionHeader(title: "Achievements"),
                      verticalSpaceMassive,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class ExplorerCreditStats extends StatelessWidget {
  final UserStatistics userStats;
  const ExplorerCreditStats({Key? key, required this.userStats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: StatsCard(
                  statsType: StatsType.lockedCredits,
                  height: 140,
                  statistic:
                      // availableSponsoring IN CENTS!!!!!!
                      formatAfkCreditsFromCents(userStats.availableSponsoring),
                  title: kCreditsToEarnDescription),
            ),
            Spacer(),
            Flexible(
              flex: 5,
              child: StatsCard(
                  statsType: StatsType.unlockedCredits,
                  height: 140,
                  statistic: userStats.afkCreditsBalance.toString(),
                  title: kCurrentAFKCreditsDescription),
            ),
          ],
        ),
        verticalSpaceMedium,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Flexible(
        //       child: StatsCard(
        //           height: 80,
        //           statistic: userStats.lifetimeEarnings.toString(),
        //           subtitle: kLifetimeEarningsDescription),
        //     ),
        //     Flexible(
        //       child: StatsCard(
        //           height: 80,
        //           statistic: userStats.numberQuestsCompleted.toString(),
        //           subtitle: kNumberCompletedQuestsDescription),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class QuestsGrid extends StatelessWidget {
  final List<ActivatedQuest> activatedQuests;
  final void Function() onPressed;
  const QuestsGrid({
    Key? key,
    required this.activatedQuests,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
        ),
        itemCount: activatedQuests.length,
        itemBuilder: (context, index) {
          final ActivatedQuest data = activatedQuests[index];
          return FinishedQuestCard(
            quest: data,
            onTap: () => null,
          );
        },
      ),
    );
  }
}

class AchievementsGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final void Function() onPressed;
  const AchievementsGrid({
    Key? key,
    required this.achievements,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final Achievement data = achievements[index];
          return AchievementCard(
            achievement: data,
            //onTap: () => null,
          );
        },
      ),
    );
  }
}
*/