import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

//
// Map that shows the actual GoogleMap!
//

class GoogleMapScreen extends StatelessWidget {
  final MapViewModel model;
  final void Function()? callback;
  final void Function(double, double)? showCreateQuestDialog;
  const GoogleMapScreen({
    Key? key,
    required this.model,
    this.showCreateQuestDialog,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // transparent pointer needed so that rotation gesture widget
    // receives events!
    return TransparentPointer(
      child: Container(
        height: screenHeight(context),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            // This container is used to push the center of the map
            // a bit further down on the screen (similar to Pokemon Go)
            if (!model.isParentAccount)
              AnimatedContainer(
                // this decides on whether the avatar is on top of the blue button or not
                // TODO: TEST for different device sizes!
                height: model.isAvatarView == true
                    ? screenHeight(context, percentage: 0.18)
                    : 0,
                duration: Duration(milliseconds: 500),
                color: Colors.transparent,
              ),
            Container(
              height: screenHeight(context),
              child: GoogleMap(
                onTap: showCreateQuestDialog != null
                    ? (LatLng latLng) => showCreateQuestDialog!(
                        latLng.latitude, latLng.longitude)
                    : null,
                initialCameraPosition: GoogleMapService.initialCameraPosition(
                  userLocation: model.userLocation,
                  parentAccount: model.isParentAccount,
                ),
                markers: GoogleMapService.markersOnMap,
                circles: GoogleMapService.circlesOnMap,
                //callback that’s called when the map is ready to use.
                onMapCreated: (GoogleMapController controller) {
                  if (!model.isParentAccount) {
                    controller.setMapStyle(model.mapStyle);
                  }
                  GoogleMapService.setMapController(controller);
                },
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: model.isParentAccount ? true : false,
                tiltGesturesEnabled: model.isParentAccount ? true : false,
                myLocationButtonEnabled:
                    false, //model.isParentAccount ? true : false,
                mapToolbarEnabled: false,
                buildingsEnabled: false,
                compassEnabled: model.isParentAccount ? true : false,
                onCameraMove: (position) {
                  // only sets state. values are not listened to.
                  // just to be able to go back to previous camera settings
                  model.changeCameraBearing(position.bearing);
                  model.changeCameraZoom(position.zoom);
                  model.changeCameraLatLon(
                      position.target.latitude, position.target.longitude);
                  if ((!model.isAvatarView || model.isParentAccount) &&
                      (!model.hasActiveQuest)) {
                    model.checkForNewQuests(callback: callback);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
