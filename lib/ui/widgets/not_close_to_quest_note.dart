import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/app/app.logger.dart';

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
        // decoration: BoxDecoration(
        //   color: kcCultured,
        //   borderRadius: BorderRadius.circular(16.0),
        // ),
        //padding: const EdgeInsets.all(8.0),
        //color: kcCultured,
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: kcCultured,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: AfkCreditsText.warn(
                  "You are ${(model.distanceFromQuest * 0.001).toStringAsFixed(1)} km away from the quest. " +
                      _getInfoString(questType),
                  align: TextAlign.left,
                ),
              ),
            ),
            horizontalSpaceMedium,
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (animateCameraToUserPosition != null &&
                    animateCameraToQuestMarkers != null)
                  Flexible(
                    child: ElevatedButton(
                      onPressed: model.launchMapsForNavigation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.open_in_new),
                          horizontalSpaceTiny,
                          Text("Navigate"),
                        ],
                      ),
                    ),
                  ),
                verticalSpaceTiny,
                Container(
                  width: 160,
                  child: model.questCenteredOnMap
                      ? ElevatedButton(
                          onPressed: () {
                            animateCameraToUserPosition!();
                            model.activeQuestService.questCenteredOnMap = false;
                            model.notifyListeners();
                            return;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.my_location),
                              horizontalSpaceTiny,
                              Text("Your location"),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            animateCameraToQuestMarkers!();
                            model.activeQuestService.questCenteredOnMap = true;
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
                              Icon(Icons.radar),
                              horizontalSpaceTiny,
                              Text("Quest location"),
                            ],
                          ),
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

class NotCloseToQuestNoteViewModel extends ActiveQuestBaseViewModel {
  final MapStateService _mapsService = locator<MapStateService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("NotCloseToQuestNoteViewModel");

  double get distanceFromQuest => _geolocationService.distanceToStartMarker;

  void launchMapsForNavigation() async {
    final res = await dialogService.showDialog(
        title: "Open other app?",
        description: "Use external app for navigation",
        cancelTitle: "NO",
        buttonTitle: "YES");
    if (res?.confirmed == false) {
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
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future maybeStartQuest(
      {required Quest? quest, void Function()? onStartQuestCallback}) {
    // TODO: implement maybeStartQuest
    throw UnimplementedError();
  }
}
