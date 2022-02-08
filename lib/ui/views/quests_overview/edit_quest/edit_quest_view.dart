import 'package:afkcredits/ui/views/quests_overview/edit_quest/updating_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'basic_dialog_content/basic_dialog_content.dart';

class UpdatingQuestView extends StatelessWidget {
  const UpdatingQuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdatingQuestViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Edit Quest ",
            onBackButton: model.navBackToPreviousView,
          ),
          body: BasicDialogContent(quest: model.getUpdatedQuest, model: model),
        ),
      ),
      viewModelBuilder: () => UpdatingQuestViewModel(),
    );
  }
}
