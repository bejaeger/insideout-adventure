import 'package:afkcredits_ui/src/shared/app_colors.dart';
import 'package:afkcredits_ui/src/shared/styles.dart';
import 'package:flutter/material.dart';

class AfkCreditsText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? alignment;

  AfkCreditsText({required this.text, required this.style, this.alignment});

  const AfkCreditsText.headingOne(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading1Style,
        alignment = align;
  const AfkCreditsText.headingTwo(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading2Style,
        alignment = align;
  const AfkCreditsText.headingTwoLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading2LightStyle,
        alignment = align;
  const AfkCreditsText.headingThree(this.text,
      {TextAlign align = TextAlign.start, int? maxLines})
      : style = heading3Style,
        alignment = align;
  const AfkCreditsText.headingThreeLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading3LightStyle,
        alignment = align;
  const AfkCreditsText.headingFour(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading4Style,
        alignment = align;
  const AfkCreditsText.headingFourLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading4LightStyle,
        alignment = align;
  const AfkCreditsText.headingLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = headingLightStyle,
        alignment = align;
  const AfkCreditsText.warn(this.text, {TextAlign align = TextAlign.start})
      : style = warnStyle,
        alignment = align;
  const AfkCreditsText.alertThree(this.text,
      {TextAlign align = TextAlign.start})
      : style = alert3Style,
        alignment = align;
  const AfkCreditsText.successThree(this.text,
      {TextAlign align = TextAlign.start})
      : style = success3Style,
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
  const AfkCreditsText.subheadingItalic(this.text,
      {TextAlign align = TextAlign.start})
      : style = subheadingStyleItalic,
        alignment = align;
  const AfkCreditsText.caption(this.text, {TextAlign align = TextAlign.start})
      : style = captionStyle,
        alignment = align;

  const AfkCreditsText.captionBold(this.text,
      {TextAlign align = TextAlign.start})
      : style = captionStyleBold,
        alignment = align;
  const AfkCreditsText.captionBoldRed(this.text,
      {TextAlign align = TextAlign.start})
      : style = captionStyleBoldRed,
        alignment = align;
  const AfkCreditsText.captionBoldLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = captionStyleBoldLight,
        alignment = align;

  const AfkCreditsText.vertical(this.text, {TextAlign align = TextAlign.start})
      : style = verticalStyle,
        alignment = align;
  const AfkCreditsText.verticalTwo(this.text,
      {TextAlign align = TextAlign.start})
      : style = vertical2Style,
        alignment = align;

  const AfkCreditsText.book(this.text, {TextAlign? align})
      : style = bookStyle,
        alignment = align;

  const AfkCreditsText.label(this.text, {TextAlign align = TextAlign.start})
      : style = labelStyle,
        alignment = align;

  const AfkCreditsText.statsStyle(this.text,
      {TextAlign align = TextAlign.start})
      : style = statsStyle,
        alignment = align;
  const AfkCreditsText.statsStyleBlack(this.text,
      {TextAlign align = TextAlign.start})
      : style = statsStyleBlack,
        alignment = align;
  AfkCreditsText.tag(this.text,
      {TextAlign align = TextAlign.start, Color color = Colors.black87})
      : style = tagStyle.copyWith(color: color),
        alignment = align;
  const AfkCreditsText.button(this.text, {TextAlign? align})
      : style = buttonStyle,
        alignment = align;

  AfkCreditsText.body(this.text,
      {Color color = kcGreyTextColor, TextAlign? align})
      : style = bodyStyleSofia.copyWith(color: color),
        alignment = align;

  AfkCreditsText.bodyBold(this.text,
      {Color color = kcGreyTextColor, TextAlign? align})
      : style =
            bodyStyleSofia.copyWith(color: color, fontWeight: FontWeight.w600),
        alignment = align;

  AfkCreditsText.bodyItalic(this.text,
      {Color color = kcGreyTextColor, TextAlign? align})
      : style =
            bodyStyleSofia.copyWith(color: color, fontStyle: FontStyle.italic),
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
