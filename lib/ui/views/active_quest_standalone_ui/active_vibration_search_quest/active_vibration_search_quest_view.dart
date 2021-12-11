import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_vibration_search_quest/active_vibration_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActiveVibrationSearchQuestView extends StatelessWidget {
  final void Function() onPressed;
  final double? lastDistance;
  final double? currentDistance;
  final Quest? quest;
  const ActiveVibrationSearchQuestView({
    Key? key,
    required this.onPressed,
    this.lastDistance,
    this.currentDistance,
    required this.quest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveVibrationSearchQuestViewModel>.reactive(
      viewModelBuilder: () => locator<ActiveVibrationSearchQuestViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) => model.initialize(quest: quest),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Search for the Trohpy!",
          onBackButton: model.navigateBack,
        ),
        body: model.isBusy
            ? Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(color: kPrimaryColor))
            : Align(
                alignment: Alignment.center,
                child: model.activeQuestNullable?.status == QuestStatus.success
                    ? Text("Successfully finished quest!",
                        style: textTheme(context)
                            .headline6!
                            .copyWith(color: kPrimaryColor))
                    : ListView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (model.hasActiveQuest)
                                AFKProgressIndicator(linear: true),
                              verticalSpaceSmall,
                              Text("Goal: Find the Trophy!",
                                  style: textTheme(context)
                                      .headline6!
                                      .copyWith(color: kPrimaryColor)),
                              verticalSpaceSmall,
                              Image.network(
                                  "https://thumbs.gfycat.com/IndolentDistantBuffalo-max-1mb.gif",
                                  height: 150),
                              verticalSpaceSmall,
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: model.showInstructions,
                                    child: Text(
                                      "Instructions",
                                      style: textTheme(context)
                                          .headline6!
                                          .copyWith(color: kWhiteTextColor),
                                    ),
                                  ),
                                  if (!model.hasActiveQuest) verticalSpaceSmall,
                                  if (!model.hasActiveQuest)
                                    AnimatedOpacity(
                                      duration: Duration(seconds: 1),
                                      opacity: (model.closeby != null &&
                                              model.closeby == true)
                                          ? 1.0
                                          : 0.5,
                                      child: ElevatedButton(
                                        onPressed: model.hasEnoughSponsoring(
                                                    quest: quest) &&
                                                (model.closeby != null &&
                                                    model.closeby == true)
                                            ? () => model.maybeStartQuest(
                                                quest: quest)
                                            : null,
                                        child: Text("Start Quest",
                                            style: textTheme(context)
                                                .headline6!
                                                .copyWith(
                                                    color: kWhiteTextColor)),
                                      ),
                                    ),
                                  (model.closeby != null &&
                                          model.closeby == true)
                                      ? SizedBox(height: 0, width: 0)
                                      : SizedBox(
                                          width: screenWidth(context,
                                              percentage: 0.6),
                                          child: Text(
                                              "Cannot start the quest. Please go to the start to the quest"),
                                        ),
                                ],
                              ),
                              verticalSpaceMedium,
                              if (currentDistance != null)
                                Text("Current Distance",
                                    style: textTheme(context).headline4),
                              if (currentDistance != null)
                                Text("${currentDistance?.toStringAsFixed(1)} m",
                                    style: textTheme(context).headline2),
                              if (lastDistance != null)
                                Text("Last Distance",
                                    style: TextStyle(fontSize: 18)),
                              if (lastDistance != null)
                                Text("${lastDistance?.toStringAsFixed(1)} m",
                                    style: TextStyle(fontSize: 18)),
                              if (model.hasActiveQuest)
                                Text("${model.directionStatus}",
                                    style: textTheme(context).headline6),
                              // TODO: Only allow access with admin login
                              if (model.currentGPSAccuracy != null &&
                                  model.userIsAdmin)
                                Text(
                                    "(Current GPS accuracy: ${model.currentGPSAccuracy!.toStringAsFixed(0)} m)"),
                            ],
                          ),
                          verticalSpaceMedium,
                        ],
                      ),
              ),
      ),
    );
  }
}
