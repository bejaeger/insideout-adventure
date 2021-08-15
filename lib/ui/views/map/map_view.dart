import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'map_viewmodel.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('AFK TREASURE HUNTING'),
        ),
        body: Container(
          child: GoogleMap(
            initialCameraPosition: model.position,
          ),
        ),
      ),
      viewModelBuilder: () => MapViewModel(),
    );
  }
}
