// ignore_for_file: must_be_immutable, unnecessary_statements

import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/gestures.dart';
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateQuestViewModel>.reactive(
      onModelReady: (model) {
        if (model.getCurrentPostion == null) model.setPosition();
        listenToFormUpdated(model);
      },
      // onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                centerTitle: true,
                title: Text("Create Quest"),
                // floating: true,
                expandedHeight: 80,
                pinned: true,
                actions: [],
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: QuestCardList(
                  model: model,
                  nameController: nameController,
                  afkCreditAmountController: afkCreditAmountController,
                  descriptionController: descriptionController,
                ),
              ),
            ],
          ),
        ),
      ),

      viewModelBuilder: () => CreateQuestViewModel(),
    );
  }
}

class QuestCardList extends StatelessWidget {
  final CreateQuestViewModel model;
  final TextEditingController? nameController;
  final TextEditingController? descriptionController;
  final TextEditingController? afkCreditAmountController;

  showErrorTextBox(String? message) {
    if (message != null) {
      return Text(message, style: TextStyle(color: Colors.red));
    }
    if (message == null) {
      return SizedBox(height: 0, width: 0);
    }
  }

  QuestCardList({
    required this.model,
    required this.afkCreditAmountController,
    required this.descriptionController,
    required this.nameController,
  });
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
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
              hint: Text('Select Quest Type'),
              isExpanded: true,
              items: QuestType.values.map((_questType) {
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
              }).toList(),
              onChanged: (QuestType? questType) {
                model.setQuestType(questType: questType!);
              },
            ),
            showErrorTextBox(model.questTypeInputValidationMessage),
            verticalSpaceSmall,
            Expanded(
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
                //myLocationEnabled: true,
                // gestureRecognizers: Set()
              ),
            ),
            showErrorTextBox(model.afkMarkersInputValidationMessage),
            verticalSpaceSmall,
            CustomAFKButton(
              busy: model.isLoading,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainButtonTitle: 'Add',
              secundaryButtonTitle: 'Cancel',
              onSecondaryButtonTapped: () {
                {
                  model.resetMarkersValues();
                  model.navBackToPreviousView();
                }
              },
              onMainButtonTapped: () async {
                final result = await model.clearFieldsAndNavigate();
                //Clear Controllers
                if (result) {
                  nameController!.clear();
                  afkCreditAmountController!.clear();
                  descriptionController!.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
