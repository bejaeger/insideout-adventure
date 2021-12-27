import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class ActiveMapQuestView extends StatelessWidget {
  final Quest quest;
  const ActiveMapQuestView({Key? key, required this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveMapQuestViewModel>.reactive(
      viewModelBuilder: () => ActiveMapQuestViewModel(),
      onModelReady: (model) {
        // TODO: change to initialize
        model.addMarkers(quest: quest);
        return;
      },
      disposeViewModel: false,
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Hike Quest',
            onBackButton: () => model.navigateBack(),
          ),
          body: model.questSuccessfullyFinished
              ? EmptyNote(
                  onMoreButtonPressed: () =>
                      model.replaceWithMainView(index: BottomNavBarIndex.quest),
                )
              : Stack(
                  children: [
                    Container(
                      height: screenHeight(context, percentage: 0.6) -
                          kAppBarExtendedHeight,
                      child: GoogleMap(
                        //mapType: MapType.hybrid,
                        initialCameraPosition: model.initialCameraPosition(),
                        //Place Markers in the Map
                        markers: model.markersOnMap,
                        //callback that’s called when the map is ready to us.
                        onMapCreated: model.onMapCreated,
                        //For showing your current location on Map with a blue dot.
                        myLocationEnabled: true,

                        // Button used for bringing the user location to the center of the camera view.
                        myLocationButtonEnabled: true,

                        //Remove the Zoom in and out button
                        zoomControlsEnabled: false,

                        //onTap: model.handleTap(),
                        //Enable Traffic Mode.
                        //trafficEnabled: true,
                      ),
                    ),
                    if (model.showStartSwipe)
                      AFKSlideButton(
                          alignment: Alignment(0, -0.92),
                          quest: quest,
                          canStartQuest:
                              model.hasEnoughSponsoring(quest: quest),
                          onSubmit: () => model.maybeStartQuest(quest: quest)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: screenHeight(context, percentage: 0.35),
                        child: QuestInfoCard(
                          quest: quest,
                          onCardPressed: () => null,
                          height: screenHeight(context, percentage: 0.1),
                          width: screenWidth(context, percentage: 0.65),
                        ),
                      ),
                    ),
                    if (model.isBusy)
                      Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                  ],
                ),
          floatingActionButton: !model.questSuccessfullyFinished
              ? AFKFloatingActionButtons(
                  // onPressed2: !model.hasActiveQuest
                  //     ? () => model.startQuestMain(quest: quest)
                  //     : null,
                  // title2: "START",
                  // iconData2: Icons.star,
                  onPressed1: () async {
                    model.getGoogleMapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                            model.initialCameraPosition()));
                    await model.scanQrCode();
                  },
                  iconData1: Icons.qr_code_scanner_rounded,
                )
              : null,
        ),
      ),
    );
  }
}
