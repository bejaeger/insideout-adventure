import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/credits_to_screentime_widget.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/quest_type_tag.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            RaiseQuestBottomSheetViewModel(quest: request.data),
        builder: (context, model, child) {
          Quest quest = request.data;
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
                          if (model.isParentAccount)
                            model.quest.createdBy == null
                                ? AfkCreditsText.body("Public")
                                : AfkCreditsText.body(
                                    "Created ${model.isParentAccount ? "by" : "for"} you"),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        children: [
                          Image.asset(kAFKCreditsLogoPath,
                              height: 24, color: kcPrimaryColor),
                          SizedBox(width: 2.0),
                          AfkCreditsText.headingThree(
                            quest.afkCredits.toStringAsFixed(0),
                          ),
                          horizontalSpaceSmall,
                          AfkCreditsText.headingFour("-"),
                          horizontalSpaceSmall,
                          Text(quest.name.toString(),
                              style: heading3Style.copyWith(
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 3),
                        ],
                      ),
                      verticalSpaceMedium,
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Row(
                          children: [
                            if (quest.distanceMarkers != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // AfkCreditsText.headingThreeLight("  -  "),
                                  Image.asset(
                                    kWalkingIcon,
                                    height: 18,
                                    //color: kcOrange,
                                  ),
                                  horizontalSpaceTiny,
                                  AfkCreditsText.bodyBold(
                                    "~" +
                                        (HerculesWorldCreditSystem
                                                    .kSimpleDistanceMarkersToDistanceWalkScaling *
                                                quest.distanceMarkers!)
                                            .toStringAsFixed(0) +
                                        "m",
                                    //color: kcOrange,
                                  ),
                                ],
                              ),
                            if (quest.distanceMarkers != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AfkCreditsText.headingThreeLight("  -  "),
                                  Icon(
                                    Icons.schedule,
                                    size: 20,
                                    //color: kcScreenTimeBlue,
                                  ),
                                  horizontalSpaceTiny,
                                  AfkCreditsText.bodyBold(
                                    "~" +
                                        (HerculesWorldCreditSystem
                                                    .kDistanceInMeterToActivityMinuteConversion *
                                                quest.distanceMarkers!)
                                            .toStringAsFixed(0) +
                                        "min",
                                    //color: kcScreenTimeBlue,
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (quest.description != "") verticalSpaceMedium,
                  if (quest.description != "")
                    AfkCreditsText.body(quest.description.toString()),
                  verticalSpaceMedium,
                  if (model.checkSponsoringSentence() != null)
                    Text(
                      model.checkSponsoringSentence()!,
                      style: TextStyle(color: Colors.red),
                      // textAlign: TextAlign.left,
                    ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AfkCreditsButton.text(
                              title: request.secondaryButtonTitle.toString(),
                              onTap: quest.createdBy == null
                                  ? null
                                  : () => completer(
                                        SheetResponse(confirmed: false),
                                      ),
                            ),
                            if (model.isParentAccount &&
                                quest.createdBy == null)
                              AfkCreditsText.caption(
                                  "Can't delete quest because this is a public quest",
                                  align: TextAlign.center),
                          ],
                        ),
                      ),
                      horizontalSpaceMedium,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AfkCreditsButton(
                              disabled: model.isParentAccount,
                              title: request.mainButtonTitle.toString(),
                              onTap: model.isParentAccount
                                  ? model.showNotImplementedInParentAccount
                                  : model.hasEnoughSponsoring(
                                          quest: model.quest)
                                      ? () => completer(
                                          SheetResponse(confirmed: true))
                                      : null,
                            ),
                            // if (model.isParentAccount)
                            //   AfkCreditsText.caption(
                            //       "Not supported in parent account yet",
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
