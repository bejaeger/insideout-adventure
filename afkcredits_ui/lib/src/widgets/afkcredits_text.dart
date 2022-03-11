import 'package:afkcredits_ui/src/shared/app_colors.dart';
import 'package:afkcredits_ui/src/shared/styles.dart';
import 'package:flutter/material.dart';

class AfkCreditsText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign alignment;

  const AfkCreditsText.headingOne(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading1Style,
        alignment = align;
  const AfkCreditsText.headingTwo(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading2Style,
        alignment = align;
  const AfkCreditsText.headingThree(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading3Style,
        alignment = align;

  const AfkCreditsText.headingLogin(this.text,
      {TextAlign align = TextAlign.left})
      : style = headingLogin,
        alignment = align;

  const AfkCreditsText.headline(this.text, {TextAlign align = TextAlign.start})
      : style = headlineStyle,
        alignment = align;
  const AfkCreditsText.subheading(this.text,
      {TextAlign align = TextAlign.start})
      : style = subheadingStyle,
        alignment = align;
  const AfkCreditsText.caption(this.text, {TextAlign align = TextAlign.start})
      : style = captionStyle,
        alignment = align;

  const AfkCreditsText.book(this.text, {TextAlign align = TextAlign.start})
      : style = bookStyle,
        alignment = align;

  AfkCreditsText.body(this.text,
      {Color color = kcMediumGreyColor, TextAlign align = TextAlign.start})
      : style = bodyStyleSofia.copyWith(color: color),
        alignment = align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: alignment,
    );
  }
}
