import 'package:flutter/material.dart';

const Color kcPrimaryColor = kcInfoGraphicGreen; // kcActivityColor;
// Color(0xff22A45D);
const Color kcMediumGreyColor = Color(0xff868686);
const Color kcLightGreyColor = Color(0xffe5e5e5);
const Color kcVeryLightGreyColor = Color(0xfff2f2f2);
const Color kcRedColor = Color(0xfff44336);
const Color kcOrangeColor = Color(0xffff9800);
const Color kcOrangeColorOpaque = Color(0xffEEEEEE);
//  Color.fromARGB(255, 251, 238, 217);

// kcInfoGraphicLightOrange;
// Color.fromARGB(255, 251, 238, 217);

const Color kGreyTextColor = Color(0xFF424242);

const Color kcScreenTimeBlueOpaque = Color.fromARGB(100, 148, 184, 219);
const Color kcActivityColorOpaque = Color.fromARGB(100, 82, 183, 128);

const Color kcScreenTimeBlue = Color.fromARGB(255, 103, 153, 203);
const Color kcActivityColor = kcInfoGraphicYellow; // kcInfoGraphicGreen;
//  Color.fromARGB(255, 67, 183, 119);
const Color kcAccentuatedGreen = Color.fromARGB(255, 67, 183, 119);

const Color kcInfoGraphicOrange = Color(0xffbc6d24);
const Color kcInfoGraphicYellow = Color(0xfff0cb2b);
const Color kcInfoGraphicGreen = Color(0xff709775);
const Color kcInfoGraphicBlue = Color(0xff2a3d48);
const Color kcInfoGraphicLightOrange = Color(0xffe8e1d3);

class ColorSettings extends MyColors {
  static const Color primaryColor = MyColors.primaryRed2;
  static const Color primaryColorLight = MyColors.lightRed2;
  static const Color primaryColorDark = MyColors.darkRed2;

  static Color? whiteTextColor = MyColors.almostWhiteGrey;
  static Color? greyTextColor = MyColors.darkGrey;
  static Color? lightGreyTextColor = MyColors.lightGrey;
  static Color? blackTextColor = MyColors.darkGrey;
  static Color blackHeadlineColor = MyColors.black87;
  static Color qrCodeOnWalletColor = MyColors.almostWhite;
}

class MyColors {
  static const Color almostWhite = Colors.white70;
  static Color? almostWhiteGrey = Colors.grey[200];
  static const Color grey = Colors.grey;
  static const Color black54 = Colors.black54;
  static const Color black87 = Colors.black87;
  static Color? darkGrey = Colors.grey[800];
  static Color? lightGrey = Colors.grey[600];

  // @see https://material.io/resources/color/#!/?view.left=0&view.right=1&primary.color=941305
  static const Color primaryRed = Color(0xFF941305);
  static const Color lightRed = Color(0xFFcc492f);
  static const Color darkRed = Color(0xFF600000);

  // @see https://material.io/resources/color/#!/?view.left=0&view.right=1&primary.color=941305
  static const Color primaryRed2 = Color(0xFFc53929);
  static const Color lightRed2 = Color(0xFFfe6b53);
  static const Color darkRed2 = Color(0xFF8d0000);
  static const Color paletteGreen2 = Color(0xFF059413);

  // @see https://colorpalettes.net/color-palette-1849/
  static const Color paletteBlue = Color(0xFF145b9c);
  static const Color paletteBlack = Color(0xFF030303);
  static const Color paletteGrey = Color(0xFF747d90);
  static const Color paletteGreen = Color(0xFF008301);

  // @see https://material.io/design/color/the-color-system.html#tools-for-picking-colors
  static const Color paletteTurquoise = Color(0xFF149c9a);
  static const Color palettePurple = Color(0xFF7653c9);

  static const Color gold = Color(0xFFfc8a00);
  static const Color softRed = Color(0xFFff5f37);
}
