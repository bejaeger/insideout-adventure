// This is the main class with the google map
// that has the viewmodel attached that takes care
// of all map functionality
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/right_floating_buttons_overlay_view.dart';
import 'package:afkcredits/ui/views/map/avatar_and_effects_on_map_view.dart';
import 'package:afkcredits/ui/views/map/google_map_screen.dart';
import 'package:afkcredits/ui/views/map/map_gestures_widget.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/map/overlays/cloud_overlay.dart';
import 'package:afkcredits/ui/widgets/animations/map_animations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainMapView extends StatelessWidget {
  final void Function()? callback;
  //with MapControllerMixin {
  const MainMapView({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => locator<MapViewModel>(),
      onModelReady: (model) {
        model.initializeMapAndMarkers();
      },
      disposeViewModel:
          false, // ! important because we can't dispose a singleton and use it again!
      builder: (context, model, child) {
        print("-->> rebuild main map");
        return Stack(
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
              callback: callback,
            ),
            CloudOverlay(
              overlay: model.isAvatarView,
            ),
            // Ripple Effect
            // TODO: update treatment of isFingerOnScreen
            // if (model.hasActiveQuest && !model.isFingerOnScreen)
            //   MapEffects(activeQuest: model.activeQuest),
            AvatarAndEffectsOnMapView(),
            // Avatar overlaid with Lottie
            RightFloatingButtonsView(
              // onCompassTap: model.rotateToNorth,
              onZoomPressed: model.changeMapZoom,
            ),
          ],
        );
      },
    );
  }
}
