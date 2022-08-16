import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class AFKCreditsDisplay extends StatelessWidget {
  // AFK credits balance
  final num balance;

  // callback function to execute when avatar is pressed
  final void Function()? onPressed;

  const AFKCreditsDisplay({Key? key, required this.balance, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Hero(
            tag: "CREDITS",
            child: Image.asset(kAFKCreditsLogoPath,
                height: 30, color: kcPrimaryColor),
          ),
          horizontalSpaceTiny,
          AfkCreditsText.label(balance.toStringAsFixed(0)),
        ],
      ),
    );
  }
}
