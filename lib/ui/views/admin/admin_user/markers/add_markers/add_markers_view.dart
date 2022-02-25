// ignore_for_file: must_be_immutable

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../../../../constants/asset_locations.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          verticalSpaceSmall,
          Text(
            "ADD A Marker",
            textAlign: TextAlign.left,
            style: textTheme(context).headline6!.copyWith(
                color: kBlackHeadlineColor,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
          verticalSpaceSmall,
          Row(
            children: [
              InkWell(
                onTap: () {
                  model.navToSingleMarkerView();
                }, // Handle your callback.
                splashColor: Colors.brown.withOpacity(0.5),
                child: Ink(
                  height: 200,
                  width: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(kMapPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              InkWell(
                onTap: () {
                  model.navToQrcodeView();
                }, // Handle your callback.
                splashColor: Colors.brown.withOpacity(0.5),
                child: Ink(
                  height: 200,
                  width: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(kQrcodePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
/*               ElevatedButton(
                onPressed: () {
                  print('Clicked ME');
                  model.navToSingleMarkerView();
                },
                child: Image.asset(
                  kMapPath,
                  fit: BoxFit.contain,
                ),
              ), */
/*               IconButton(
                color: Colors.teal,
                icon: Icon(
                  Icons.map,
                  size: 150,
                ),
                onPressed: () {
                  print('MAP');
                  model.navToSingleMarkerView();
                },
              ),
              horizontalSpaceMassive,
              IconButton(
                color: Colors.teal,
                icon: Icon(
                  Icons.qr_code,
                  size: 150,
                ),
                onPressed: () {
                  print('QRCODE');
                },
              ), */
            ],
          ),
/*           ElevatedButton(
              onPressed: () {
                print('Clicked ME');
                model.navToSingleMarkerView();
              },
              child: Text('Click Me')), */
/*             Container(
            height: MediaQuery.of(context).size.height / 4,
            child: GoogleMap(
              //enable zoom gestures
              zoomGesturesEnabled: true,

              zoomControlsEnabled: true,

              // Button used for bringing the user location to the center of the camera view.
              myLocationButtonEnabled: true,
              initialCameraPosition: model.initialCameraPosition(),
              onMapCreated: (controller) => googleMapController = controller,
              markers: model.getMarkersOnMap.length > 0
                  ? {
                      model.getMarkersOnMap.last,
                    }
                  : model.getMarkersOnMap,
              onTap: model.addMarkerToMap,
            ),
          ), */
/*             Row(
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
          ), */
/*             verticalSpaceSmall,
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
          ), */
        ],
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
              height: MediaQuery.of(context).size.height / 2,
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
          ],
        ),
      ),
    );
  }
}
/*
class SingleMarkerView extends StatelessWidget {
  AddMarkersViewModel model;
  GoogleMapController? googleMapController;
  SingleMarkerView(Key? key, this.model, this.googleMapController)
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          verticalSpaceSmall,
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: GoogleMap(
              //enable zoom gestures
              zoomGesturesEnabled: true,

              zoomControlsEnabled: true,

              // Button used for bringing the user location to the center of the camera view.
              myLocationButtonEnabled: true,
              initialCameraPosition: model.initialCameraPosition(),
              onMapCreated: (controller) => googleMapController = controller,
              markers: model.getMarkersOnMap.length > 0
                  ? {
                      model.getMarkersOnMap.last,
                    }
                  : model.getMarkersOnMap,
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
                  onChanged: (int? selectMarkerStatus) => model
                      .checkMarkerStatus(checkMarkerStatus: selectMarkerStatus),
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
                  onChanged: (int? selectMarkerStatus) => model
                      .checkMarkerStatus(checkMarkerStatus: selectMarkerStatus),
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
    );
  }
}

*/