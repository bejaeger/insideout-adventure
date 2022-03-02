// ignore_for_file: must_be_immutable, unnecessary_statements

import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:uuid/uuid.dart';
import '../../../../datamodels/quests/quest.dart';
import '../../../layout_widgets/buttons_layouts.dart';
import 'create_quest.form.dart';
import 'create_quest_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'name'),
    FormTextField(name: 'description'),
    FormTextField(name: 'afkCreditAmount'),
    //FormTextField(name: 'markerNotes'),
    FormTextField(name: 'questType'),
  ],
)
// ignore: must_be_immutable
class CreateQuestView extends StatelessWidget with $CreateQuestView {
  CreateQuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateQuestViewModel>.reactive(
      onModelReady: (model) {
        // model.getQuestMarkers();
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
                    questTypeController: questTypeController),
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
  final TextEditingController? questTypeController;

  QuestCardList(
      {required this.model,
      required this.afkCreditAmountController,
      required this.descriptionController,
      required this.nameController,
      required this.questTypeController});

  String? questId;
  String? afkCreditId;
  num? afkCreditAmount;
  QuestType? selectedQuestType;

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
            verticalSpaceSmall,
            DropdownButtonFormField<QuestType>(
              //key: _key,
              hint: Text('Select Quest Type'),
              isExpanded: true,
              items: QuestType.values.map((_questType) {
                return DropdownMenuItem(
                  // key: _key,
                  value: _questType,
                  child: Text(
                    _questType.toString().split('.').elementAt(1),
                  ),
                );
              }).toList(),
              onChanged: (QuestType? value) {
                //if (selectedQuestType!.name.isNotEmpty) {
                selectedQuestType = value;
                // value = null;
              },
            ),
            verticalSpaceSmall,
            Expanded(
              child: GoogleMap(
                zoomControlsEnabled: false,
                //mapType: MapType.hybrid,
                initialCameraPosition: model.initialCameraPosition(),
                //Place Markers in the Map
                markers: model.getMarkersOnMap,

                //callback that’s called when the map is ready to us.
                onMapCreated: model.onMapCreated,

                onTap: model.displayMarkersOnMap,
                // onLongPress: model.removeMarkers,
              ),
            ),
            verticalSpaceSmall,
            CustomAFKButton(
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
                if (afkCreditAmountController!.text.isNotEmpty &&
                    nameController!.text.isNotEmpty &&
                    selectedQuestType != null &&
                    descriptionController!.text.isNotEmpty) {
                  afkCreditAmount = num.parse(afkCreditAmountController!.text);
                  var id = Uuid();
                  questId = id.v1().toString().replaceAll('-', '');
                  await model.createQuest(
                    quest: Quest(
                        id: questId!,
                        startMarker: model.getAFKMarkers.first,
                        finishMarker: model.getAFKMarkers.last,
                        name: nameController!.text.toString(),
                        description: descriptionController!.text.toString(),
                        type: selectedQuestType!,
                        markers: model.getAFKMarkers,
                        afkCredits: afkCreditAmount!),
                  );

                  model.resetMarkersValues();
                  //Clear Controllers
                  nameController!.clear();
                  questTypeController!.clear();
                  afkCreditAmountController!.clear();
                  descriptionController!.clear();
                  model.navBackToPreviousView();
                } else {
                  model.displayEmptyTextsSnackBar();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}