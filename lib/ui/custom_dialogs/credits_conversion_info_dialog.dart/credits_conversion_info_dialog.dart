import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/credits_system.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked_services/stacked_services.dart';

class CreditsConversionInfoDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const CreditsConversionInfoDialog(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InsideOutText.headingThree("Our conversions"),
              verticalSpaceMedium,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        kInsideOutLogoSmallPathColored,
                        height: 24,
                        color: kcPrimaryColor,
                      ),
                      InsideOutText.captionBold("1 credit"),
                    ],
                  ),
                  horizontalSpaceTiny,
                  Icon(Icons.arrow_right_alt, size: 24, color: kcMediumGrey),
                  horizontalSpaceTiny,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        kScreenTimeIcon,
                        height: 24,
                        color: kcScreenTimeBlue,
                      ),
                      InsideOutText.captionBold(
                          "${CreditsSystem.kCreditsToScreenTimeConversionFactor.round()} min"),
                    ],
                  ),
                ],
              ),
              verticalSpaceTiny,
              InsideOutText.body(
                  "Per default 1 credit converts to ${CreditsSystem.kCreditsToScreenTimeConversionFactor.round()} minute screen time. In future versions of the app we will allow to adjust this conversion."),
              verticalSpaceMedium,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        kActivityIcon,
                        height: 24,
                        color: kcActivityIconColor,
                      ),
                      InsideOutText.captionBold(
                          "${(1 / CreditsSystem.kMinuteActivityToCreditsConversion).round().toString()} min"),
                    ],
                  ),
                  horizontalSpaceTiny,
                  Icon(Icons.arrow_right_alt, size: 24, color: kcMediumGrey),
                  horizontalSpaceTiny,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        kInsideOutLogoSmallPathColored,
                        height: 24,
                        color: kcPrimaryColor,
                      ),
                      InsideOutText.captionBold("1 credit"),
                    ],
                  ),
                ],
              ),
              verticalSpaceTiny,
              InsideOutText.body(
                  "We recommend giving 1 credit for ${(1 / CreditsSystem.kMinuteActivityToCreditsConversion).round().toString()} minutes of activity. By creating your own quests you can decide on this conversion."),
              verticalSpaceSmall,
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    child: InsideOutText.body("Ok", color: kcPrimaryColor),
                    onPressed: () => completer(DialogResponse(confirmed: true)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
