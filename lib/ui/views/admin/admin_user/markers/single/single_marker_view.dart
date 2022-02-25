import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../enums/marker_status.dart';
import '../../../../../../utils/ui_helpers.dart';
import 'single_marker_viewmodel.dart';

class SingleMarkerView extends StatefulWidget {
  @override
  _SingleMarkerViewState createState() => _SingleMarkerViewState();
}

class _SingleMarkerViewState extends State<SingleMarkerView> {
  GoogleMapController? googleMapController;
  @override
  void dispose() {
    googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleMarkerViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Single Marker'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                verticalSpaceSmall,
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: GoogleMap(
                      //enable zoom gestures
                      zoomGesturesEnabled: true,

                      zoomControlsEnabled: true,

                      // Button used for bringing the user location to the center of the camera view.
                      myLocationButtonEnabled: true,
                      initialCameraPosition: model.initialCameraPosition(),
                      onMapCreated: (controller) =>
                          googleMapController = controller,
                      markers: model.getMarkersOnMap.length > 0
                          ? {
                              model.getMarkersOnMap.last,
                            }
                          : model.getMarkersOnMap,
                      onTap: model.addMarkerToMap,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1.5,
                      child: Radio(
                        value: 1,
                        activeColor: Colors.blueAccent,
                        groupValue: model.getGroupId,
                        onChanged: (int? selectMarkerStatus) =>
                            model.checkMarkerStatus(
                                checkMarkerStatus: selectMarkerStatus),
                      ),
                    ),
                    Text(
                      "Testing",
                      textAlign: TextAlign.left,
                      style: textTheme(context).headline6!.copyWith(
                          color: kBlackHeadlineColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Transform.scale(
                      scale: 1.5,
                      child: Radio(
                        value: 2,
                        activeColor: Colors.lightGreen,
                        groupValue: model.getGroupId,
                        onChanged: (int? selectMarkerStatus) =>
                            model.checkMarkerStatus(
                                checkMarkerStatus: selectMarkerStatus),
                      ),
                    ),
                    Text(
                      "Placed",
                      textAlign: TextAlign.left,
                      style: textTheme(context).headline6!.copyWith(
                          color: kBlackHeadlineColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {
                          if (model.getGroupId == 1) {
                            model.addMarkersToFirebase(
                                status: MarkerStatus.testing,
                                afkMarker: model.getMarkersOnMap.last);
                          } else {
                            model.addMarkersToFirebase(
                                status: MarkerStatus.placed,
                                afkMarker: model.getMarkersOnMap.last);
                          }
                          model.setGroupNumber();
                        },
                        child: const Text("Add Markers"),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            primary: kWhiteTextColor,
                            // shape: const StadiumBorder(),
                            shadowColor: Colors.purpleAccent),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {
                          model.resetMarkersValues();
                          model.navBackToPreviousView();
                        },
                        child: const Text("Cancel"),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            primary: kWhiteTextColor,
                            // shape: const StadiumBorder(),
                            shadowColor: Colors.purpleAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SingleMarkerViewModel(),
    );
  }
}
