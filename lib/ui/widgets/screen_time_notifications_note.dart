import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpaceLarge,
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.alarm_on_outlined,
                    color: kcScreenTimeBlue, size: 40),
                horizontalSpaceSmall,
                Flexible(
                  child: InsideOutText.subheading(
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
                    color: kcPrimaryColor, size: 40),
                horizontalSpaceSmall,
                Flexible(
                  child: InsideOutText.subheading(
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
