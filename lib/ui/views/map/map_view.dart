import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/quest/active_quest_view.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'map_viewmodel.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      //  onModelReady: (model) => model.createMarkers(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => model.hasActiveQuest
          ? ActiveQuestView()
          : Scaffold(
              appBar: CustomAppBar(
                title: 'AFK TREASURE HUNTS',
              ),
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
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyFloatingActionButton(
                    onPressed: model.toggleIndex,
                    icon: Icon(
                        model.currentIndex == 0
                            ? Icons.list_rounded
                            : Icons.map_rounded,
                        size: 30,
                        color: Colors.white),
                  ),
                  verticalSpaceSmall,
                  MyFloatingActionButton(
                      onPressed: model.initialCameraPosition() == null
                          ? () async => null
                          : () async {
                              model.getGoogleMapController!.animateCamera(
                                  model.getDirectionInfo != null
                                      ? CameraUpdate.newLatLngBounds(
                                          model.getDirectionInfo!.bounds, 100.0)
                                      : CameraUpdate.newCameraPosition(
                                          model.initialCameraPosition()!));
                              await model.scanQrCodeWithActiveQuest();
                            },
                      icon: const Icon(Icons.qr_code_scanner_rounded,
                          size: 30, color: Colors.white)),
                  verticalSpaceSmall,
                ],
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
              markers: model.getMarkers!,
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

              polylines: {
                if (model.getDirectionInfo != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: model.getDirectionInfo!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },

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

  List<QuestCard> getListOfQuestCards(List<Quest> quests) {
    List<QuestCard> questCards = [];
    quests.forEach((quest) {
      QuestCard questCard = QuestCard(
          height: 140,
          quest: quest,
          subtitle: quest.description,
          onCardPressed: () async => await onCardTapped(quest));
      questCards.add(questCard);
    });
    return questCards;
  }
}

class QuestCard extends StatelessWidget {
  final double height;
  final Quest quest;
  final String? sponsoringSentence;
  final String? subtitle;

  final void Function() onCardPressed;
  const QuestCard(
      {Key? key,
      required this.height,
      required this.quest,
      this.subtitle,
      required this.onCardPressed,
      this.sponsoringSentence})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: kHorizontalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quest.name, style: textTheme(context).headline4),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: textTheme(context)
                            .bodyText2!
                            .copyWith(fontSize: 18)),
                  Text("Credits to earns: " + quest.afkCredits.toString()),
                  Text("Type: " + describeEnum(quest.type).toString()),
                  if (sponsoringSentence != null) Text(sponsoringSentence!),
                ],
              )),
        ),
      ),
    );
  }
}
