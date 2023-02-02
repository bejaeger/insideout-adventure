import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/widgets/credits_to_screentime_widget.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/avatar_view.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
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
  final int avatarIdx;
  const MainHeader(
      {Key? key,
      this.onDevFeaturePressed,
      required this.onAvatarPressed,
      required this.show,
      required this.balance,
      this.onCreditsPressed,
      required this.currentLevel,
      required this.percentageOfNextLevel,
      required this.avatarIdx})
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
          height: 75,
          //color: Colors.blue.withOpacity(0.5),
          padding: const EdgeInsets.only(
              left: kHorizontalPadding, right: 10, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                //color: Colors.red,
                padding:
                    const EdgeInsets.only(right: 5.0, bottom: 5.0, left: 5.0),
                child: AvatarView(
                  percentage: percentageOfNextLevel,
                  level: currentLevel,
                  onPressed: onAvatarPressed,
                  avatarIdx: avatarIdx,
                ),
              ),
              //Spacer(),
              horizontalSpaceRegular,
              horizontalSpaceMedium,
              // if (onDevFeaturePressed != null)
              //   Opacity(
              //     opacity: 0.1,
              //     child: GestureDetector(
              //       onTap: onDevFeaturePressed,
              //       child: Container(
              //           alignment: Alignment.center,
              //           width: 40,
              //           height: 80,
              //           color: kcCultured,
              //           child: AfkCreditsText.captionBold(
              //             "Dev",
              //             align: TextAlign.center,
              //           )),
              //     ),
              //   ),
              // Spacer(),
              Expanded(
                child: GestureDetector(
                  onTap: onCreditsPressed,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: 15.0, top: 14, bottom: 5.0, left: 8.0),
                      //color: Colors.red,
                      child: CreditsToScreenTimeWidget(
                        credits: balance.toInt(),
                        availableScreenTime: creditsToScreenTime(balance),
                        // sizeScale: screenWidth(context) / 450,
                      ),
                      // child: AFKCreditsDisplay(balance: balance),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
