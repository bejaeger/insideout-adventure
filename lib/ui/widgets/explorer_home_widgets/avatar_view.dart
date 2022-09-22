import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

// TODO: Add real user information to this widget

class AvatarView extends StatelessWidget {
  // current level of avatar
  final int level;

  // percentage of reaching the next level
  final double percentage;

  // callback function to execute when avatar is pressed
  final void Function()? onPressed;

  const AvatarView(
      {Key? key, required this.level, required this.percentage, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      //onDoubleTap: () => print("DOUBLE TAP!"),
      child: Container(
        width: 80,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Avatar(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ProgressBar(
                widthProgressBar: 70,
                percentage: percentage,
              ),
            ),
            Align(
              alignment: Alignment(-0.9, 0.3),
              child: LevelIndicator(level: level),
            ),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Image.asset(kHerculesAvatar);
    return Image.asset(kLottieChillDudeHeadPng, height: 39);
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
        if (currentLevel != null) AfkCreditsText.body(currentLevel!),
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
//                    borderRadius: BorderRadius.circular(20.0)
                ),
                width: percentage * widthProgressBar,
                child: (height > 19 && percentage > 0.24)
                    ? Text((percentage * 100).toStringAsFixed(0) + "%",
                        style: TextStyle(color: kcVeryLightGrey))
                    : null),
          ),
        ),
        if (nextLevel != null) horizontalSpaceSmall,
        if (nextLevel != null) AfkCreditsText.body(nextLevel!),
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
      child: AfkCreditsText.label(level.toString()),
    );
  }
}
