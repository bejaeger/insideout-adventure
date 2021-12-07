import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'raise_quest_bottom_sheet_viewmodel.dart';

class RaiseQuestBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const RaiseQuestBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RaiseQuestBottomSheetViewModel>.reactive(
      viewModelBuilder: () =>
          RaiseQuestBottomSheetViewModel(quest: request.data),
      builder: (context, model, child) => Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 40,
                  child: Divider(
                    thickness: 4,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              verticalSpaceTiny,
              if (model.quest.type != QuestType.VibrationSearch &&
                  model.quest.type != QuestType.Search)
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
              verticalSpaceSmall,
              Text(
                request.title.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              verticalSpaceSmall,
              Text(
                request.description.toString(),
                style: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black),
                // textAlign: TextAlign.left,
              ),
              verticalSpaceSmall,
              Text(
                "Category: " + describeEnum(model.quest.type).toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
                // textAlign: TextAlign.left,
              ),
              verticalSpaceSmall,
              Text(
                "AFK Credits: " + model.quest.afkCredits.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
                // textAlign: TextAlign.left,
              ),
              verticalSpaceSmall,
              if (model.checkSponsoringSentence() != null)
                Text(
                  model.checkSponsoringSentence()!,
                  style: TextStyle(color: Colors.red),
                  // textAlign: TextAlign.left,
                ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => completer(SheetResponse(confirmed: false)),
                    child: Text(
                      request.secondaryButtonTitle.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: kWhiteTextColor),
                    ),
                  ),

                  // MaterialButton(
                  //   onPressed: () => completer(SheetResponse(confirmed: false)),
                  //   child: Text(
                  //     request.secondaryButtonTitle.toString(),
                  //     style: TextStyle(
                  //         fontSize: 20,
                  //         //fontWeight: FontWeight.bold,
                  //         color: Colors.black),
                  //   ),
                  // ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: model.hasEnoughSponsoring()
                        ? () => completer(SheetResponse(confirmed: true))
                        : null,
                    child: Text(
                      request.mainButtonTitle.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: kWhiteTextColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
