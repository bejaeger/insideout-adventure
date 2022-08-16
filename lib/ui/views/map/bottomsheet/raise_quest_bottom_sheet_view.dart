import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
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
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      getShortQuestType(model.quest.type),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kcPrimaryColor),
                      // textAlign: TextAlign.left,
                    ),
                  ),
                  horizontalSpaceSmall,
                  CreditsAmount(amount: model.quest.afkCredits),
                ],
              ),
              verticalSpaceSmall,
              if (model.quest.type != QuestType.TreasureLocationSearch &&
                  model.quest.type != QuestType.QRCodeHunt &&
                  model.quest.type != QuestType.GPSAreaHike &&
                  model.quest.type != QuestType.GPSAreaHunt &&
                  model.quest.startMarker != null)
                Expanded(
                  flex: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0)),
                    clipBehavior: Clip.antiAlias,
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
                ),
              verticalSpaceSmall,
              AfkCreditsText.headingTwo(
                request.title.toString(),
              ),
              // verticalSpaceTiny,
              // Text(
              //   getStringForCategory(model.quest.type),
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //       color: kPrimaryColor),
              //   // textAlign: TextAlign.left,
              // ),
              verticalSpaceMedium,
              Text(
                request.description.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800]),
                // textAlign: TextAlign.left,
              ),
              verticalSpaceMedium,
              // Text(
              //   "AFK Credits: " + model.quest.afkCredits.toString(),
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //       color: kPrimaryColor),
              //   // textAlign: TextAlign.left,
              // ),
              if (model.checkSponsoringSentence() != null)
                Text(
                  model.checkSponsoringSentence()!,
                  style: TextStyle(color: Colors.red),
                  // textAlign: TextAlign.left,
                ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ElevatedButton(
                  //   onPressed: () => completer(SheetResponse(confirmed: false)),
                  //   child: Text(
                  //     request.secondaryButtonTitle.toString(),
                  //     style: TextStyle(
                  //         fontSize: 20,
                  //         //fontWeight: FontWeight.bold,
                  //         color: kWhiteTextColor),
                  //   ),
                  // ),
                  MaterialButton(
                    onPressed: () => completer(SheetResponse(confirmed: false)),
                    child: Text(
                      request.secondaryButtonTitle.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: model.hasEnoughSponsoring(quest: model.quest)
                        ? () => completer(SheetResponse(confirmed: true))
                        : null,
                    child: Text(
                      request.mainButtonTitle.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: kcWhiteTextColor),
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
