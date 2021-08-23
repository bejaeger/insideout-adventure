import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'map_viewmodel.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      //onModelReady: (model) => model.getCurrentLocation,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('AFK TREASURE HUNTING'),
        ),
        body: Container(
          child: GoogleMap(
            //mapType: MapType.hybrid,
            initialCameraPosition: model.initialCameraPosition,
            markers: model.markersTmp,
            onMapCreated: model.onMapCreated,
            //For showing your current location on Map with a blue dot.
            myLocationEnabled: true,
            // Button used for bringing the user location to the center of the camera view.
            myLocationButtonEnabled: false,
          ),
        ),
      ),
      viewModelBuilder: () => MapViewModel(),
    );
  }
}
