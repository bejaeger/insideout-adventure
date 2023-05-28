import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

class NotCloseToQuestNote extends StatelessWidget {
  final void Function()? animateCameraToUserPosition;
  final void Function()? animateCameraToQuestMarkers;

  final QuestType? questType;
  final bool? horizontal;

  const NotCloseToQuestNote(
      {Key? key,
      this.animateCameraToUserPosition,
      this.animateCameraToQuestMarkers,
      this.horizontal,
      this.questType})
      : super(key: key);
  // Changed The QuestType parameter to String.
  String _getInfoString(QuestType? questType) {
    if (questType == QuestType.GPSAreaHike ||
        questType == QuestType.QRCodeHike) {
      return "Move to the green marker and start the quest.";
    } else {
      return "Move to the start.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotCloseToQuestNoteViewModel>.reactive(
      viewModelBuilder: () => NotCloseToQuestNoteViewModel(),
      builder: (context, model, child) => Container(
        //height: 120,
        decoration: BoxDecoration(
          color: kcWhiteTextColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey[400]!),
        ),
        padding:
            const EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You are too far away!",
              style: subheadingStyle.copyWith(color: kcRed),
            ),
            verticalSpaceTiny,
            InsideOutText.body(
              "The start is ${(model.distanceFromQuest * 0.001).toStringAsFixed(1)} km away. ",
              align: TextAlign.center,
            ),
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (animateCameraToUserPosition != null &&
                    animateCameraToQuestMarkers != null)
                  Expanded(
                    child: InsideOutButton.outline(
                      height: 45,
                      onTap: model.launchMapsForNavigation,
                      leading: Icon(Icons.open_in_new, color: kcPrimaryColor),
                      title: "Navigate",
                    ),
                  ),
                horizontalSpaceTiny,
                model.questCenteredOnMap
                    ? Expanded(
                        child: InsideOutButton(
                          height: 45,
                          onTap: () {
                            animateCameraToUserPosition!();
                            model.activeQuestService.questCenteredOnMap = false;
                            model.notifyListeners();
                            return;
                          },
                          leading: Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          title: "You",
                        ),
                      )
                    : Expanded(
                        child: InsideOutButton(
                          height: 45,
                          onTap: () {
                            animateCameraToQuestMarkers!();
                            model.activeQuestService.questCenteredOnMap = true;
                            model.notifyListeners();
                            return;
                          },
                          leading: Icon(
                            Icons.radar,
                            color: Colors.white,
                          ),
                          title: "Quest",
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotCloseToQuestNoteViewModel extends BaseModel {
  final MapStateService _mapsService = locator<MapStateService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("NotCloseToQuestNoteViewModel");

  bool get questCenteredOnMap => activeQuestService.questCenteredOnMap;
  double get distanceFromQuest => _geolocationService.distanceToStartMarker;

  void launchMapsForNavigation() async {
    final res = await dialogService.showDialog(
        title: "Open navigation app?",
        barrierDismissible: true,
        description: "Use external app for navigation",
        cancelTitle: "Cancel",
        buttonTitle: "Open app");
    if (res?.confirmed == false || res == null) {
      return;
    }

    AFKMarker? marker = activeQuestService.currentQuest?.startMarker;
    if (marker == null) {
      log.e("Can't open map because no quest or no marker found!");
      snackbarService.showSnackbar(
          title: "Error",
          message: "Can't open map because no quest or no marker found.");
      return;
    }
    if (marker.lat == null || marker.lon == null) {
      log.e(
          "Can't open map because marker does not have coordinates assigned yet!");
      snackbarService.showSnackbar(
          title: "Error",
          message: "Can't open map because no coordinates found.");
      return;
    }
    final result =
        await _mapsService.launchMapsForNavigation(marker.lat!, marker.lon!);
    if (result is String) {
      snackbarService.showSnackbar(
          title: "Error", message: "No maps installed for navigation.");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
