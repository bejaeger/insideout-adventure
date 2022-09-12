// ignore_for_file: must_be_immutable, unnecessary_statements

import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
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
  CreateQuestView({Key? key}) : super(key: key);

  // TODO: need to dispose this so need to have stateful function here!
  // TODO: This does not work with formView
  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateQuestViewModel>.reactive(
      onModelReady: (model) {
        model.getCurrentPostion ?? model.setPosition();
        //if (model.getCurrentPostion == null) model.setPosition();
        listenToFormUpdated(model);
      },
      viewModelBuilder: () => CreateQuestViewModel(),
      onDispose: (model) => disposeForm(),
      // onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) {
        print("===================================");
        print(model.pageIndex);
        return SafeArea(
          child: Scaffold(
            //resizeToAvoidBottomInset: true,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: "Create Quest",
              onBackButton: () => model.onBackButton(controller),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: BottomFloatingActionButtons(
              swapButtons: true,
              onTapSecondary: () => model.onNextButton(controller),
              titleSecondary:
                  model.pageIndex == 1 ? "Create Quest" : "Next \u2192",
              onTapMain: model.pageIndex == 1
                  ? () {
                      model.pageIndex = model.pageIndex - 1;
                      controller.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                      model.notifyListeners();
                    }
                  : () {
                      {
                        model.resetMarkersValues();
                        model.navBackToPreviousView();
                      }
                    },
              titleMain: model.pageIndex == 1 ? "Back" : "Cancel",
            ),
            body: PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                QuestCardList(
                  model: model,
                  nameController: nameController,
                  descriptionController: descriptionController,
                  afkCreditAmountController: afkCreditAmountController,
                ),
                ChooseMarkersView(
                  model: model,
                  nameController: nameController,
                  descriptionController: descriptionController,
                  afkCreditAmountController: afkCreditAmountController,
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

class QuestCardList extends StatelessWidget with $CreateQuestView {
  final CreateQuestViewModel model;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController afkCreditAmountController;
  QuestType? questTypeValue;

  QuestCardList({
    required this.model,
    required this.nameController,
    required this.descriptionController,
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
            keyboardIsOpened ? verticalSpaceMedium : verticalSpaceLarge,
            AfkCreditsInputField(
                // decoration: InputDecoration(
                //   labelText: 'Quest Name: ',
                // ),
                placeholder: 'Quest name',
                controller: nameController,
                errorText: model.nameInputValidationMessage
                //keyboardType: TextInputType.text,
                // focusNode: nameFocusNode,
                ),
            //ErrorTextBox(message: model.nameInputValidationMessage),
            verticalSpaceSmall,
            AfkCreditsInputField(
              placeholder: 'Quest description (optional)',
              controller: descriptionController,
            ),
            verticalSpaceLarge,
            AfkCreditsDropdownFormField<QuestType>(
              items: CreateQuestType.values.map(
                (_questType) {
                  return DropdownMenuItem(
                    value: _questType == CreateQuestType.TreasureLocationSearch
                        ? QuestType.TreasureLocationSearch
                        : _questType == CreateQuestType.GPSAreaHike
                            ? QuestType.GPSAreaHike
                            : QuestType.GPSAreaHunt,
                    child: model.isLoading == false
                        ? Text(
                            getShortQuestType(
                              _questType ==
                                      CreateQuestType.TreasureLocationSearch
                                  ? QuestType.TreasureLocationSearch
                                  : _questType == CreateQuestType.GPSAreaHike
                                      ? QuestType.GPSAreaHike
                                      : QuestType.GPSAreaHunt,
                            ),
                          )
                        : Text(
                            "Select Quest Type",
                          ),
                  );
                },
              ).toList(),
              onChanged: (QuestType? questType) {
                questTypeValue = questType;
                model.setQuestType(questType: questType!);
              },
              placeholder: 'Select quest type',
              value: questTypeValue,
              errorText: model.questTypeInputValidationMessage,
            ),
            verticalSpaceLarge,
            AfkCreditsInputField(
              placeholder: 'Credit amount',
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: afkCreditAmountController,
              errorText: model.afkCreditsInputValidationMessage,
            ),
          ],
        ),
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
            AfkCreditsInputField(
              placeholder: 'Credit amount',
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: afkCreditAmountController,
              errorText: model.afkCreditsInputValidationMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseMarkersView extends StatelessWidget with $CreateQuestView {
  final CreateQuestViewModel model;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController afkCreditAmountController;

  ChooseMarkersView({
    required this.model,
    required this.nameController,
    required this.descriptionController,
    required this.afkCreditAmountController,
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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                alignment: Alignment.center,
                height: 60,
                padding: const EdgeInsets.all(10.0),
                width: screenWidth(context, percentage: 0.9),
                decoration: BoxDecoration(
                  color: kcLightCyan,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: kcShadowColor,
                        blurRadius: 0.3,
                        spreadRadius: 0.5)
                  ],
                ),
                child: AfkCreditsText.headingFour(
                  model.getAFKMarkers.length == 0
                      ? "1. Tap on the map to choose the start of the quest"
                      : model.getAFKMarkers.length == 1
                          ? "2. Choose at least one more marker"
                          : "3. Press 'Create Quest' when you are done",
                  align: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* Widget showErrorTextBox(String? message) {
  if (message != null) {
    return Text(message, style: TextStyle(color: Colors.red));
  } else {
    return SizedBox(height: 0, width: 0);
  }
}
 */
