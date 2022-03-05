// ignore_for_file: must_be_immutable, unnecessary_statements

import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../../layout_widgets/buttons_layouts.dart';
import 'create_quest.form.dart';
import 'create_quest_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'name'),
    FormTextField(name: 'description'),
    FormTextField(name: 'afkCreditAmount'),
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
        if (model.getCurrentPostion == null) model.setPosition();
        listenToFormUpdated(model);
      },
      viewModelBuilder: () => CreateQuestViewModel(),
      // onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text("Create Quest"),
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
                onNextPressed: () {
                  if (model.isValidUserInputs()) {
                    controller.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  }
                },
              ),
              ChooseMarkersView(
                model: model,
                nameController: nameController,
                descriptionController: descriptionController,
                afkCreditAmountController: afkCreditAmountController,
                onBackPressed: () => controller.previousPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestCardList extends StatelessWidget with $CreateQuestView {
  final CreateQuestViewModel model;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController afkCreditAmountController;
  final void Function() onNextPressed;
  QuestType? questTypeValue;

  QuestCardList({
    required this.model,
    required this.nameController,
    required this.descriptionController,
    required this.afkCreditAmountController,
    required this.onNextPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        height: screenHeight(context) - 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceSmall,
            TextField(
              decoration: InputDecoration(
                labelText: 'Quest Name: ',
              ),
              controller: nameController,
              keyboardType: TextInputType.text,
              // focusNode: nameFocusNode,
            ),
            showErrorTextBox(model.nameInputValidationMessage),
            verticalSpaceSmall,
            TextField(
              decoration: InputDecoration(
                labelText: 'Quest Description: ',
              ),
              // keyboardType: TextInputType.name,
              controller: descriptionController,
              keyboardType: TextInputType.text,
            ),
            verticalSpaceSmall,
            TextField(
              decoration: InputDecoration(
                labelText: 'AFK Credit Amount: ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: afkCreditAmountController,
            ),
            showErrorTextBox(model.afkCreditsInputValidationMessage),
            verticalSpaceSmall,
            DropdownButtonFormField<QuestType>(
              //key: _key,
              value: questTypeValue,
              hint: Text('Select Quest Type'),
              isExpanded: true,
              items: QuestType.values.map(
                (_questType) {
                  return DropdownMenuItem(
                    value: _questType,
                    child: model.isLoading == false
                        ? Text(
                            _questType.toString().split('.').elementAt(1),
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
            ),
            showErrorTextBox(model.questTypeInputValidationMessage),
            showErrorTextBox(model.afkMarkersInputValidationMessage),
            verticalSpaceSmall,
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CustomAFKButton(
                busy: model.isLoading,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainButtonTitle: 'Next',
                secundaryButtonTitle: 'Cancel',
                onSecondaryButtonTapped: () {
                  {
                    model.resetMarkersValues();
                    model.navBackToPreviousView();
                  }
                },
                onMainButtonTapped: onNextPressed,

                // () async {
                //   final result = await model.clearFieldsAndNavigate();
                //   //Clear Controllers
                //   if (result) {
                //     nameController.clear();
                //     afkCreditAmountController.clear();
                //     descriptionController.clear();
                //   }
              ),
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
  final void Function() onBackPressed;

  ChooseMarkersView({
    required this.model,
    required this.nameController,
    required this.descriptionController,
    required this.afkCreditAmountController,
    required this.onBackPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: GoogleMap(
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
              // gestureRecognizers: Set()
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.grey[50]!.withOpacity(0.0),
                      Colors.grey[50]!
                    ])),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 80,
                width: screenWidth(context, percentage: 0.9),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text("Choose at least two markers",
                        textAlign: TextAlign.center,
                        style: textTheme(context).headline6)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CustomAFKButton(
                busy: model.isLoading,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainButtonTitle: 'Create Quest',
                secundaryButtonTitle: 'Back',
                onSecondaryButtonTapped: onBackPressed,
                onMainButtonTapped: model.getAFKMarkers.length < 2
                    ? null
                    : () async {
                        final result = await model.clearFieldsAndNavigate();
                        //Clear Controllers
                        if (result) {
                          nameController.clear();
                          afkCreditAmountController.clear();
                          descriptionController.clear();
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget showErrorTextBox(String? message) {
  if (message != null) {
    return Text(message, style: TextStyle(color: Colors.red));
  } else {
    return SizedBox(height: 0, width: 0);
  }
}
