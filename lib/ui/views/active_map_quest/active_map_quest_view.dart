import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class ActiveMapQuestView extends StatelessWidget {
  const ActiveMapQuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveMapQuestViewModel>.reactive(
      viewModelBuilder: () => ActiveMapQuestViewModel(),
      disposeViewModel: false,
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Active Quest',
            onBackButton: () => model.navigateBack(),
          ),
          body: Container(
            child: Stack(
              children: [
                GoogleMap(
                  //mapType: MapType.hybrid,
                  initialCameraPosition: model.initialCameraPosition(),
                  //Place Markers in the Map
                  markers: model.markersOnMap,
                  //callback that’s called when the map is ready to us.
                  onMapCreated: model.onMapCreated,
                  //For showing your current location on Map with a blue dot.
                  myLocationEnabled: true,

                  // Button used for bringing the user location to the center of the camera view.
                  myLocationButtonEnabled: true,

                  //Remove the Zoom in and out button
                  zoomControlsEnabled: false,

                  //onTap: model.handleTap(),
                  //Enable Traffic Mode.
                  //trafficEnabled: true,
                ),
                if (model.isBusy)
                  Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()),
              ],
            ),
          ),
          //Place the Floating Action to the Left of the View
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyFloatingActionButton(
                onPressed: () async {
                  model.getGoogleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                          model.initialCameraPosition()));
                  await model.scanQrCode();
                },
                icon: const Icon(Icons.qr_code_scanner_rounded,
                    size: 30, color: Colors.white),
              ),
              verticalSpaceSmall,
            ],
          ),
        ),
      ),
    );
  }
}
