import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/marker_status.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'add_markers_viewmodel.dart';

class AddMarkersView extends StatefulWidget {
  @override
  _AddMarkersViewState createState() => _AddMarkersViewState();
}

class _AddMarkersViewState extends State<AddMarkersView> {
  GoogleMapController? _googleMapController;
  Marker? userMarkers;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddMarkersViewModel>.reactive(
      viewModelBuilder: () => AddMarkersViewModel(marker: userMarkers),
      builder: (context, model, child) => model.isBusy
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: CustomAppBar(
                title: 'Add AFK Markers',
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  //alignment: Alignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: GoogleMap(
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: model.initialCameraPosition(),
                        onMapCreated: (controller) =>
                            _googleMapController = controller,
                        markers: {
                          if (userMarkers != null) userMarkers!,
                        },
                        onLongPress: model.addMarkerToMap,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            activeColor: Colors.blueAccent,
                            groupValue: model.getGroupId,
                            onChanged: (int? selectMarkerStatus) =>
                                model.checkMarkerStatus(
                                    checkMarkerStatus: selectMarkerStatus),
                          ),
                          Text('Testing'),
                        ],
                      ),
                    ),
                    verticalSpaceSmall,
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 2,
                            activeColor: Colors.lightGreen,
                            groupValue: model.getGroupId,
                            onChanged: (int? selectMarkerStatus) =>
                                model.checkMarkerStatus(
                                    checkMarkerStatus: selectMarkerStatus),
                          ),
                          Text('Placed'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (model.getGroupId == 1) {
                            model.addMarkersToFirebase(
                                status: MarkerStatus.testing);
                          } else {
                            model.addMarkersToFirebase(
                                status: MarkerStatus.placed);
                          }
                          model.setGroupNumber();
                        },
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Add Markers",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Sofia",
                                  fontSize: 19.0),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
              floatingActionButton: Stack(
                children: [
                  Positioned(
                    bottom: 70,
                    right: 4,
                    child: AFKFloatingActionButton(
                      onPressed: model.initialCameraPosition() == null
                          ? () async => null
                          : () async {
                              _googleMapController!.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  model.initialCameraPosition(),
                                ),
                              );
                            },
                      icon: const Icon(Icons.qr_code_scanner_rounded,
                          size: 30, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
