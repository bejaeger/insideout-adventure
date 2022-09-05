import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/afk_credits_display.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/avatar_view.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final bool show;
  final num balance;
  final int currentLevel;
  final double percentageOfNextLevel;
  final void Function()? onDevFeaturePressed;
  final void Function()? onAvatarPressed;
  final void Function()? onCreditsPressed;
  const MainHeader(
      {Key? key,
      this.onDevFeaturePressed,
      required this.onAvatarPressed,
      required this.show,
      required this.balance,
      this.onCreditsPressed,
      required this.currentLevel,
      required this.percentageOfNextLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //log.wtf("Rebuilding MainHeader");
    return IgnorePointer(
      ignoring: !show,
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Container(
          height: 70,
          //color: Colors.blue.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AvatarView(
                  percentage: percentageOfNextLevel,
                  level: currentLevel,
                  onPressed: onAvatarPressed),
              //Spacer(),
              horizontalSpaceSmall,
              Opacity(
                opacity: 0.1,
                child: GestureDetector(
                  onTap: onDevFeaturePressed,
                  child: Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 80,
                      color: kcCultured,
                      child: AfkCreditsText.captionBold(
                        "Dev Feature",
                        align: TextAlign.center,
                      )),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onCreditsPressed,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0, top: 14),
                  child: AFKCreditsDisplay(balance: balance),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
