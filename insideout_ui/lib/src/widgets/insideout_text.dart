import 'package:flutter/material.dart';
import 'package:insideout_ui/src/shared/app_colors.dart';
import 'package:insideout_ui/src/shared/styles.dart';

class InsideOutText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? alignment;

  InsideOutText({required this.text, required this.style, this.alignment});

  const InsideOutText.headingOne(this.text, {TextAlign align = TextAlign.start})
      : style = heading1Style,
        alignment = align;
  const InsideOutText.headingTwo(this.text, {TextAlign align = TextAlign.start})
      : style = heading2Style,
        alignment = align;
  const InsideOutText.headingTwoLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading2LightStyle,
        alignment = align;
  const InsideOutText.headingThree(this.text,
      {TextAlign align = TextAlign.start, int? maxLines})
      : style = heading3Style,
        alignment = align;
  const InsideOutText.headingThreeLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading3LightStyle,
        alignment = align;
  const InsideOutText.headingFour(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading4Style,
        alignment = align;
  const InsideOutText.headingFourLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = heading4LightStyle,
        alignment = align;
  const InsideOutText.headingLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = headingLightStyle,
        alignment = align;
  const InsideOutText.warn(this.text, {TextAlign align = TextAlign.start})
      : style = warnStyle,
        alignment = align;
  const InsideOutText.screenTimeWarn(this.text,
      {TextAlign align = TextAlign.start})
      : style = warnScreenTimeStyle,
        alignment = align;
  const InsideOutText.alertThree(this.text, {TextAlign align = TextAlign.start})
      : style = alert3Style,
        alignment = align;
  const InsideOutText.successThree(this.text,
      {TextAlign align = TextAlign.start})
      : style = success3Style,
        alignment = align;

  const InsideOutText.headingLogin(this.text,
      {TextAlign align = TextAlign.left})
      : style = headingLogin,
        alignment = align;

  const InsideOutText.headline(this.text, {TextAlign align = TextAlign.start})
      : style = headlineStyle,
        alignment = align;
  const InsideOutText.subheading(this.text, {TextAlign align = TextAlign.start})
      : style = subheadingStyle,
        alignment = align;
  const InsideOutText.subheadingItalic(this.text,
      {TextAlign align = TextAlign.start})
      : style = subheadingStyleItalic,
        alignment = align;
  const InsideOutText.caption(this.text, {TextAlign align = TextAlign.start})
      : style = captionStyle,
        alignment = align;

  const InsideOutText.captionBold(this.text,
      {TextAlign align = TextAlign.start})
      : style = captionStyleBold,
        alignment = align;
  const InsideOutText.captionBoldRed(this.text,
      {TextAlign align = TextAlign.start})
      : style = captionStyleBoldRed,
        alignment = align;
  const InsideOutText.captionBoldLight(this.text,
      {TextAlign align = TextAlign.start})
      : style = captionStyleBoldLight,
        alignment = align;

  const InsideOutText.vertical(this.text, {TextAlign align = TextAlign.start})
      : style = verticalStyle,
        alignment = align;
  const InsideOutText.verticalTwo(this.text,
      {TextAlign align = TextAlign.start})
      : style = vertical2Style,
        alignment = align;

  const InsideOutText.book(this.text, {TextAlign? align})
      : style = bookStyle,
        alignment = align;

  const InsideOutText.label(this.text, {TextAlign align = TextAlign.start})
      : style = labelStyle,
        alignment = align;

  const InsideOutText.statsStyle(this.text, {TextAlign align = TextAlign.start})
      : style = statsStyle,
        alignment = align;
  const InsideOutText.statsStyleBlack(this.text,
      {TextAlign align = TextAlign.start})
      : style = statsStyleBlack,
        alignment = align;
  InsideOutText.tag(this.text,
      {TextAlign align = TextAlign.start, Color color = Colors.black87})
      : style = tagStyle.copyWith(color: color),
        alignment = align;
  const InsideOutText.button(this.text, {TextAlign? align})
      : style = buttonStyle,
        alignment = align;

  InsideOutText.body(this.text,
      {Color color = kcGreyTextColor, TextAlign? align})
      : style = bodyStyleSofia.copyWith(color: color),
        alignment = align;

  InsideOutText.bodyBold(this.text,
      {Color color = kcGreyTextColor, TextAlign? align})
      : style =
            bodyStyleSofia.copyWith(color: color, fontWeight: FontWeight.w600),
        alignment = align;

  InsideOutText.bodyItalic(this.text,
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
