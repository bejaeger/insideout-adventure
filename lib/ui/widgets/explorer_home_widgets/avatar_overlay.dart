import 'package:afkcredits/constants/asset_locations.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class AvatarOverlay extends StatelessWidget {
  // current level of avatar
  final int level;

  // percentage of reaching the next level
  final double percentage;

  // callback function to execute when avatar is pressed
  final void Function()? onPressed;

  // identifier of avatar icon
  final int avatarIdx;

  const AvatarOverlay(
      {Key? key,
      required this.level,
      required this.percentage,
      this.onPressed,
      required this.avatarIdx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.4),
              child: Avatar(
                avatarIdx: avatarIdx,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ProgressBar(
                widthProgressBar: 55,
                percentage: percentage,
              ),
            ),
            Align(
              alignment: Alignment(-0.8, 0.35),
              child: LevelIndicator(level: level),
            ),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final int avatarIdx;
  const Avatar({Key? key, required this.avatarIdx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        avatarIdx == 1 ? kLottieChillDudeHeadPng : kLottieWalkingGirlPng,
        height: 30);
  }
}

class ProgressBar extends StatelessWidget {
  final double percentage;
  final double widthProgressBar;
  final double height;
  final String? currentLevel;
  final String? nextLevel;
  const ProgressBar(
      {Key? key,
      required this.percentage,
      required this.widthProgressBar,
      this.currentLevel,
      this.nextLevel,
      this.height = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (currentLevel != null) InsideOutText.body(currentLevel!),
        if (currentLevel != null) horizontalSpaceSmall,
        Container(
          height: height,
          width: widthProgressBar,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: Alignment.center,
              height: height,
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                borderRadius: percentage < 0.9
                    ? BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0))
                    : BorderRadius.circular(20.0),
              ),
              width: percentage * widthProgressBar,
            ),
          ),
        ),
        if (nextLevel != null) horizontalSpaceSmall,
        if (nextLevel != null) InsideOutText.body(nextLevel!),
      ],
    );
  }
}

class LevelIndicator extends StatelessWidget {
  final int level;
  const LevelIndicator({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InsideOutText(
        text: level.toString(),
        style: heading3Style.copyWith(fontSize: 16),
      ),
    );
  }
}
