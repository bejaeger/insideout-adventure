import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_view.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../common_viewmodels/map_viewmodel.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      //  onModelReady: (model) => model.createMarkers(),
      onModelReady: (model) {
        //SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
        model.initialize();
        //});
        return;
      },
      builder: (context, model, child) => model.hasActiveQuest
          ? ActiveMapQuestView()
          : Scaffold(
              appBar: AppBar(
                title: Text("Map Games"),
                leading: IconButton(
                  onPressed: model.navigateBack,
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              // appBar: CustomAppBar(
              //   title: 'AFK TREASURE HUNTS',
              // ),
              body: IndexedStack(index: model.currentIndex, children: [
                GoogleMapsScreen(model: model),
                QuestListScreen(
                  quests: model.nearbyQuests,
                  isBusy: model.isBusy,
                  onCardTapped: model.onQuestInListTapped,
                  switchToMap: model.toggleIndex,
                ),
              ]),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: AFKFloatingActionButtons(
                // title1: "SCAN",
                onPressed1: model.scanQrCode,
                iconData1: Icons.qr_code_scanner_rounded,
                title2: "LIST",
                onPressed2: model.navigateBack,
                iconData2: Icons.list_rounded,
              ),
            ),
      viewModelBuilder: () => MapViewModel(),
    );
  }
}

class GoogleMapsScreen extends StatelessWidget {
  final model;
  const GoogleMapsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: model.isBusy
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : GoogleMap(
              onTap: (_) => model.notifyListeners(),
              //mapType: MapType.hybrid,
              initialCameraPosition: model.initialCameraPosition(),

              //Place Markers in the Map
              markers: model.markersOnMap,
              // onCameraMove: ,

              //callback that’s called when the map is ready to use.
              onMapCreated: model.onMapCreated,

              //enable zoom gestures
              zoomGesturesEnabled: true,
              //minMaxZoomPreference: MinMaxZoomPreference(13,17)

              //For showing your current location on Map with a blue dot.
              myLocationEnabled: true,
              //Remove the Zoom in and out button
              zoomControlsEnabled: false,

              // Button used for bringing the user location to the center of the camera view.
              myLocationButtonEnabled: true,

              //onTap: model.handleTap(),
              //Enable Traffic Mode.
              //trafficEnabled: true,
            ),
    );
  }
}

class QuestListScreen extends StatelessWidget {
  final List<Quest> quests;
  final bool? isBusy;
  final Future Function(Quest) onCardTapped;
  final void Function() switchToMap;

  const QuestListScreen(
      {Key? key,
      required this.quests,
      this.isBusy,
      required this.onCardTapped,
      required this.switchToMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isBusy == false
        ? Container(
            child: ListView(
            //itemExtent: 120,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: kHorizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'List of Quests',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: switchToMap,
                      child: Text(
                        'Back to Map',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0, color: kDarkTurquoise),
                      ),
                    ),
                  ],
                ),
              ),
              ...getListOfQuestCards(quests)
            ],
          ))
        : CircularProgressIndicator();
  }

  List<QuestInfoCard> getListOfQuestCards(List<Quest> quests) {
    List<QuestInfoCard> questCards = [];
    quests.forEach((quest) {
      QuestInfoCard questCard = QuestInfoCard(
          height: 140,
          quest: quest,
          subtitle: quest.description,
          onCardPressed: () async => await onCardTapped(quest));
      questCards.add(questCard);
    });
    return questCards;
  }
}
