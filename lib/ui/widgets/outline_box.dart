import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class OutlineBox extends StatelessWidget {
  final String? text;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final double borderWidth;
  final void Function()? onPressed;
  const OutlineBox(
      {Key? key,
      this.width,
      this.height,
      this.text,
      this.onPressed,
      this.color,
      this.textColor,
      this.borderWidth = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!, width: borderWidth),
          borderRadius: BorderRadius.circular(15.0),
          color: color,
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 0.5,
              color: kShadowColor,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: SizedBox.expand(
          child: text != null
              ? Center(
                  child: AfkCreditsText.body(text!,
                      align: TextAlign.center,
                      color: textColor ?? kBlackHeadlineColor))
              : SizedBox.expand(),
        ),
      ),
    );
  }
}
