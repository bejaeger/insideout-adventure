import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/quest_type_tag.dart';
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
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
                  QuestTypeTag(quest: model.quest),
                  verticalSpaceTiny,
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: CreditsAmount(
                        amount: model.quest.afkCredits, height: 20),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Text(request.title.toString(),
                  style:
                      heading3Style.copyWith(overflow: TextOverflow.ellipsis),
                  maxLines: 3),
              // verticalSpaceTiny,
              verticalSpaceMedium,
              AfkCreditsText.body(request.description.toString()),
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
                        AfkCreditsButton.outline(
                          title: request.secondaryButtonTitle.toString(),
                          onTap: request.data.createdBy == null
                              ? null
                              : () => completer(
                                    SheetResponse(confirmed: false),
                                  ),
                        ),
                        if (model.isParentAccount &&
                            request.data.createdBy == null)
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
                              ? null
                              : model.hasEnoughSponsoring(quest: model.quest)
                                  ? () =>
                                      completer(SheetResponse(confirmed: true))
                                  : null,
                        ),
                        if (model.isParentAccount)
                          AfkCreditsText.caption(
                              "Not supported in parent account yet",
                              align: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
