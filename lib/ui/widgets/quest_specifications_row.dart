import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class QuestSpecificationsRow extends StatelessWidget {
  const QuestSpecificationsRow({
    Key? key,
    required this.quest,
  }) : super(key: key);

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
              // AfkCreditsText.headingThreeLight("  -  "),
              Image.asset(
                kWalkingIcon,
                height: 18,
                color: kcOrange,
              ),
              horizontalSpaceTiny,
              AfkCreditsText.bodyBold(
                "~" +
                    (HerculesWorldCreditSystem
                                .kSimpleDistanceMarkersToDistanceWalkScaling *
                            quest!.distanceMarkers!)
                        .toStringAsFixed(0) +
                    "m",
                //color: kcOrange,
              ),
            ],
          ),
        if (quest!.distanceMarkers != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AfkCreditsText.headingThreeLight("  -  "),
              Icon(
                Icons.schedule,
                size: 20,
                color: kcScreenTimeBlue,
              ),
              horizontalSpaceTiny,
              AfkCreditsText.bodyBold(
                "~" +
                    (HerculesWorldCreditSystem
                                .kDistanceInMeterToActivityMinuteConversion *
                            quest!.distanceMarkers!)
                        .toStringAsFixed(0) +
                    "min",
                //color: kcScreenTimeBlue,
              ),
            ],
          )
      ],
    );
  }
}
