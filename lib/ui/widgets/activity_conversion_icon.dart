import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class OnboardingActivityConversionIcon extends StatelessWidget {
  const OnboardingActivityConversionIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 68,
      //color: Colors.red.withOpacity(0.4),
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
            alignment: Alignment.centerRight,
            child: Image.asset(
              kAFKCreditsLogoSmallPathColored,
              height: 24,
              color: kcPrimaryColor,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.arrow_right_alt, size: 20),
          ),
        ],
      ),
    );
  }
}
