import 'package:afkcredits/constants/asset_locations.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

// showing `Activity Icon -> Credits Icon`

class OnboardingActivityConversionIcon extends StatelessWidget {
  const OnboardingActivityConversionIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 68,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              kActivityIcon,
              height: 24,
              color: kcActivityIconColor,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.arrow_right_alt, size: 20),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              kInsideOutLogoSmallPathColored,
              height: 24,
              color: kcPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
