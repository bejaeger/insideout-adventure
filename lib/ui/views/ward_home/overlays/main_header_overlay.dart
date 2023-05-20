import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/ui/widgets/credits_to_screentime_widget.dart';
import 'package:afkcredits/ui/widgets/ward_home_widgets/avatar_overlay.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class MainHeaderOverlay extends StatelessWidget {
  final bool show;
  final num balance;
  final int currentLevel;
  final double percentageOfNextLevel;
  final void Function()? onDevFeaturePressed;
  final void Function()? onAvatarPressed;
  final void Function()? onCreditsPressed;
  final int avatarIdx;
  const MainHeaderOverlay(
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
                child: AvatarOverlay(
                  percentage: percentageOfNextLevel,
                  level: currentLevel,
                  onPressed: onAvatarPressed,
                  avatarIdx: avatarIdx,
                ),
              ),
              //Spacer(),
              horizontalSpaceRegular,
              horizontalSpaceMedium,
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
                        availableScreenTime:
                            HerculesWorldCreditSystem.creditsToScreenTime(
                                balance),
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
