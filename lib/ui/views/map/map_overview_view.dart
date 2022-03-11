import 'dart:io';

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'map_overview_viewmodel.dart';

class MapOverviewView extends StatefulWidget {
  const MapOverviewView({Key? key}) : super(key: key);

  @override
  State<MapOverviewView> createState() => _MapOverviewViewState();
}

class _MapOverviewViewState extends State<MapOverviewView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    return ViewModelBuilder<MapOverviewViewModel>.reactive(
        //disposeViewModel: false,
        onModelReady: (model) => model.initializeMapAndMarkers(
            devicePixelRatio: devicePixelRatio,
            mapWidth: screenWidth(context),
            mapHeight: screenHeight(context) -
                kBottomNavigationBarHeightCustom -
                kAppBarExtendedHeight),
        viewModelBuilder: () => MapOverviewViewModel(),
        builder: (context, model, child) {
          return GoogleMapsScreen(model: model);
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class GoogleMapsScreen extends StatelessWidget {
  final MapOverviewViewModel model;
  const GoogleMapsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
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

          tiltGesturesEnabled: true,

          // Button used for bringing the user location to the center of the camera view.
          myLocationButtonEnabled: true,

          mapToolbarEnabled: false,
          //onTap: model.handleTap(),
          //Enable Traffic Mode.
          //trafficEnabled: true,
        ),
        // IgnorePointer(
        //   child: Container(
        //     color: Colors.green.withOpacity(0.1),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: IgnorePointer(
        //       child: Container(
        //     height: 135,
        //     child: Stack(
        //       children: [
        //         Container(
        //           height: 100,
        //           width: screenWidth(context),
        //           color: Colors.blue,
        //           child: Image.network(
        //             "https://prooptimania.s3.us-east-2.amazonaws.com/ckfinder/images/luz-azul-cielo-azul.jpg",
        //             fit: BoxFit.cover,
        //             alignment: Alignment.bottomCenter,
        //           ),
        //         ),
        //         Container(
        //           height: 100,
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               colors: [
        //                 Colors.white.withOpacity(0.3),
        //                 Colors.white.withOpacity(0.1)
        //               ],
        //               // begin: Alignment.bottomCenter,
        //               // end: Alignment.topCenter,
        //             ),
        //           ),
        //         ),
        //         Align(
        //           alignment: Alignment.bottomCenter,
        //           child: Container(
        //             height: 70,
        //             decoration: BoxDecoration(
        //               gradient: LinearGradient(
        //                 colors: [
        //                   Colors.white.withOpacity(0.0),
        //                   Colors.white.withOpacity(0.9),
        //                   Colors.white.withOpacity(0.9),
        //                   Colors.white.withOpacity(0.0),
        //                 ],
        //                 stops: [
        //                   0.0,
        //                   0.45,
        //                   0.55,
        //                   1.0,
        //                 ],
        //                 begin: Alignment.bottomCenter,
        //                 end: Alignment.topCenter,
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),),
        // ),
      ],
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
                          style:
                              TextStyle(fontSize: 20.0, color: kDarkTurquoise),
                        ),
                      ),
                    ],
                  ),
                ),
                ...getListOfQuestCards(quests)
              ],
            ),
          )
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
