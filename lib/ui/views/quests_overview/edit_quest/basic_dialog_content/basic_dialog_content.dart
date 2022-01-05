import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/updating_quest_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'basic_dialog_content.form.dart';
import 'basic_quest_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'name'),
  FormTextField(name: 'description'),
  FormTextField(name: 'distanceFromUser'),
])
// ignore: must_be_immutable
class BasicDialogContent extends StatelessWidget with $BasicDialogContent {
  final UpdatingQuestViewModel model;
  //final DialogRequest request;
  Quest? quest;
  //final Function(DialogResponse dialogResponse) completer;

  BasicDialogContent(
      {Key? key,
      // required this.request,
      //required this.completer,
      required this.model,
      required this.quest})
      : super(key: key);

  final log = getLogger("BasicDialogContent");

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BasicQuestViewModel>.reactive(
      onModelReady: (viewModel) =>
          SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        listenToFormUpdated(model);
      }),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalSpaceSmall,
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quest Name: ',
                ),
                controller: nameController..text = quest!.name.toString(),
                focusNode: nameFocusNode,
              ),
              verticalSpaceSmall,
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quest Description: ',
                ),
                controller: descriptionController
                  ..text = quest!.description.toString(),
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await model.updateQuestData(
                        quest: Quest(
                            id: quest!.id,
                            name: nameController.text.toString(),
                            description: descriptionController.text.toString(),
                            type: quest!.type,
                            markers: quest!.markers,
                            afkCredits: quest!.afkCredits),
                      );
                    }, //completer(DialogResponse(confirmed: true)),
                    child: Text(
                      'Update',
                      //request.mainButtonTitle.toString(),
                      style: textTheme(context)
                          .headline6!
                          .copyWith(color: kBlackHeadlineColor),
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
                      style: textTheme(context)
                          .headline6!
                          .copyWith(color: kBlackHeadlineColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => BasicQuestViewModel(),
    );
  }
}
