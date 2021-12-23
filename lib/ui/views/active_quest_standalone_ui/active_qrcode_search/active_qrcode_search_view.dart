import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/not_enough_sponsoring_note.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:stacked/stacked.dart';
import 'package:shimmer/shimmer.dart';

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
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: "Search for the Hidden Codes!",
                onBackButton: model.navigateBack,
              ),
              floatingActionButton: AFKFloatingActionButtons(
                // title1: "SCAN",
                // onPressed2: model.hasActiveQuest
                //     ? null
                //     : () => model.maybeStartQuest(quest: quest),
                // title2: "START",
                //iconData2: Icons.star,
                onPressed1: model.scanQrCode,
                iconData1: Icons.qr_code_scanner_rounded,
                yOffset: 0,
                // title2: "LIST",
                // onPressed2: model.navigateBack,
                // iconData2: Icons.list_rounded,
              ),
              body: model.isBusy
                  ? AFKProgressIndicator()
                  : model.questSuccessfullyFinished
                      ? EmptyNote(
                          onMoreButtonPressed: () => model.replaceWithMainView(
                              index: BottomNavBarIndex.quest),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              verticalSpaceMedium,
                              if (model.showStartSwipe)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kHorizontalPadding),
                                  child: SlideAction(
                                    outerColor: kPrimaryColor,

                                    //text: "Start",
                                    child:
                                        model.hasEnoughSponsoring(quest: quest)
                                            ? Shimmer.fromColors(
                                                baseColor: kGreyTextColor,
                                                highlightColor: Colors.white,
                                                period: const Duration(
                                                    milliseconds: 1000),
                                                child: Text("Slide to start",
                                                    style: textTheme(context)
                                                        .headline6!
                                                        .copyWith(
                                                            fontSize: 22,
                                                            color:
                                                                kWhiteTextColor)),
                                              )
                                            : Text(
                                                "Cannot start",
                                                style: textTheme(context)
                                                    .headline6!
                                                    .copyWith(
                                                        fontSize: 22,
                                                        color: kWhiteTextColor),
                                              ),
                                    height: 50,
                                    elevation: 10,
                                    sliderRotate: false,
                                    //key: _key,
                                    // onSubmit: () =>
                                    //     model.maybeStartQuest(quest: quest),
                                    onSubmit: null,

                                    borderRadius: 50,
                                    // animationDuration: Duration(seconds: 1),
                                  ),
                                ),
                              if (!model.hasEnoughSponsoring(quest: quest))
                                NotEnoughSponsoringNote(topPadding: 10),
                              if (!model.showStartSwipe && model.hasActiveQuest)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Time"),
                                          Text(model.timeElapsed.toString(),
                                              maxLines: 1,
                                              style:
                                                  textTheme(context).headline4),
                                        ],
                                      ),
                                      verticalSpaceMedium,
                                      Column(
                                        children: [
                                          Text("Number of Codes Found",
                                              textAlign: TextAlign.center),
                                          Text(
                                              model.hasActiveQuest
                                                  ? model.foundObjects.length
                                                          .toString() +
                                                      " / " +
                                                      model.activeQuest.quest
                                                          .markers.length
                                                          .toString()
                                                  : "0 / " +
                                                      quest.markers.length
                                                          .toString(),
                                              textAlign: TextAlign.center,
                                              style:
                                                  textTheme(context).headline3),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              Expanded(
                                  child: NextHintDisplay(
                                      model: model, quest: quest)),
                              // SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Find & Scan Codes",
                                      style: textTheme(context).headline6),
                                  Icon(Icons.arrow_forward, size: 50),
                                  SizedBox(width: 100),
                                ],
                              ),
                              SizedBox(height: 28),
                            ],
                          ),
                        ),
            ),
          );
        });
  }
}

class NextHintDisplay extends StatelessWidget {
  final dynamic model;
  final Quest quest;
  const NextHintDisplay({Key? key, required this.model, required this.quest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quest.type != QuestType.QRCodeSearch
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.grey[200],
              boxShadow: [
                  BoxShadow(blurRadius: 4, spreadRadius: 2, color: kShadowColor)
                ])
          : null,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: !model.isSuperUser || quest.type == QuestType.QRCodeSearch
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (quest.type != QuestType.QRCodeSearch)
                  SectionHeader(title: "Next Hint"),
                if (quest.type == QuestType.QRCodeSearch)
                  Expanded(
                    child: Container(
//                       margin: const EdgeInsets.all(20),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 2,
                                color: kShadowColor)
                          ]),
                      child: Stack(
                        children: [
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
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(16.0)),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Find codes in the displayed area",
                                          textAlign: TextAlign.center,
                                          style: textTheme(context).headline6),
                                    ]),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: kPrimaryColor),
                                      color: kPrimaryColor.withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(180.0)),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : Column(
              children: [
                verticalSpaceLarge,
                SectionHeader(title: "Markers"),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ...quest.markers
                        .map(
                          (e) => TextButton(
                            onPressed: () => model.displayMarker(e),
                            child: Text(e.id),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ],
            ),
    );
  }
}
