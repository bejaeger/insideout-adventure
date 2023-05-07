import 'package:afkcredits/constants/asset_locations.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/cupertino.dart';

class CreditsAmount extends StatelessWidget {
  final num amount;
  final String? amountString;
  final TextStyle? style;
  final Color color;
  final Color textColor;
  final double height;
  final double? spacing;
  const CreditsAmount(
      {Key? key,
      required this.amount,
      this.color = kcPrimaryColor,
      this.textColor = kcBlackHeadlineColor,
      this.height = 25,
      this.style,
      this.spacing,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child:
                Image.asset(kAFKCreditsLogoPath, color: color, height: height),
          ),
          SizedBox(width: spacing ?? 4.0),
          if (style != null)
            Text(amountString ?? amount.toStringAsFixed(0), style: style),
          if (style == null)
            InsideOutText(
              text: amountString ?? amount.toStringAsFixed(0),
              style: heading3Style.copyWith(
                  color: textColor, fontSize: height * 1.00),
            ),
        ],
      ),
    );
  }
}
