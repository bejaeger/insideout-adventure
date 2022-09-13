import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class OnboardingScreenTimeConversionIcon extends StatelessWidget {
  const OnboardingScreenTimeConversionIcon({
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
              kAFKCreditsLogoSmallPathColored,
              height: 24,
              color: kcPrimaryColor,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              kScreenTimeIcon,
              height: 24,
              color: kcScreenTimeBlue,
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
