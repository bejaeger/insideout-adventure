import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/updating_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'basic_dialog_content/basic_dialog_content.dart';
import 'edit_quest_viewmodel.dart';

/* class EditQuestView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const EditQuestView(
      {Key? key, required this.completer, required this.request})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditQuestViewModel>.reactive(
      builder: (context, model, child) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: BasicDialogContent(
         // completer: completer,
           model: model,
          //request: request,
          quest: request.data,
        ),
      ),
      viewModelBuilder: () => EditQuestViewModel(quest: request.data),
    );
  }
} */

class UpdatingQuestView extends StatelessWidget {
  const UpdatingQuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdatingQuestViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Updating Quest ",
            onBackButton: model.navBackToPreviousView,
          ),
          body: BasicDialogContent(quest: model.getUpdatedQuest, model: model),
        ),
      ),
      viewModelBuilder: () => UpdatingQuestViewModel(),
    );
  }
}
