import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'raise_quest_bottom_sheet_viewmodel.dart';

class RaiseQuestBottomSheetView extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const RaiseQuestBottomSheetView({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RaiseQuestBottomSheetViewModel>.reactive(
      viewModelBuilder: () => RaiseQuestBottomSheetViewModel(),
      onModelReady: (model) => model.initilizeStartedQuest(),
      builder: (context, model, child) => Container(
        color: Colors.grey[100],
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: GoogleMap(
                //mapType: MapType.hybrid,
                initialCameraPosition: model.initialCameraPosition(),
                //Place Markers in the Map
                markers: model.getMarkers!,
                //callback that’s called when the map is ready to us.
                onMapCreated: model.onMapCreated,
                //For showing your current location on Map with a blue dot.
                myLocationEnabled: false,

                // Button used for bringing the user location to the center of the camera view.
                myLocationButtonEnabled: true,

                //Remove the Zoom in and out button
                zoomControlsEnabled: false,
              ),
            ),
            //SizedBox(height: 10),
            Text(
              request!.title.toString(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              request!.description.toString(),
              style: TextStyle(
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                  color: Colors.black),
              // textAlign: TextAlign.left,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () => completer!(SheetResponse(confirmed: false)),
                  child: Text(
                    request!.secondaryButtonTitle.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                MaterialButton(
                  onPressed: () => completer!(SheetResponse(confirmed: true)),
                  child: Text(
                    request!.mainButtonTitle.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
