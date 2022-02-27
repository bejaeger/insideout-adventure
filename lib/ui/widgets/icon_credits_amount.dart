import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/cupertino.dart';

class CreditsAmount extends StatelessWidget {
  final num amount;
  final String? amountString;

  final Color color;
  final double height;
  const CreditsAmount(
      {Key? key,
      required this.amount,
      this.color = kPrimaryColor,
      this.height = 25,
      this.amountString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(kAFKCreditsLogoPath, color: color),
          horizontalSpaceTiny,
          Text(
            amountString ?? amount.toStringAsFixed(0),
            style: textTheme(context).bodyText2!.copyWith(
                color: color, fontSize: 22, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
