import 'package:afkcredits/enums/quest_category.dart';
import 'package:afkcredits/ui/views/single_quest/single_quest_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleQuestView extends StatelessWidget {
  final QuestCategory? questCategory;
  const SingleQuestView({Key? key, required this.questCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleQuestViewModel>.reactive(
      viewModelBuilder: () => SingleQuestViewModel(),
      builder: (context, model, child) => questCategory == null
          ? Container(
              child: Text(
                  "ERROR! This should never happen. You navigated to a single quest view without providing a quest category. Hopefully you are not a user of the app but a developer. Otherwise please help us and let the developers know immediately"),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(describeEnum(questCategory.toString().toUpperCase())),
                leading: IconButton(
                  onPressed: model.navigateBack,
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 200, height: 200, color: Colors.cyan),
                      Container(width: 200, height: 200, color: Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
