// ignore_for_file: must_be_immutable, unnecessary_statements

import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../../../data/app_strings.dart';
import '../../add_explorer/validators.dart';
import 'create_quest.form.dart';
import 'create_quest_viewmodel.dart';

final circularBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
);

@FormView(
  fields: [
    FormTextField(
      name: 'name',
      initialValue: "Quest Name",
      validator: FormValidators.nameValidator,
    ),
    FormTextField(name: 'description'),
    FormTextField(name: 'afkCreditAmount'),
    FormDropdownField(
      name: 'questType',
      items: [
        StaticDropdownItem(
          title: 'QuestType',
          value: 'QuestTypeDr',
        ),
      ],
    )
    //FormTextField(name: 'markerNotes'),
  ],
)
// ignore: must_be_immutable
class CreateQuestView extends StatelessWidget with $CreateQuestView {
  final bool fromMap;
  CreateQuestView({Key? key, this.fromMap = false}) : super(key: key);

  // TODO: need to dispose this so need to have stateful function here!
  // TODO: This does not work with formView
  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateQuestViewModel>.reactive(
      onModelReady: (model) {
        if (model.getCurrentPostion == null) model.setPosition();
        listenToFormUpdated(model);
      },
      viewModelBuilder: () => CreateQuestViewModel(fromMap: fromMap),
      // onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            //resizeToAvoidBottomInset: true,
            // resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: "Create Quest",
              onBackButton: () => model.onBackButton(controller),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: model.isBusy
                ? null
                : BottomFloatingActionButtons(
                    swapButtons: true,
                    onTapSecondary: model.pageIndex == 2
                        ? model.getAFKMarkers.length < 2
                            ? null
                            : () async {
                                if (model.pageIndex == 0) {
                                  FocusScope.of(context).unfocus();
                                }
                                await model.onNextButton(controller);
                              }
                        : () async {
                            if (model.pageIndex == 0) {
                              FocusScope.of(context).unfocus();
                            }
                            await model.onNextButton(controller);
                          },
                    titleSecondary:
                        model.pageIndex < 3 ? "Next \u2192" : "Create Quest",
                    busySecondary: model.creatingQuest,
                    onTapMain: model.pageIndex == 3
                        ? () {
                            FocusScope.of(context).unfocus();
                            model.onBackButton(controller);
                          }
                        : () => model.onBackButton(controller),
                    // model.pageIndex == 1
                    //     ? () {
                    //         model.pageIndex = model.pageIndex - 1;
                    //         controller.previousPage(
                    //             duration: Duration(milliseconds: 200),
                    //             curve: Curves.easeIn);
                    //         model.notifyListeners();
                    //       }
                    //     : () {
                    //         {
                    //           model.resetMarkersValues();
                    //           model.navBackToPreviousView();
                    //         }
                    //       },
                    titleMain: model.pageIndex >= 1 ? "\u2190 Back" : "Cancel",
                  ),
            body: PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                NameSelection(
                  model: model,
                  nameController: nameController,
                  descriptionController: descriptionController,
                ),
                QuestTypeSelection(
                  model: model,
                ),
                QuestMarkersSelection(
                  model: model,
                ),
                CreditsSelection(
                  model: model,
                  afkCreditAmountController: afkCreditAmountController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NameSelection extends StatelessWidget with $CreateQuestView {
  final CreateQuestViewModel model;
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  NameSelection({
    required this.model,
    required this.nameController,
    required this.descriptionController,
  });
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        height: screenHeight(context) - 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //keyboardIsOpened ? verticalSpaceMedium : verticalSpaceLarge,
            verticalSpaceMedium,
            AfkCreditsText.subheadingItalic("Choose a name"),
            verticalSpaceMedium,
            AfkCreditsInputField(
                // decoration: InputDecoration(
                //   labelText: 'Quest Name: ',
                // ),
                autofocus: nameController.text == "" ? true : false,
                placeholder: 'Quest name',
                controller: nameController,
                errorText: model.nameInputValidationMessage
                //keyboardType: TextInputType.text,
                // focusNode: nameFocusNode,
                ),
            //ErrorTextBox(message: model.nameInputValidationMessage),
            verticalSpaceMedium,
            AfkCreditsInputField(
              placeholder: 'Quest description (optional)',
              controller: descriptionController,
            ),
            verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}

class QuestTypeSelection extends StatelessWidget with $CreateQuestView {
  final CreateQuestViewModel model;
  QuestType? questTypeValue;

  QuestTypeSelection({
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        height: screenHeight(context) - 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceMedium,
            AfkCreditsText.subheadingItalic("Choose a quest type"),
            verticalSpaceMedium,
            // keyboardIsOpened ? verticalSpaceMedium : verticalSpaceLarge,
            Container(
              height: 160,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: model.selectedQuestType ==
                              QuestType.TreasureLocationSearch
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 5, color: kcPrimaryColor),
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : null,
                      child: QuestTypeCard(
                        category: QuestType.TreasureLocationSearch,
                        onPressed: () => model.selectQuestType(
                            type: QuestType.TreasureLocationSearch),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: model.selectedQuestType ==
                              QuestType.GPSAreaHike
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 5, color: kcPrimaryColor),
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          : null,
                      child: QuestTypeCard(
                        category: QuestType.GPSAreaHike,
                        onPressed: () =>
                            model.selectQuestType(type: QuestType.GPSAreaHike),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AfkCreditsText.subheading(
                    getShortQuestType(model.selectedQuestType),
                  ),
                  verticalSpaceSmall,
                  AfkCreditsText.body(model.getQuestTypeExplanation()),
                ],
              ),
            )

            // AfkCreditsDropdownFormField<QuestType>(
            //   items: CreateQuestType.values.map(
            //     (_questType) {
            //       return DropdownMenuItem(
            //         value: _questType == CreateQuestType.TreasureLocationSearch
            //             ? QuestType.TreasureLocationSearch
            //             : _questType == CreateQuestType.GPSAreaHike
            //                 ? QuestType.GPSAreaHike
            //                 : QuestType.GPSAreaHunt,
            //         child: model.isLoading == false
            //             ? Text(
            //                 getShortQuestType(
            //                   _questType ==
            //                           CreateQuestType.TreasureLocationSearch
            //                       ? QuestType.TreasureLocationSearch
            //                       : _questType == CreateQuestType.GPSAreaHike
            //                           ? QuestType.GPSAreaHike
            //                           : QuestType.GPSAreaHunt,
            //                 ),
            //               )
            //             : Text(
            //                 "Select Quest Type",
            //               ),
            //       );
            //     },
            //   ).toList(),
            //   onChanged: (QuestType? questType) {
            //     questTypeValue = questType;
            //     model.setQuestType(selectedQuestType: questType!);
            //   },
            //   placeholder: 'Select quest type',
            //   value: questTypeValue,
            //   errorText: model.questTypeInputValidationMessage,
            // ),
          ],
        ),
      ),
    );
  }
}

