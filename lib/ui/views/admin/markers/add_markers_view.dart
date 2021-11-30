import 'package:afkcredits/apis/direction_api.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'add_markers_viewmodel.dart';

/*
class AddMarkersView extends StatelessWidget {
  const AddMarkersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddMarkersViewModel>.reactive(
      viewModelBuilder: () => AddMarkersViewModel(),
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
                //height:  constrains.maxHeight,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    verticalSpaceSmall,
                    Expanded(
                      flex: 8,
                      child: GoogleMap(
                        initialCameraPosition: model.initialCameraPosition(),
                        //callback that’s called when the map is ready to use.
                        onMapCreated: model.onMapCreated,
                        //enable zoom gestures
                        zoomGesturesEnabled: true,
                        //Remove the Zoom in and out button
                        zoomControlsEnabled: false,
                        markers: {
                          if (model.getMarkers != null) model.getMarkers
                        },

                        onLongPress: model.addMarkersToMap,
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
                            /*      model.addMarkers(
                              markers: AFKMarker(
                                  id: id, qrCodeId: qrCodeId, lat: lat)); */
                          } else {}
                          //  _showDialog(context);
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
                    verticalSpaceSmall,
                  ],
                ),
              ),
              floatingActionButton: Stack(
                children: [
                  Positioned(
                    bottom: 70,
                    right: 4,
                    child: MyFloatingActionButton(
                      onPressed: model.initialCameraPosition() == null
                          ? () async => null
                          : () async {
                              model.getGoogleMapController!.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      model.initialCameraPosition()));
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
*/
class AddMarkersView extends StatefulWidget {
  @override
  _AddMarkersViewState createState() => _AddMarkersViewState();
}

class _AddMarkersViewState extends State<AddMarkersView> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController!.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        print("Harguilar Printed This Out:" + "" + _origin.toString());
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsAPI()
          .getDirections(origin: _origin!.position, destination: pos);
      setState(() => _info = directions);
    }
  }
}
