import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//
// For now this only provides a ripple effect that can be overlaid on the map
//

class MapEffects extends StatelessWidget {
  final ActivatedQuest activeQuest;
  const MapEffects({
    Key? key,
    required this.activeQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return activeQuest.quest.type == QuestType.TreasureLocationSearch
        ? Positioned(
            //alignment: Alignment(0, 0.4),
            bottom: 105,
            left: 2,
            right: 2,
            child: IgnorePointer(
              child: Lottie.asset(
                kLottieRippleEffect,
                height: 200,
                width: 200,
                frameRate: FrameRate.max,
              ),
            ),
          )
        : SizedBox(width: 0, height: 0);
  }
}
