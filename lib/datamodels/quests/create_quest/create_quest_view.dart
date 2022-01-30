import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:uuid/uuid.dart';
import '../quest.dart';
import 'create_quest.form.dart';
import 'create_quest_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'name'),
    FormTextField(name: 'description'),
    //FormTextField(name: 'distanceFromUser'),
    FormTextField(name: 'afkCreditAmount'),
    FormTextField(name: 'questType'),
  ],
)
// ignore: must_be_immutable
class CreateQuestView extends StatelessWidget with $CreateQuestView {
  CreateQuestView({Key? key}) : super(key: key);
  String? questId;
  String? afkCreditId;
  num? afkCreditAmount;
  QuestType? selectedQuestType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateQuestViewModel>.reactive(
      onModelReady: (model) {
        model.getQuestMarkers();
        listenToFormUpdated(model);
      },
      // onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          alignLeft: true,
          title: "Create a Quest",
          widget: IconButton(
            color: Colors.white,
            icon: Icon(Icons.person),
            onPressed: () {
              model.logout();
            },
          ),
        ),
        body: SingleChildScrollView(
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
                    markers: model.markersOnMap,

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
                          /*       if (afkCreditAmountController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              questTypeController.text.isNotEmpty) { */
                          afkCreditAmount =
                              num.parse(afkCreditAmountController.text);
                          var id = Uuid();
                          questId = id.v1().toString().replaceAll('-', '');
                          await model.createQuest(
                            quest: Quest(
                                id: questId!,
                                startMarker: model.afkCredits.first,
                                finishMarker: model.afkCredits.last,
                                name: nameController.text.toString(),
                                description:
                                    descriptionController.text.toString(),
                                type: selectedQuestType ?? QuestType.Hike,
                                markers: model.afkCredits,
                                afkCredits: afkCreditAmount!),
                          );
                          model.resetMarkersValues();
                          //_key!.currentState!.reset();
                          //Clear Controllers

                          nameController.clear();
                          questTypeController.clear();
                          afkCreditAmountController.clear();
                          descriptionController.clear();
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
        ),
      ),

      viewModelBuilder: () => CreateQuestViewModel(),
    );
  }
}
