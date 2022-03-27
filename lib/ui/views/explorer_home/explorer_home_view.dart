import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/enums/quests/direction_status.dart';
import 'package:afkcredits/enums/stats_type.dart';
import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/shared/maps/maps_controller_mixin.dart';
import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/main_footer_viewmodel.dart';
import 'package:afkcredits/ui/views/drawer_widget/drawer_widget_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/achievement_card.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/afk_credits_display.dart';
import 'package:afkcredits/ui/widgets/finished_quest_card.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/large_button.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/main_avatar_view.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/round_close_button.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dart:math' as m;

import 'package:afkcredits/app/app.logger.dart';

final log = getLogger("REBUILD LOGGER");

class ExplorerHomeView extends StatefulWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  State<ExplorerHomeView> createState() => _ExplorerHomeViewState();
}

class _ExplorerHomeViewState extends State<ExplorerHomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
        // TODO: Explorer Home ViewModel for now is reactive to layout service
        // TODO: Maybe that is not desired eventually, as it might trigger
        // TODO: Many unnecessary rebuilds
        viewModelBuilder: () => ExplorerHomeViewModel(),
        onModelReady: (model) => model.initialize(),
        builder: (context, model, child) {
          // log.wtf("==>> Rebuild ExplorerHomeView");
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  // bottom layer
                  //if (!model.isBusy)
                  if (!model.isBusy) MainMapView(),
                  if (model.showLoadingScreen)
                    MapLoadingOverlay(show: model.showFullLoadingScreen),
                  MainHeader(
                    show:
                        (!model.isShowingQuestDetails && !model.hasActiveQuest),
                    onPressed: model.showNotImplementedSnackbar,
                    onCreditsPressed: model.showNotImplementedSnackbar,
                  ),
                  MainFooter(onMiddleTap: () => null),
                  QuestListOverlayView(),

                  QuestDetailsOverlay(),

                  OverlayedCloseButton(),

                  if (model.isShowingARView) BlackFadeOut(),
                ],
              ),
            ),
          );
        });
  }
}

class BlackFadeOut extends StatefulWidget {
  const BlackFadeOut({
    Key? key,
  }) : super(key: key);

  @override
  State<BlackFadeOut> createState() => _BlackFadeOutState();
}

class _BlackFadeOutState extends State<BlackFadeOut>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  // ..repeat(reverse: true);
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
      curve: Curves.easeIn,
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
    return FadeTransition(
      opacity: _animation,
      child: Container(
        color: Colors.black,
      ),
    );
  }
}

