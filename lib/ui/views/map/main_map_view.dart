// This is the main class with the google map
// that has the viewmodel attached that takes care
// of all map functionality
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/right_floating_buttons_overlay.dart';
import 'package:afkcredits/ui/views/map/avatar_on_map.dart';
import 'package:afkcredits/ui/views/map/google_map_screen.dart';
import 'package:afkcredits/ui/views/map/map_gestures_widget.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/map/overlays/cloud_overlay.dart';
import 'package:afkcredits/ui/widgets/animations/map_animations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
          MapGesturesWidget(
            ignoreGestures: !model
                .isAvatarView, // ignore gestures when we are in bird's view
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
          GoogleMapScreen(
            model: model,
          ),
          CloudOverlay(
            overlay: model.isAvatarView,
          ),
          // Ripple Effect
          if (model.hasActiveQuest) MapEffects(activeQuest: model.activeQuest),
          AvatarOnMap(
              characterNumber: model.characterNumber,
              show: (!((model.isShowingQuestDetails ||
                          !model.isAvatarView ||
                          model.isFadingOutOverlay ||
                          model.isMovingCamera) &&
                      !model.hasActiveQuest)) &&
                  model.isAvatarView),
          // Avatar overlaid with Lottie
          RightFloatingButtons(
            onCompassTap: model.rotateToNorth,
            bearing: model.bearing,
            onZoomPressed: model.changeMapZoom,
            zoomedIn: model.isAvatarView,
            isShowingQuestDetails: model.isShowingQuestDetails,
            onChangeCharacterTap: model.nextCharacter,
            hasActiveQuest: model.hasActiveQuest,
          ),
        ],
      ),
    );
  }
}
