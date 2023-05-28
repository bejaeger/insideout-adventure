import 'package:google_maps_flutter/google_maps_flutter.dart';

mixin MapControllerMixin {
  // Move camera
  void moveZoomedInCamera({
    required GoogleMapController? controller,
    required double getBearing,
    required double getZoom,
    required double getTilt,
    required LatLng currentLocation,
  }) {
    if (controller != null) {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: getBearing,
            target: currentLocation,
            zoom: getZoom,
            tilt: getTilt,
          ),
        ),
      );
    }
  }

  // Rotate map when in avatar view (= zommed in)

  // Zoom out from avatar view to bird's view

  // Zoom in from bird's view to avatar view

}
