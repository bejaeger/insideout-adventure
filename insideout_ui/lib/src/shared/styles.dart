import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

// Text Styles

// To make it clear which weight we are using, we'll define the weight even for regular
// fonts
const TextStyle heading1Style = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w400,
);

const TextStyle heading2Style = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w600,
  //overflow: TextOverflow.ellipsis,
);
const TextStyle heading2LightStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w600,
  color: kcMediumGrey,
);
const TextStyle heading3Style =
    TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
const TextStyle heading3LightStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: kcMediumGrey);
const TextStyle heading4Style = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600, color: kcPrimaryColorSecondary);
const TextStyle heading4LightStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kcMediumGrey);
const TextStyle headingLightStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  color: kcMediumGrey,
);

const TextStyle alert3Style = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: kcPrimaryColor,
);
const TextStyle warnStyle = TextStyle(
  // fontSize: 24,
  fontWeight: FontWeight.w600,
  color: kcRed,
);
const TextStyle warnScreenTimeStyle = TextStyle(
  // fontSize: 24,
  fontWeight: FontWeight.w600,
  color: kcScreenTimeBlue,
);
const TextStyle success3Style = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: Colors.green,
);
const TextStyle headingLogin = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w300,
);

const TextStyle headlineStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
);

const TextStyle bodyStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);
const TextStyle bodyStyleSofia = TextStyle(
    //fontFamily: "Sofia",
    //fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: kcGreyTextColor);
const TextStyle subheadingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
);
const TextStyle subheadingStyleItalic = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.italic,
);

const TextStyle captionStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: kcGreyTextColor,
  //overflow: TextOverflow.ellipsis,
);
const TextStyle captionStyleBold = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: kcGreyTextColor,
  overflow: TextOverflow.ellipsis,
);
const TextStyle captionStyleBoldRed = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: kcRed,
  overflow: TextOverflow.ellipsis,
);
const TextStyle captionStyleBoldLight = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Color.fromARGB(255, 117, 117, 117),
);
const TextStyle verticalStyle = TextStyle(
  fontSize: 12,
  height: 1.1,
  color: kcOrange,
  fontWeight: FontWeight.w800,
);
const TextStyle vertical2Style = TextStyle(
  fontSize: 12,
  height: 0.95,
  color: Colors.orange,
  fontWeight: FontWeight.w800,
);

const TextStyle bookStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kcOrange,
);
const TextStyle labelStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800);

const TextStyle statsStyle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600, color: kcGreyTextColorSoft);
const TextStyle statsStyleBlack =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87);

const TextStyle tagStyle =
    TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black87);

const TextStyle buttonStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);

// Text Variables
const TextStyle buttonTitleTextStyle =
    TextStyle(fontWeight: FontWeight.w700, color: Colors.white);
// TextStyle
const TextStyle ktsMediumGreyBodyText =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0);

const TextStyle kcMediumBody = TextStyle(
    fontFamily: "Sofia",
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.orange);
const TextStyle kcTextProfileBody = TextStyle(
    color: Colors.black,
    fontFamily: "Sofia",
    fontWeight: FontWeight.bold,
    fontSize: 16.0);
// colors

const TextStyle kcBottomNav =
    TextStyle(fontFamily: "Sofia", letterSpacing: 0.5);

const TextStyle ktMediumBody = TextStyle(
    fontFamily: "Sofia",
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: Colors.orange);
const TextStyle kcValidationMessage = TextStyle(
  color: Colors.red,
  fontSize: 15.0,
);

const TextStyle kcProductNameBody = TextStyle(
    fontFamily: "Sofia",
    fontWeight: FontWeight.w600,
    fontSize: 17.0,
    color: Colors.black87);
// TextStyle

const TextStyle kcLocation = TextStyle(
    fontFamily: "Sofia",
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    color: Colors.black26);

const TextStyle kcAppBar =
    TextStyle(fontFamily: "Sofia", fontSize: 19.0, fontWeight: FontWeight.w700);

// Font Sizing
const double kBodyTextSize = 16;
