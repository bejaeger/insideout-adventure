import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class ActiveQrCodeSearchView extends StatelessWidget {
  final Quest quest;
  const ActiveQrCodeSearchView({Key? key, required this.quest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveQrCodeSearchViewModel>.reactive(
      viewModelBuilder: () => locator<ActiveQrCodeSearchViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) => model.initialize(quest: quest),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Search for the Hidden Codes!",
            onBackButton: model.navigateBack,
          ),
          floatingActionButton: AFKFloatingActionButtons(
            // title1: "SCAN",
            onPressed1: model.scanQrCode,
            iconData1: Icons.qr_code_scanner_rounded,
            // title2: "LIST",
            // onPressed2: model.navigateBack,
            // iconData2: Icons.list_rounded,
          ),
          body: model.isBusy
              ? AFKProgressIndicator()
              : Align(
                  alignment: Alignment.center,
                  child: model.activeQuestNullable?.status ==
                          QuestStatus.success
                      ? Text(
                          "Successfully finished quest! Finish above when you have data",
                          style: textTheme(context)
                              .headline6!
                              .copyWith(color: kPrimaryColor))
                      : ListView(
                          children: [
                            Container(
                              height: 200,
                              child: Stack(
                                children: [
                                  if (model.isSuperUser)
                                    Container(
                                      color: Colors.grey[300],
                                      child:
                                          ListView(shrinkWrap: true, children: [
                                        verticalSpaceLarge,
                                        SectionHeader(title: "Markers"),
                                        ...quest.markers
                                            .map(
                                              (e) => TextButton(
                                                onPressed: () =>
                                                    model.displayMarker(e),
                                                child: Text(e.id),
                                              ),
                                            )
                                            .toList(),
                                      ]),
                                    ),
                                  if (quest.type == QuestType.QRCodeSearch)
                                    GoogleMap(
                                      //mapType: MapType.hybrid,
                                      initialCameraPosition:
                                          model.initialCameraPosition(),
                                      //Place Markers in the Map
                                      markers: model.markersOnMap,
                                      //callback that’s called when the map is ready to us.
                                      onMapCreated: model.onMapCreated,
                                      //For showing your current location on Map with a blue dot.
                                      myLocationEnabled: true,
                                      // Button used for bringing the user location to the center of the camera view.
                                      myLocationButtonEnabled: false,
                                      //Remove the Zoom in and out button
                                      zoomControlsEnabled: false,
                                      //onTap: model.handleTap(),
                                      //Enable Traffic Mode.
                                      //trafficEnabled: true,
                                    ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "Goal: Find the Hidden Codes!",
                                          style: textTheme(context)
                                              .headline6!
                                              .copyWith(color: kPrimaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            !model.hasActiveQuest
                                ? ElevatedButton(
                                    onPressed: () =>
                                        model.maybeStartQuest(quest: quest),
                                    child: Text(
                                      "START QUEST",
                                      style: textTheme(context)
                                          .headline6!
                                          .copyWith(color: kWhiteTextColor),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: model.scanQrCode,
                                    child: Text(
                                      "SCAN CODE",
                                      style: textTheme(context)
                                          .headline6!
                                          .copyWith(color: kWhiteTextColor),
                                    ),
                                  ),
                            verticalSpaceMedium,
                            // if (model.hasActiveQuest)
                            Text("Number of Codes Found",
                                textAlign: TextAlign.center),
                            Text(
                                model.hasActiveQuest
                                    ? model.foundObjects.length.toString() +
                                        " / " +
                                        model.activeQuest.quest.markers.length
                                            .toString()
                                    : "0 / " + quest.markers.length.toString(),
                                textAlign: TextAlign.center,
                                style: textTheme(context).headline2),
                          ],
                        ),
                ),
        ),
      ),
    );
  }
}