class QuestMarkersSelection extends StatelessWidget with $CreateQuestView {
  final CreateQuestViewModel model;

  QuestMarkersSelection({
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      child: Stack(
        children: [
          GoogleMap(
            // zoomControlsEnabled: true,
            //mapType: MapType.hybrid,
            initialCameraPosition: model.initialCameraPosition(),
            //Place Markers in the Map
            markers: model.getMarkersOnMap,
            //callback that’s called when the map is ready to us.
            onMapCreated: model.onMapCreated,
            onTap: model.displayMarkersOnMap,
            // scrollGesturesEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            // gestureRecognizers: Set()
          ),
          if (!model.isBusy)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    width: screenWidth(context, percentage: 0.95),
                    decoration: BoxDecoration(
                      color: kcCultured,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: kcShadowColor,
                            blurRadius: 0.3,
                            spreadRadius: 0.5)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AfkCreditsText.label(
                            (model.getAFKMarkers.length + 1)
                                    .clamp(0, 3)
                                    .toString() +
                                ")",
                            align: TextAlign.left),
                        verticalSpaceTiny,
                        AfkCreditsText.subheadingItalic(
                          model.getAFKMarkers.length == 0
                              ? "Tap on the map to choose the start of the quest"
                              : model.getAFKMarkers.length == 1
                                  ? model.selectedQuestType ==
                                          QuestType.TreasureLocationSearch
                                      ? "Choose the target marker of the search quest"
                                      : "Choose at least one more marker"
                                  : model.selectedQuestType ==
                                          QuestType.TreasureLocationSearch
                                      ? "Tap 'Next'"
                                      : "Tap 'Next' when you are done",
                          align: TextAlign.left,
                        ),
                        if (model.getAFKMarkers.length >= 1) verticalSpaceSmall,
                        if (model.getAFKMarkers.length >= 1)
                          AfkCreditsText.body(
                              "Tip: You can remove markers by tapping on them"),
                      ],
                    ),
                  ),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: AfkCreditsText.alertThree(
                        "Total distance: ${model.getTotalDistanceOfMarkers().toStringAsFixed(0)} m"),
                  ),
                ),
              ],
            ),
          if (model.creatingQuest)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: AFKProgressIndicator(
                alignment: Alignment.bottomCenter,
              ),
            ),
          if (model.isBusy) AbsorbPointer(child: Container())
        ],
      ),
    );
  }
}

class CreditsSelection extends StatelessWidget with $CreateQuestView {
  final CreateQuestViewModel model;
  final TextEditingController afkCreditAmountController;
  QuestType? questTypeValue;

