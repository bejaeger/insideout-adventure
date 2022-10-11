import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class ScreenTimeNotificationsNote extends StatelessWidget {
  const ScreenTimeNotificationsNote({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      //color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Icon(Icons.alarm_on_outlined,
          //     size: 80, color: kcScreenTimeBlue),
          // TODO: Add these notes also to active screen
          // TODO: time when in parents account
          verticalSpaceLarge,
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.alarm_on_outlined,
                    color: kcScreenTimeBlue, size: 45),
                horizontalSpaceSmall,
                Flexible(
                  child: AfkCreditsText.subheading(
                    "We will notify you once the screen time is over",
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: kcPrimaryColor, size: 45),
                horizontalSpaceSmall,
                Flexible(
                  child: AfkCreditsText.subheading(
                    "Make sure your sound or vibration is turned on",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}