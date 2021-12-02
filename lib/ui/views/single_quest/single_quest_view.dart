import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_minigame/active_minigame_view.dart';
import 'package:afkcredits/ui/views/single_quest/single_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleQuestView extends StatelessWidget {
  final QuestType? questType;
  const SingleQuestView({Key? key, required this.questType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleQuestViewModel>.reactive(
      viewModelBuilder: () => SingleQuestViewModel(),
      builder: (context, model, child) => questType == null
          ? Container(
              child: Text(
                  "ERROR! This should never happen. You navigated to a single quest view without providing a quest category. Hopefully you are not a user of the app but a developer. Otherwise please help us and let the developers know immediately"),
            )
          : model.hasActiveQuest
              ? ActiveMiniGameView()
              : Scaffold(
                  appBar: CustomAppBar(
                    title: describeEnum(questType.toString().toUpperCase()),
                    onBackButton: model.navigateBack,
                  ),
                  body: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.cyan,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Estimate 500 Meters",
                                    style: textTheme(context)
                                        .headline5!
                                        .copyWith(color: Colors.grey[200])),
                                ElevatedButton(
                                    onPressed: model.startMinigameQuest,
                                    child: Text("Start quest")),
                              ],
                            ),
                          ),
                          Container(
                              width: 200, height: 200, color: Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
