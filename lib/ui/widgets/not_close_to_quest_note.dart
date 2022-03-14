import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/maps/map_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/app/app.logger.dart';

class NotCloseToQuestNote extends StatelessWidget {
  final void Function()? animateCameraToUserPosition;
  final void Function()? animateCameraToQuestMarkers;

  final QuestType? questType;
  const NotCloseToQuestNote(
      {Key? key,
      this.animateCameraToUserPosition,
      this.animateCameraToQuestMarkers,
      this.questType})
      : super(key: key);

  String _getInfoString(QuestType? questType) {
    if (questType == QuestType.GPSAreaHike ||
        questType == QuestType.QRCodeHike) {
      return "Go to the green marker to start the quest.";
    } else {
      return "Go to the start of the quest.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotCloseToQuestNoteViewModel>.reactive(
      viewModelBuilder: () => NotCloseToQuestNoteViewModel(),
      builder: (context, model, child) => Container(
        color: Colors.grey[50],
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: 5),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  // clipBehavior: Clip.antiAlias,
                  //padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16.0)),
                  // width: screenWidth(context, percentage: 0.5),
                  child: Text(
                      "You are ${(model.distanceFromQuest * 0.001).toStringAsFixed(1)} km away from the quest. " +
                          _getInfoString(questType),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: textTheme(context)
                          .bodyText2!
                          .copyWith(color: Colors.red, fontSize: 16)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (animateCameraToUserPosition != null &&
                      animateCameraToQuestMarkers != null)
                    model.questCenteredOnMap
                        ? Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                animateCameraToUserPosition!();
                                model.questCenteredOnMap = false;
                                model.notifyListeners();
                                return;
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Go to you"),
                                  horizontalSpaceTiny,
                                  Icon(Icons.my_location)
                                ],
                              ),
                            ),
                          )
                        : Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                animateCameraToQuestMarkers!();
                                model.questCenteredOnMap = true;
                                model.notifyListeners();
                                return;
                              },
                              // () async {
                              //   await model.animateCameraToQuestMarkers(
                              //       controller!,
                              //       delay: 0);
                              //   model.questCenteredOnMap = true;
                              //   model.notifyListeners();
                              // },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Show quest"),
                                  horizontalSpaceTiny,
                                  Icon(Icons.radar)
                                ],
                              ),
                            ),
                          ),
                  horizontalSpaceMedium,
                  Flexible(
                    child: ElevatedButton(
                      onPressed: model.launchMapsForNavigation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Navigation"),
                          horizontalSpaceTiny,
                          Icon(Icons.open_in_new)
                        ],
                      ),
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

class NotCloseToQuestNoteViewModel extends ActiveQuestBaseViewModel {
  final MapService _mapsService = locator<MapService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("NotCloseToQuestNoteViewModel");

  double get distanceFromQuest => _geolocationService.distanceToStartMarker;

  void launchMapsForNavigation() async {
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
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
