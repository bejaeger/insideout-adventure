import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const AchievementCard({Key? key, required this.achievement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Flexible(
                      //heightFactor: 0.6,
                      child: Icon(Icons.trip_origin_sharp,
                          size: 50, color: Colors.orange.shade400)),
                  verticalSpaceSmall,
                  Text(achievement.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (!achievement.completed)
              Container(
                color: Colors.grey.withOpacity(0.5),
              ),
            achievement.completed
                ? Banner(
                    message: "UNLOCKED",
                    location: BannerLocation.topStart,
                    color: Colors.green)
                : Banner(message: "LOCKED", location: BannerLocation.topStart),
          ],
        ),
      ),
    );
  }
}
