import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/credits_system.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class QuestSpecificationsRow extends StatelessWidget {
  const QuestSpecificationsRow({
    Key? key,
    required this.quest,
    this.textColor,
  }) : super(key: key);

  final Color? textColor;
  final Quest? quest;

  @override
  Widget build(BuildContext context) {
    if (quest == null) return SizedBox(height: 0, width: 0);
    return Row(
      children: [
        if (quest!.distanceMarkers != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                kWalkingIcon,
                height: 18,
                color: kcOrange,
              ),
              horizontalSpaceTiny,
              InsideOutText.bodyBold(
                "~" +
                    (HerculesWorldCreditSystem
                                .kSimpleDistanceMarkersToDistanceWalkScaling *
                            quest!.distanceMarkers! *
                            0.001)
                        .toStringAsFixed(1) +
                    "km",
                color: textColor ?? kcGreyTextColor,
              ),
            ],
          ),
        if (quest!.distanceMarkers != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              horizontalSpaceMedium,
              Icon(
                Icons.schedule,
                size: 20,
                color: kcScreenTimeBlue,
              ),
              horizontalSpaceTiny,
              InsideOutText.bodyBold(
                "~" +
                    (HerculesWorldCreditSystem
                                .kDistanceInMeterToActivityMinuteConversion *
                            quest!.distanceMarkers!)
                        .toStringAsFixed(0) +
                    "min",
                color: textColor ?? kcGreyTextColor,
              ),
            ],
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            horizontalSpaceMedium,
            Image.asset(
              kPinInAreaIcon,
              height: 18,
              color: kcPrimaryColor,
            ),
            horizontalSpaceTiny,
            InsideOutText.bodyBold(
              (quest!.markers.length - 1).toString(),
              color: textColor ?? kcGreyTextColor,
            ),
          ],
        ),
      ],
    );
  }
}
