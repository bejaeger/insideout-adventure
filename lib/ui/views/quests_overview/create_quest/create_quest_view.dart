import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:uuid/uuid.dart';
import 'create_quest.form.dart';
import 'create_quest_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'name'),
    FormTextField(name: 'description'),
    FormTextField(name: 'afkCreditAmount'),
    /*   FormTextField(name: 'markerNotes'), */
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
          /*   appBar: CustomAppBar(
            alignLeft: true,
            title: "Create a Quest",
            widget: IconButton(
              color: Colors.white,
              icon: Icon(Icons.person),
              onPressed: () {
                model.logout();
              },
            ),
          ), */
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                centerTitle: true,
                title: Text("Create Quest"),
                // floating: true,
                expandedHeight: 80,
                pinned: true,
                actions: [
                  /*     
              IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.person), onPressed: () {  },
                    
                  ), */
                ],
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
                selectedQuestType = value;
              },
            ),
            verticalSpaceSmall,
            Expanded(
              child: GoogleMap(
                zoomControlsEnabled: false,
                //mapType: MapType.hybrid,
                initialCameraPosition: model.initialCameraPosition(),
                //Place Markers in the Map
                markers: model.markersInMap.getMarkersOnMap,

                //callback that’s called when the map is ready to us.
                onMapCreated: model.onMapCreated,

                onTap: model.displayMarkersOnMap,
                // onLongPress: model.removeMarkers,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      afkCreditAmount =
                          num.parse(afkCreditAmountController!.text);
                      var id = Uuid();
                      questId = id.v1().toString().replaceAll('-', '');
                      await model.createQuest(
                        quest: Quest(
                            id: questId!,
                            startMarker: model.markersInMap.getAFKMarkers.first,
                            finishMarker: model.markersInMap.getAFKMarkers.last,
                            name: nameController!.text.toString(),
                            description: descriptionController!.text.toString(),
                            type: selectedQuestType ?? QuestType.QRCodeHike,
                            markers: model.markersInMap.getAFKMarkers,
                            afkCredits: afkCreditAmount!),
                      );
                      model.resetMarkersValues();

                      //Clear Controllers
                      nameController!.clear();
                      questTypeController!.clear();
                      afkCreditAmountController!.clear();
                      descriptionController!.clear();
                    },
                    icon: const Icon(Icons
                        .addchart), //completer(DialogResponse(confirmed: true)),
                    label: const Text(
                      'Add',
                    ),
                  ),
                  horizontalSpaceSmall,
                  ElevatedButton.icon(
                    onPressed: () {
                      model.resetMarkersValues();
                      model.navBackToPreviousView();
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text(
                      "Cancel",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
