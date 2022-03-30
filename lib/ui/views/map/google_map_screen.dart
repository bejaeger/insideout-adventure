import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

//
// Map that shows the actual GoogleMap!
//

class GoogleMapsScreen extends StatelessWidget {
  final MapViewModel model;
  const GoogleMapsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransparentPointer(
      child: Container(
        height: screenHeight(context),
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
              child: GoogleMap(
                //onTap: (_) => print("TAPPED"),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
