import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

// TODO: Add real user information to this widget

class MainAvatarView extends StatelessWidget {
  // current level of avatar
  final int level;

  // percentage of reaching the next level
  final double percentage;

  // callback function to execute when avatar is pressed
  final void Function()? onPressed;

  const MainAvatarView(
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
            ProgressBar(
              maxWidth: 70,
              percentage: percentage,
            ),
            Align(
              alignment: Alignment(-0.75, 0.3),
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
    return Image.asset(kHerculesAvatar);
  }
}

class ProgressBar extends StatelessWidget {
  final double percentage;
  final double maxWidth;
  const ProgressBar(
      {Key? key, required this.percentage, required this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
              height: 10,
              width: maxWidth,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.0)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1, left: 6),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(4.0)),
              width: percentage * maxWidth,
            ),
          ),
        ),
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
