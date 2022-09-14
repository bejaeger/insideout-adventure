import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/ui/widgets/activity_conversion_icon.dart';
import 'package:afkcredits/ui/widgets/screen_time_conversion_icon.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class CreditConversionInfoDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const CreditConversionInfoDialog(
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
              AfkCreditsText.headingThree("Our conversions"),
              verticalSpaceMedium,
              //OnboardingActivityConversionIcon(),
              // Row(
              //   children: [
              //     AfkCreditsText.headingFour("Activity"),
              //     Icon(Icons.arrow_right_alt, size: 24, color: kcMediumGrey),
              //     AfkCreditsText.headingFour("Credits"),
              //   ],
              // ),
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
                      AfkCreditsText.captionBold(
                          "${(1 / HerculesWorldCreditSystem.kMinuteActivityToCreditsConversion).round().toString()} min"),
                    ],
                  ),
                  horizontalSpaceTiny,
                  Icon(Icons.arrow_right_alt, size: 24, color: kcMediumGrey),
                  horizontalSpaceTiny,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        kAFKCreditsLogoSmallPathColored,
                        height: 24,
                        color: kcPrimaryColor,
                      ),
                      AfkCreditsText.captionBold("1 credit"),
                    ],
                  ),
                ],
              ),
              verticalSpaceTiny,
              AfkCreditsText.body(
                  "We recommend giving 1 credit for ${(1 / HerculesWorldCreditSystem.kMinuteActivityToCreditsConversion).round().toString()} minutes of activity. By creating your own quests you can decide on this conversion."),
              verticalSpaceMedium,

              // Row(
              //   children: [
              //     AfkCreditsText.headingFour("Credits"),
              //     Icon(Icons.arrow_right_alt, size: 24, color: kcMediumGrey),
              //     AfkCreditsText.headingFour("Screen time"),
              //   ],
              // ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        kAFKCreditsLogoSmallPathColored,
                        height: 24,
                        color: kcPrimaryColor,
                      ),
                      AfkCreditsText.captionBold("1 credit"),
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
                      AfkCreditsText.captionBold(
                          "${HerculesWorldCreditSystem.kCreditsToScreenTimeConversionFactor.round()} min"),
                    ],
                  ),
                ],
              ),
              verticalSpaceTiny,
              AfkCreditsText.body(
                  "Per default 1 credit converts to ${HerculesWorldCreditSystem.kCreditsToScreenTimeConversionFactor.round()} minute screen time. In future versions of the app we will allow to adjust this conversion."),
              verticalSpaceSmall,
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    child: AfkCreditsText.body("Ok", color: kcPrimaryColor),
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