import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class CreditsToScreenTimeWidget extends StatelessWidget {
  final int credits;
  final int availableScreenTime;
  final double sizeScale;
  const CreditsToScreenTimeWidget({
    Key? key,
    required this.credits,
    required this.availableScreenTime,
    this.sizeScale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(kAFKCreditsLogoPath,
            height: 28 * sizeScale, color: kcPrimaryColor),
        SizedBox(width: 8.0 * sizeScale),
        AfkCreditsText(
            text: credits.toStringAsFixed(0),
            style: heading3Style.copyWith(fontSize: 24 * sizeScale)),
        SizedBox(width: 8.0 * sizeScale),
        Icon(Icons.arrow_forward, size: 25 * sizeScale),
        SizedBox(width: 8.0 * sizeScale),
        //Icon(Icons.schedule, color: kcScreenTimeBlue, size: 35),
        Image.asset(kScreenTimeIcon,
            height: 28 * sizeScale, color: kcScreenTimeBlue),
        SizedBox(width: 8.0 * sizeScale),
        AfkCreditsText(
          text: availableScreenTime.toString(),
          style: heading3Style.copyWith(fontSize: 24 * sizeScale),
        ),
        AfkCreditsText.bodyBold(
          " min",
          color: kcBlackHeadlineColor,
        ),
      ],
    );
  }
}
