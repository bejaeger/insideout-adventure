import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/maps/maps_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/app/app.logger.dart';

class NotCloseToQuestNote extends StatelessWidget {
  final GoogleMapController? controller;
  const NotCloseToQuestNote({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotCloseToQuestNoteViewModel>.reactive(
      viewModelBuilder: () => NotCloseToQuestNoteViewModel(),
      builder: (context, model, child) => Container(
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
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16.0)),
                  // width: screenWidth(context, percentage: 0.5),
                  child: Text(
                    "You are ${(model.distanceFromQuest * 0.001).toStringAsFixed(1)} km away from the start of the quest. Move to the green area shown below.",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: textTheme(context)
                        .bodyText2!
                        .copyWith(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (controller != null)
                    model.questCenteredOnMap
                        ? Flexible(
                            child: ElevatedButton(
                              onPressed: () =>
                                  model.animateToUserPosition(controller!),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("You are Here"),
                                  horizontalSpaceTiny,
                                  Icon(Icons.my_location)
                                ],
                              ),
                            ),
                          )
                        : Flexible(
                            child: ElevatedButton(
                              onPressed: () async {
                                await model.animateCameraToQuestMarkers(
                                    controller!,
                                    delay: 0);
                                model.questCenteredOnMap = true;
                                model.notifyListeners();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Go to quest"),
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
  final MapsService _mapsService = locator<MapsService>();
  final QuestService _questService = locator<QuestService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("NotCloseToQuestNoteViewModel");

  double get distanceFromQuest => _geolocationService.distanceToStartMarker;

  void launchMapsForNavigation() async {
    AFKMarker? marker = _questService.currentQuest?.startMarker;
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
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    // TODO: implement addMarkerToMap
  }

  @override
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    // TODO: implement defineMarkersColour
    throw UnimplementedError();
  }

  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  @override
  void loadQuestMarkers() {
    // TODO: implement loadQuestMarkers
  }
}
