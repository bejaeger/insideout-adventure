import 'package:afkcredits/ui/views/quest/active_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class ActiveQuestView extends StatelessWidget {
  const ActiveQuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveQuestViewModel>.reactive(
      onModelReady: (model) => model.initilizeStartedQuest(),
      disposeViewModel: false,
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: 'Quest Running',
        ),
        body: Container(
          child: GoogleMap(
            //mapType: MapType.hybrid,
            initialCameraPosition: model.initialCameraPosition(),
            //Place Markers in the Map
            markers: model.getMarkers!,
            //callback that’s called when the map is ready to us.
            onMapCreated: model.onMapCreated,
            //For showing your current location on Map with a blue dot.
            myLocationEnabled: true,

            // Button used for bringing the user location to the center of the camera view.
            myLocationButtonEnabled: true,

            //Remove the Zoom in and out button
            zoomControlsEnabled: false,

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
        //Place the Floating Action to the Left of the View
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
          child: const Icon(Icons.qr_code),
        ),
      ),
      viewModelBuilder: () => ActiveQuestViewModel(),
    );
  }
}
