import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'map_viewmodel.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      //  onModelReady: (model) => model.createMarkers(),
      onModelReady: (model) => model.setCurrentUserPosition(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: 'AFK TREASURE HUNTING',
        ),
        body: Container(
          child: GoogleMap(
            onTap: (_) => model.notifyListeners(),
            //mapType: MapType.hybrid,
            initialCameraPosition: model.initialCameraPosition(),

            //Place Markers in the Map
            markers: model.getMarkers!,
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

            // Button used for bringing the user location to the center of the camera view.
            myLocationButtonEnabled: true,

            polylines: {
              if (model.getDirectionInfo != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: model.getDirectionInfo!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },

            //onTap: model.handleTap(),
            //Enable Traffic Mode.
            //trafficEnabled: true,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () async {
            model.getGoogleMapController!.animateCamera(
                model.getDirectionInfo != null
                    ? CameraUpdate.newLatLngBounds(
                        model.getDirectionInfo!.bounds, 100.0)
                    : CameraUpdate.newCameraPosition(
                        model.initialCameraPosition()));
            await model.scanQrCodeWithActiveQuest();
          },
          child: const Icon(Icons.center_focus_strong),
        ),
      ),
      viewModelBuilder: () => MapViewModel(),
    );
  }
}
