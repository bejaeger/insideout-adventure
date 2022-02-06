// ignore_for_file: must_be_immutable

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/marker_status.dart';
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
  GoogleMapController? _googleMapDisplayController;
  @override
  void dispose() {
    _googleMapController!.dispose();
    _googleMapDisplayController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddMarkersViewModel>.reactive(
      viewModelBuilder: () => AddMarkersViewModel(),
      onModelReady: (model) => model.setQuestList(),
      builder: (context, model, child) => model.isBusy
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              body: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    centerTitle: true,
                    title: Text(
                      ' Manage AFK Markers',
                    ),
                    floating: true,
                    expandedHeight: 80,
                    collapsedHeight: 100,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        verticalSpaceMedium,
                        MarkerToAddSection(
                          googleMapController: _googleMapController,
                          model: model,
                        ),
                        verticalSpaceMedium,
                        DisplayAllMarkersSection(
                          googlController: _googleMapDisplayController,
                          model: model,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class MarkerToAddSection extends StatelessWidget {
  AddMarkersViewModel model;
  GoogleMapController? googleMapController;
  MarkerToAddSection(
      {Key? key, required this.model, required this.googleMapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            verticalSpaceSmall,
            Text(
              "Marker To ADD",
              textAlign: TextAlign.left,
              style: textTheme(context).headline6!.copyWith(
                  color: kBlackHeadlineColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            verticalSpaceSmall,
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: GoogleMap(
                //enable zoom gestures
                zoomGesturesEnabled: true,
                //minMaxZoomPreference: MinMaxZoomPreference(13,17)

                //For showing your current location on Map with a blue dot.
                // myLocationEnabled: true,
                //Remove the Zoom in and out button
                zoomControlsEnabled: true,

                // Button used for bringing the user location to the center of the camera view.
                myLocationButtonEnabled: true,

                initialCameraPosition: model.initialCameraPosition(),
                onMapCreated: (controller) => googleMapController = controller,
                markers: model.markersInMap.getMarkersOnMap.length > 0
                    ? {
                        model.markersInMap.getMarkersOnMap.last,
                      }
                    : model.markersInMap.getMarkersOnMap,
                onTap: model.addMarkerToMap,
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
                            afkMarker: model.markersInMap.getMarkersOnMap.last);
                      } else {
                        model.addMarkersToFirebase(
                            status: MarkerStatus.placed,
                            afkMarker: model.markersInMap.getMarkersOnMap.last);
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
                    onPressed: () {},
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
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }
}

class DisplayAllMarkersSection extends StatelessWidget {
  AddMarkersViewModel model;
  GoogleMapController? googlController;
  DisplayAllMarkersSection(
      {Key? key, required this.model, required this.googlController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            verticalSpaceSmall,
            Text(
              "Display Available Markers",
              textAlign: TextAlign.left,
              style: textTheme(context).headline6!.copyWith(
                  color: kBlackHeadlineColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            verticalSpaceSmall,
            Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 8,
                  child: GoogleMap(
                      zoomGesturesEnabled: true,
                      // myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: model.initialCameraPosition(),
                      onMapCreated: (controller) =>
                          googlController = controller,
                      markers: model.markers
                      //onTap: model.addMarkerToMap,
                      ),
                ),
              ),
            ),
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Manage Markers"),
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
                    onPressed: () {},
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
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }
}


/*       
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
               */