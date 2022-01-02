import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'create_quest.form.dart';
import 'create_quest_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'name'),
  FormTextField(name: 'description'),
  //FormTextField(name: 'distanceFromUser'),
  FormTextField(name: 'afkCreditAmount'),
  FormTextField(name: 'questType'),
  FormDropdownField(
    name: 'afkStartAndFinishMarkers',
    items: [
      StaticDropdownItem(
        title: 'startMarker',
        value: 'start',
      ),
      StaticDropdownItem(
        title: 'finishMarker',
        value: 'finish',
      ),
    ],
  ),
])
class CreateQuestView extends StatelessWidget with $CreateQuestView {
  CreateQuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateQuestViewModel>.reactive(
/*       onModelReady: (model) {
        model.getQuestMarkers();
        listenToFormUpdated(model);
      }, */
      onModelReady: (model) => listenToFormUpdated(model),
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
        body: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height / 2,
          //width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Quest Name: ',
                  ),
                  controller: nameController,
                  // focusNode: nameFocusNode,
                ),
              ),
              verticalSpaceSmall,
              Expanded(
                child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Quest Description: ',
                    ),
                    controller: descriptionController),
              ),
              verticalSpaceSmall,
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'AFK Credit Amount: ',
                  ),
                  // keyboardType: TextInputType.number,
                  /*  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ], */
                  controller: afkCreditAmountController,
                ),
              ),
              verticalSpaceSmall,
              Expanded(
                child: DropdownButtonFormField<QuestType>(
                  hint: Text('Select Quest Type'),
                  items: questType.map((_questType) {
                    return DropdownMenuItem(
                      value: _questType,
                      child: Text(_questType
                          .toString()) /* TextField(
                          decoration: InputDecoration(),
                          controller: questTypeController
                            ..text = _questType.toString()) */
                      ,
                    );
                  }).toList(),
                  onChanged: (QuestType? value) {
                    //print(value.toString());
                  },
                ),
              ),
              verticalSpaceSmall,
              Expanded(
                child: DropdownButtonFormField(
                  hint: Text('Select Start Marker'),
                  items: model.getAFKMarkers?.map((_questIds) {
                    return DropdownMenuItem(
                      value: _questIds,
                      child: Text(
                        _questIds!.id.toString(),
                      ) /* TextField(
                          decoration: InputDecoration(),
                          controller: questTypeController
                            ..text = _questType.toString()) */
                      ,
                    );
                  }).toList(),
                  onChanged: (startMarker) {
                    /* model.setMarkersId(
                        startOrFinishMarker: startMarker as AFKMarker); */
                    // print(value.toString());
                  },
                ),
              ),
              verticalSpaceSmall,
              /*       ElevatedButton(
                // onPressed: model.navigateToExplorerHomeView,
                onPressed: model.logout,
                //child: Text("Go to explorer home/map")),
                child: Text("Logout  "),
              ),
              verticalSpaceSmall, */

              /*               ListView.builder(
                itemCount: model.getAFKMarkers!.length,
                itemBuilder: (BuildContext context, int index) {
                  return widget(
                    child: DropdownMenuItem(
                      value: "",
                      child: Text(model.getAFKMarkers![index]!.id),
                    ),
                  );
                },
              ), */

              // DropdownButtonFormField(items: onChanged: onChanged)

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final questName = nameController.text.toString();
                      print("Harguilar THis is your QUest Name: ${questName}");
                    }, //completer(DialogResponse(confirmed: true)),
                    child: Text(
                      'Create',
                      //request.mainButtonTitle.toString(),
                      /* style: textTheme(context)
                          .headline6!
                          .copyWith(color: kBlackHeadlineColor), */
                    ),
                  ),
                  horizontalSpaceSmall,
                  ElevatedButton(
                    onPressed: () {
                      model.navBackToPreviousView();
                      /*     return completer(
                        DialogResponse(confirmed: false),
                      ); */
                    },
                    child: Text(
                      "Cancel",
                      //request.secondaryButtonTitle.toString(),
                      /*   style: textTheme(context)
                          .headline6!
                          .copyWith(color: kBlackHeadlineColor), */
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => CreateQuestViewModel(),
    );
  }
}