class QuestDetailsOverlay extends StatelessWidget {
  const QuestDetailsOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveMapQuestViewModel>.reactive(
        viewModelBuilder: () => ActiveMapQuestViewModel(),
        builder: (context, model, child) {
          final Quest? quest =
              model.selectedQuest ?? model.activeQuestNullable?.quest ?? null;
          return IgnorePointer(
            ignoring: (!model.isShowingQuestDetails && !model.hasActiveQuest),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: (model.isShowingQuestDetails || model.hasActiveQuest)
                  ? 1
                  : 0.0,
              child: MainStack(
                onBackPressed:
                    model.isShowingQuestDetails ? model.popQuestDetails : null,
                showBackButton: !model.hasActiveQuest,
                child: Stack(
                  children: [
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
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
                                ],
                              ),
                              verticalSpaceTiny,
                              AfkCreditsText.headingTwo(quest?.name ?? "QUEST"),
                              verticalSpaceTiny,
                              CreditsAmount(amount: quest?.afkCredits ?? -1),
                              verticalSpaceMedium,
                              if (quest != null)
                                if (quest.type ==
                                    QuestType.TreasureLocationSearch)
                                  // TODO: Make this a specific new View for each type of quest
                                  Expanded(
                                    child: TreasureLocationSearch(
                                        onStartQuest: () =>
                                            model.notifyListeners(),
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
            ),
          );
        });
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: model.hasActiveQuest ? 0 : 70.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!model.hasActiveQuest)
                        Expanded(
                          child: AfkCreditsButton(
                              onTap: model.showInstructions,
                              title: "Tutorial",
                              color: kPrimaryColor.withOpacity(0.7),
                              leading:
                                  Icon(Icons.help, color: Colors.grey[100])),
                        ),
                      horizontalSpaceSmall,
                      if (model.showStartSwipe && !model.isBusy)
                        // model.distanceToStartMarker < 0
                        //     ? AFKProgressIndicator()
                        //     :
                        Expanded(
                          child: AFKSlideButton(
                            alignment: Alignment.bottomCenter,
                            canStartQuest:
                                true, // model.isNearStartMarker == true,
                            quest: quest,
                            onSubmit: () => model.maybeStartQuest(
                                quest: quest,
                                onStartQuestCallback: onStartQuest),
                          ),
                        ),
                      !model.questSuccessfullyFinished &&
                              model.hasActiveQuest &&
                              5 == 4
                          ? AFKFloatingActionButton(
                              backgroundColor: model.hasActiveQuest
                                  ? Colors.orange
                                  : Colors.grey[600],
                              width: 80,
                              height: 80,
                              onPressed: !activeDetector
                                  ? (model.hasActiveQuest
                                      ? model.showReloadingInfo
                                      : model.showStartQuestInfo)
                                  : model.checkDistance,
                              icon: !model.allowCheckingPosition
                                  ? Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 80, maxHeight: 80),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(kMagnetIconPath,
                                                alignment: Alignment.center,
                                                width: 40,
                                                height: 80,
                                                color: Colors.black),
                                          ),
                                          Align(
                                              alignment: Alignment.center,
                                              child: Opacity(
                                                opacity: 0.7,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 80,
                                                      color: Colors.grey[200],
                                                      width: 80,
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
                                      period:
                                          const Duration(milliseconds: 1000),
                                      enabled: activeDetector,
                                      child: model.isCheckingDistance
                                          ? AFKProgressIndicator(
                                              color: Colors.white)
                                          : Image.asset(kMagnetIconPath,
                                              width: 40),
                                    ),
                            )
                          : SizedBox(height: 0, width: 0),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class MapLoadingOverlay extends StatelessWidget {
  final bool show;
  const MapLoadingOverlay({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: Duration(milliseconds: 500),
      child: Container(
        color: Colors.grey[100],
        alignment: Alignment.center,
        child: AfkCreditsText.headingThree("Loading..."),
      ),
    );
  }
}

// This is the main class with the google map
// that has the viewmodel attached that takes care
// of all map functionality
class MainMapView extends StatelessWidget {
  //with MapControllerMixin {
  const MainMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => locator<MapViewModel>(),
      onModelReady: (model) {
        model.initializeMapAndMarkers();
      },
      disposeViewModel: false,
      builder: (context, model, child) => Stack(
        children: [
          //CloudOverlay(overlay: true),
          GoogleMapsScreen(
            model: model,
          ),
          RotationGestureWidget(
            ignoreGestures: !model.isAvatarView ||
                model
                    .suppressOneFingerRotations, // ignore gestures when we are in bird's view
            onRotate: (ScaleUpdateDetails details) => model.rotate(
              dxPan: details.focalPointDelta.dx,
              //details.delta.dx,
              dyPan: details.focalPointDelta.dy,
              dxGlob: details.focalPoint.dx,
              dyGlob: details.focalPoint.dy,
              scale: details.scale,
              rotation: details.rotation,
              // dxPan: details.delta.dx,
              // //details.delta.dx,
              // dyPan: details.delta.dy,
              // dxGlob: details.position.dx,
              // dyGlob: details.position.dy,
              // scale: 1,
              screenWidth: screenWidth(context),
              screenHeight: screenHeight(context),
            ),
          ),
          CloudOverlay(
            overlay: model.isAvatarView,
          ),
          //IgnorePointer(child: Container(color: Colors.white.withOpacity(0.1))),
          RightFloatingButtons(
            onCompassTap: model.rotateToNorth,
            bearing: model.bearing,
            onZoomPressed: model.changeMapZoom,
            zoomedIn: model.isAvatarView,
            isShowingQuestDetails: model.isShowingQuestDetails,
            onChangeCharacterTap: model.nextCharacter,
            hasActiveQuest: model.hasActiveQuest,
          ),

          // RIPPLE Effect
          if (model.hasActiveQuest)
            Positioned(
              //alignment: Alignment(0, 0.4),
              bottom: 105,
              left: 2,
              right: 2,
              child: IgnorePointer(
                child: Lottie.network(
                  'https://assets7.lottiefiles.com/packages/lf20_Ei9xER.json',
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          // Load a Lottie file from a remote url
          Positioned(
            //alignment: Alignment(0, 0.4),
            bottom: 185,
            left: 2,
            right: 2,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: ((model.isShowingQuestDetails ||
                          !model.isAvatarView ||
                          model.isShowingARView ||
                          model.isMovingCamera) &&
                      !model.hasActiveQuest)
                  ? 0
                  : 1,
              child: IgnorePointer(
                child: model.characterNumber == 0
                    ? Lottie.network(
                        // chilling dude
                        'https://assets2.lottiefiles.com/packages/lf20_0w4fvbov.json',
                        height: 150,
                        width: 150,
                      )
                    : model.characterNumber == 1
                        ?
                        // Left!
                        Lottie.network(
// walking normal girl
                            'https://assets6.lottiefiles.com/private_files/lf30_afru6l2d.json',
                            height: 165,
                            width: 165,
                          )
                        : model.characterNumber == 2
                            ? Lottie.network(
                                // stick figure running to the right
                                'https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f5c27455-a334-4e03-b223-0a29781f875f/lf30_editor_s2qny0a9.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220325%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220325T012411Z&X-Amz-Expires=86400&X-Amz-Signature=d08e495b50bdec5471fa5ce4ad9894f75ddf6abddc2b59835d417fa27f6e8fe4&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22lf30_editor_s2qny0a9.json%22&x-id=GetObject',
                                height: 150,
                                width: 150,
                              )
                            : model.characterNumber == 3
                                ? Lottie.network(
                                    // dude walking to the right
                                    'https://assets3.lottiefiles.com/packages/lf20_4jip3mqj.json',

                                    height: 160,
                                    width: 160,
                                  )
                                : model.characterNumber == 4
                                    ? Lottie.network(
                                        // colored stick figure walking to the left
                                        'https://assets3.lottiefiles.com/packages/lf20_tbbtmun4.json',
                                        height: 165,
                                        width: 165,
                                      )
                                    : Lottie.network(
                                        // weird figure walking to the right
                                        'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/walking.json',
                                        height: 150,
                                        width: 150,
                                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RotationGestureWidget extends StatelessWidget {
  final ignoreGestures;
  final void Function(ScaleUpdateDetails) onRotate;
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
        height: screenHeight(context),
        width: screenWidth(context),
        child: Column(
          children: [
            // This avoids overlap of the below gesture detector (for the main map)
            // and the widgets in the header! Sometimes this creates issues!
            SizedBox(height: 70),
            Expanded(
              child: GestureDetector(
                //behavior: HitTestBehavior.opaque,
                onScaleUpdate: onRotate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleMapsScreen extends StatelessWidget {
  final MapViewModel model;
  const GoogleMapsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      child: TransparentPointer(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            // This container is used to push the center of the map
            // a bit further down on the screen (similar to Pokemon Go)
            AnimatedContainer(
              height: model.isAvatarView == true ? 150 : 0,
              duration: Duration(milliseconds: 500),
              color: Colors.transparent,
            ),
            Container(
              height: screenHeight(context),
              // transparent pointer needed so that rotation gesture widget
              // receives events!
              child: TransparentPointer(
                child: GoogleMap(
                  onTap: (_) => model.notifyListeners(),
                  //mapType: MapType.hybrid,
                  initialCameraPosition: GoogleMapService.initialCameraPosition(
                      userLocation: model.userLocation),
                  //Place Markers in the Map
                  markers: GoogleMapService.markersOnMap,
                  //callback that’s called when the map is ready to use.
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(model.mapStyle);
                    GoogleMapService.setMapController(controller);
                  },
                  //enable zoom gestures
                  zoomGesturesEnabled: true,
                  //minMaxZoomPreference: MinMaxZoomPreference(13,17)
                  //For showing your current location on Map with a blue dot.
                  myLocationEnabled: true,
                  //Remove the Zoom in and out button
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  // Button used for bringing the user location to the center of the camera view.
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  buildingsEnabled: false,
                  compassEnabled: false,
                  onCameraMove: (position) {
                    model.changeCameraBearing(position.bearing);
                    model.changeCameraZoom(position.zoom);
                    model.changeCameraLatLon(
                        position.target.latitude, position.target.longitude);
                  },
                  // gestureRecognizers: Set()
                  //   ..add(
                  //     Factory<PanGestureRecognizer>(
                  //       () {
                  //         return PanGestureRecognizer();
                  //       },
                  //     ),
                  //   )
                  // ..add(
                  //   Factory<VerticalDragGestureRecognizer>(
                  //     () {
                  //       return VerticalDragGestureRecognizer();
                  //     },
                  //   ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CloudOverlay extends StatelessWidget {
  final bool overlay;
  const CloudOverlay({Key? key, required this.overlay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        child: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: overlay
              ? AnimatedOpacity(
                  opacity: 1,
                  // opacity: overlay == true ? 1 : 0,
                  duration: Duration(seconds: 1),
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
                                Colors.white.withOpacity(0.65)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
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
                )
              : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.8),
                      ],
                      stops: [
                        0.0,
                        0.5,
                        0.75,
                        1.0,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class OutlineBox extends StatelessWidget {
  final String? text;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final double borderWidth;
  final void Function()? onPressed;
  const OutlineBox(
      {Key? key,
      this.width,
      this.height,
      this.text,
      this.onPressed,
      this.color,
      this.textColor,
      this.borderWidth = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!, width: borderWidth),
          borderRadius: BorderRadius.circular(15.0),
          color: color,
        ),
        child: SizedBox.expand(
          child: text != null
              ? Center(
                  child: AfkCreditsText.body(text!,
                      align: TextAlign.center,
                      color: textColor ?? kBlackHeadlineColor))
              : SizedBox.expand(),
        ),
      ),
    );
  }
}

class MainHeader extends StatelessWidget {
  final bool show;
  final void Function()? onPressed;
  final void Function()? onCreditsPressed;
  const MainHeader(
      {Key? key, this.onPressed, required this.show, this.onCreditsPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //log.wtf("Rebuilding MainHeader");
    return IgnorePointer(
      ignoring: !show,
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Container(
          height: 70,
          //color: Colors.blue.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MainAvatarView(percentage: 0.4, level: 3, onPressed: onPressed),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, top: 14),
                child: AFKCreditsDisplay(
                    balance: 130, onPressed: onCreditsPressed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RightFloatingButtons extends StatelessWidget {
  final void Function() onZoomPressed;
  final void Function() onCompassTap;

  // !!! Temporary
  final void Function()? onChangeCharacterTap;

  final double bearing;
  final bool zoomedIn;
  final bool hasActiveQuest;
  final bool isShowingQuestDetails;
  const RightFloatingButtons({
    Key? key,
    required this.bearing,
    required this.onZoomPressed,
    required this.zoomedIn,
    required this.onCompassTap,
    required this.isShowingQuestDetails,
    this.onChangeCharacterTap,
    this.hasActiveQuest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (onChangeCharacterTap != null)
          Align(
            alignment: Alignment(-1, 0.65),
            child: Container(
              color: Colors.grey[200]!.withOpacity(0.3),
              width: 55,
              height: 55,
              child: GestureDetector(onTap: onChangeCharacterTap!),
            ),
          ),
        Align(
          alignment: Alignment(1, -0.75),
          child: Padding(
            padding: const EdgeInsets.only(right: 15, top: 100),
            child: AnimatedOpacity(
              opacity: (bearing > 5 || bearing < -5) ? 1 : 1,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: onCompassTap,
                child: Transform.rotate(
                  angle: -bearing * m.pi / 180,
                  child: Image.asset(
                    kCompassIcon,
                    height: 38,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IgnorePointer(
            ignoring: hasActiveQuest,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: (isShowingQuestDetails || hasActiveQuest) ? 0 : 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 120,
                  right: 10,
                ),
                child: GestureDetector(
                  onTap: (isShowingQuestDetails || hasActiveQuest)
                      ? null
                      : onZoomPressed,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: kShadowColor,
                              //offset: Offset(1, 1),
                              blurRadius: 0.5,
                              spreadRadius: 0.2)
                        ],
                        border:
                            Border.all(color: Colors.grey[800]!, width: 2.0),
                        borderRadius: BorderRadius.circular(90.0),
                        color: Colors.white.withOpacity(0.9)),
                    alignment: Alignment.center,
                    child: zoomedIn == true
                        ? Icon(Icons.my_location_rounded)
                        : Icon(Icons.location_searching),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MainFooter extends StatelessWidget {
  final void Function() onMiddleTap;
  const MainFooter({
    Key? key,
    required this.onMiddleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log.wtf("==>> Rebuild MainFooterView");
    return ViewModelBuilder<MainFooterViewModel>.reactive(
      viewModelBuilder: () => MainFooterViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        //alignment: Alignment.bottomCenter,
        child: IgnorePointer(
          ignoring: (model.isShowingQuestDetails || model.hasActiveQuest)
              ? true
              : false,
          child: AnimatedOpacity(
            opacity:
                (model.isShowingQuestDetails || model.hasActiveQuest) ? 0 : 1,
            duration: Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OutlineBox(
                  width: 80,
                  height: 60,
                  borderWidth: 0,
                  text: "SCREEN TIME",
                  onPressed: model.navToCreditsScreenTimeView,
                  color: kDarkTurquoise.withOpacity(0.8),
                  textColor: Colors.white,
                ),
                IgnorePointer(child: Spacer()), //horizontalSpaceLarge,
                Expanded(
                  child: Container(
                    child: CircularMenu(
                      alignment: Alignment.bottomCenter,
                      //backgroundWidget: OutlineBox(text: "MENU"),
                      startingAngleInRadian: 1.3 * 3.14,
                      endingAngleInRadian: 1.7 * 3.14,
                      toggleButtonColor: kDarkTurquoise.withOpacity(0.8),
                      toggleButtonMargin: 0,
                      toggleButtonBoxShadow: [],
                      toggleButtonSize: 35,
                      radius: model.isSuperUser ? 120 : 80,
                      items: [
                        CircularMenuItem(
                          icon: Icons.settings,
                          color: Colors.grey[600],
                          margin: 0,
                          boxShadow: [],
                          onTap: model.showNotImplementedSnackbar,
                        ),
                        CircularMenuItem(
                          icon: Icons.logout,
                          color: Colors.redAccent.shade700.withOpacity(0.9),
                          margin: 0,
                          boxShadow: [],
                          onTap: model.logout,
                          //model.logout();
                        ),
                        if (model.isSuperUser)
                          CircularMenuItem(
                            icon: Icons.person,
                            color: Colors.orange.shade700.withOpacity(0.9),
                            margin: 0,
                            boxShadow: [],
                            onTap: model.openSuperUserSettingsDialog,
                            //model.logout();
                          ),
                      ],
                    ),
                  ),
                ),
                IgnorePointer(child: Spacer()),
//                horizontalSpaceLarge,
                OutlineBox(
                  width: 80,
                  height: 60,
                  text: "QUESTS",
                  color: kDarkTurquoise.withOpacity(0.8),
                  textColor: Colors.white,
                  borderWidth: 0,
                  onPressed: model.showQuestListOverlay,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayedCloseButton extends StatelessWidget {
  const OverlayedCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestListOverlayViewModel>.reactive(
      viewModelBuilder: () => QuestListOverlayViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => model.isShowingQuestList
          ? Align(
              alignment: Alignment(0, 0.91),
              child: RoundCloseButton(onTap: model.removeQuestListOverlay),
            )
          : SizedBox(height: 0, width: 0),
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
