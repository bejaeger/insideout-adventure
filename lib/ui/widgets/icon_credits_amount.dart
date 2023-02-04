import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/cupertino.dart';

class CreditsAmount extends StatelessWidget {
  final num amount;
  final String? amountString;
  final TextStyle? style;
  final Color color;
  final Color textColor;
  final double height;
  const CreditsAmount(
      {Key? key,
      required this.amount,
      this.color = kcPrimaryColor,
      this.textColor = kcBlackHeadlineColor,
      this.height = 25,
      this.style,
      this.amountString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 22,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(kAFKCreditsLogoPath, color: color, height: height),
          SizedBox(width: 4.0),
          if (style != null)
            Text(amountString ?? amount.toStringAsFixed(0), style: style),
          if (style == null)
            AfkCreditsText(
              text: amountString ?? amount.toStringAsFixed(0),
              style: heading3Style.copyWith(
                  color: textColor, fontSize: height * 1.05),
            ),
        ],
      ),
    );
  }
}
