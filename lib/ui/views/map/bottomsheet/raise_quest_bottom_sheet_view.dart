import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/quest_specifications_row.dart';
import 'package:afkcredits/ui/widgets/quest_type_tag.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'raise_quest_bottom_sheet_viewmodel.dart';

class RaiseQuestBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const RaiseQuestBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RaiseQuestBottomSheetViewModel>.reactive(
        viewModelBuilder: () =>
            RaiseQuestBottomSheetViewModel(quest: request.data["quest"]),
        builder: (context, model, child) {
          Quest quest = request.data["quest"];
          bool completed = request.data["completed"];
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: GrabberLine()),
                  verticalSpaceTiny,
                  verticalSpaceSmall,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuestTypeTag(quest: model.quest),
                          if (model.isGuardianAccount)
                            model.quest.createdBy == null
                                ? InsideOutText.body("Public")
                                : InsideOutText.body(
                                    "Created ${model.isGuardianAccount ? "by" : "for"} you"),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(kAFKCreditsLogoPath,
                              height: 24, color: kcPrimaryColor),
                          SizedBox(width: 6.0),
                          InsideOutText.headingThree(
                            quest.credits.toStringAsFixed(0),
                          ),
                          horizontalSpaceSmall,
                          InsideOutText.headingFour("-"),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Text(quest.name.toString(),
                                style: heading3Style.copyWith(
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 3),
                          ),
                        ],
                      ),
                      if (!completed) verticalSpaceMedium,
                      if (!completed) QuestSpecificationsRow(quest: quest),
                    ],
                  ),
                  if (quest.description != "") verticalSpaceMedium,
                  if (quest.description != "")
                    Text(
                      quest.description.toString(),
                      maxLines: 3,
                      style: bodyStyleSofia.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  verticalSpaceMedium,
                  if (model.checkGuardianshipSentence() != null)
                    Text(
                      model.checkGuardianshipSentence()!,
                      style: TextStyle(color: Colors.red),
                    ),
                  //verticalSpaceSmall,
                  if (completed)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Completed",
                            style: heading3Style.copyWith(
                              color: kcPrimaryColor,
                            ),
                          ),
                        ),
                        verticalSpaceSmall,
                        SwitchListTile(
                          value: model.userService.currentUserSettings
                              .isShowingCompletedQuests,
                          title: InsideOutText.body(
                            "Display on map",
                          ),
                          onChanged: (value) =>
                              model.setIsShowingCompletedQuests(value),
                        ),
                      ],
                    ),
                  if (completed) verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (quest.createdBy != null ||
                                !model.isGuardianAccount)
                              InsideOutButton.text(
                                leading: model.isGuardianAccount
                                    ? null
                                    : Icon(Icons.close, color: kcPrimaryColor),
                                title: request.secondaryButtonTitle.toString(),
                                onTap: quest.createdBy == null &&
                                        model.isGuardianAccount
                                    ? null
                                    : () => completer(
                                          SheetResponse(confirmed: false),
                                        ),
                              ),
                            if (model.isGuardianAccount &&
                                quest.createdBy == null)
                              InsideOutText.caption(
                                  "Can't delete quest because this is a public quest",
                                  align: TextAlign.center),
                          ],
                        ),
                      ),
                      if (!completed) horizontalSpaceMedium,
                      if (!completed)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InsideOutButton(
                                //disabled: model.isGuardianAccount,
                                leading: model.isGuardianAccount
                                    ? null
                                    : Icon(Icons.play_arrow_rounded,
                                        color: Colors.white),
                                title: request.mainButtonTitle.toString(),
                                onTap:
                                    // model.isGuardianAccount
                                    //     ? model.showNotImplementedInGuardianAccount
                                    //     :
                                    model.hasEnoughGuardianship(
                                            quest: model.quest)
                                        ? () => completer(
                                            SheetResponse(confirmed: true))
                                        : null,
                              ),
                              // if (model.isGuardianAccount)
                              //   InsideOutText.caption(
                              //       "Not supported in guardian account yet",
                              //       align: TextAlign.center),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