  CreditsSelection({
    required this.model,
    required this.afkCreditAmountController,
  });
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        height: screenHeight(context) - 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceMedium,
            AfkCreditsText.subheadingItalic(
                "Choose number of credits that can be earned"),
            Row(
              children: [
                AfkCreditsText.body(
                    "We recommend giving ${model.getRecommendedCredits()} credits"),
                horizontalSpaceTiny,
                IconButton(
                    padding: const EdgeInsets.all(0.0),
                    alignment: Alignment.centerLeft,
                    color: kcPrimaryColor,
                    onPressed: model.showCreditsSuggestionDialog,
                    icon: Icon(Icons.info_outline)),
              ],
            ),
            verticalSpaceMedium,
            model.creatingQuest
                ? SizedBox(height: 0, width: 0)
                : Row(
                    children: [
                      Container(
                        width: screenWidth(context, percentage: 0.35),
                        child: AfkCreditsInputField(
                          //focusNode: amountFocusNode,
                          controller: afkCreditAmountController,
                          style: heading3Style,
                          leading: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(kAFKCreditsLogoPath, height: 10),
                          ),
                          autofocus: true,
                          //placeholder: 'Amount',
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          //errorText: model.afkCreditsInputValidationMessage,
                        ),
                      ),
                      //Container(color: Colors.red),
                      horizontalSpaceSmall,
                      Icon(Icons.arrow_right_alt, size: 26),
                      horizontalSpaceSmall,
                      Expanded(
                        child: SummaryStatsDisplay(
                          title: "Equiv. screen time",
                          icon: Image.asset(kScreenTimeIcon,
                              height: 26, color: kcScreenTimeBlue),
                          unit: "min",
                          stats: model.screenTimeEquivalent == null
                              ? "0"
                              : model.screenTimeEquivalent!.toStringAsFixed(0),
                        ),
                      ),
                    ],
                  ),
            if (model.afkCreditsInputValidationMessage != null)
              Expanded(
                  child: AfkCreditsText.warn(
                      model.afkCreditsInputValidationMessage!)),
            verticalSpaceMassive,
          ],
        ),
      ),
    );
  }
}

// ! DEPRECATED

/* Widget showErrorTextBox(String? message) {
  if (message != null) {
    return Text(message, style: TextStyle(color: Colors.red));
  } else {
    return SizedBox(height: 0, width: 0);
  }
}
 */

// class QuestCardList extends StatelessWidget with $CreateQuestView {
//   final CreateQuestViewModel model;
//   final TextEditingController nameController;
//   final TextEditingController descriptionController;
//   final TextEditingController afkCreditAmountController;
//   QuestType? questTypeValue;

//   QuestCardList({
//     required this.model,
//     required this.nameController,
//     required this.descriptionController,
//     required this.afkCreditAmountController,
//   });
//   @override
//   Widget build(BuildContext context) {
//     bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

//     return SingleChildScrollView(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
//         height: screenHeight(context) - 120,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             keyboardIsOpened ? verticalSpaceMedium : verticalSpaceLarge,
//             AfkCreditsInputField(
//                 // decoration: InputDecoration(
//                 //   labelText: 'Quest Name: ',
//                 // ),
//                 placeholder: 'Quest name',
//                 controller: nameController,
//                 errorText: model.nameInputValidationMessage
//                 //keyboardType: TextInputType.text,
//                 // focusNode: nameFocusNode,
//                 ),
//             //ErrorTextBox(message: model.nameInputValidationMessage),
//             verticalSpaceSmall,
//             AfkCreditsInputField(
//               placeholder: 'Quest description (optional)',
//               controller: descriptionController,
//             ),
//             verticalSpaceLarge,
//             AfkCreditsDropdownFormField<QuestType>(
//               items: CreateQuestType.values.map(
//                 (_questType) {
//                   return DropdownMenuItem(
//                     value: _questType == CreateQuestType.TreasureLocationSearch
//                         ? QuestType.TreasureLocationSearch
//                         : _questType == CreateQuestType.GPSAreaHike
//                             ? QuestType.GPSAreaHike
//                             : QuestType.GPSAreaHunt,
//                     child: model.isLoading == false
//                         ? Text(
//                             getShortQuestType(
//                               _questType ==
//                                       CreateQuestType.TreasureLocationSearch
//                                   ? QuestType.TreasureLocationSearch
//                                   : _questType == CreateQuestType.GPSAreaHike
//                                       ? QuestType.GPSAreaHike
//                                       : QuestType.GPSAreaHunt,
//                             ),
//                           )
//                         : Text(
//                             "Select Quest Type",
//                           ),
//                   );
//                 },
//               ).toList(),
//               onChanged: (QuestType? questType) {
//                 questTypeValue = questType;
//                 model.setQuestType(selectedQuestType: questType!);
//               },
//               placeholder: 'Select quest type',
//               value: questTypeValue,
//               errorText: model.questTypeInputValidationMessage,
//             ),
//             verticalSpaceLarge,
//             AfkCreditsInputField(
//               placeholder: 'Credit amount',
//               keyboardType: TextInputType.number,
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//               ],
//               controller: afkCreditAmountController,
//               errorText: model.afkCreditsInputValidationMessage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
