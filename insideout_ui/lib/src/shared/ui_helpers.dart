import 'package:flutter/material.dart';
import 'package:insideout_ui/src/shared/app_colors.dart';
import 'package:insideout_ui/src/shared/layout.dart';

import '../enums/quest_type.dart';

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 18.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);
const Widget horizontalSpaceMassive = SizedBox(width: 120.0);

const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 18.0);
const Widget verticalSpaceMedium = SizedBox(height: 25.0);
const Widget verticalSpaceMediumLarge = SizedBox(height: 40.0);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);
const Widget verticalSpaceMassive = SizedBox(height: 120.0);

const double klHorizontalPadding = 20.0;

Widget spacedDivider = Column(
  children: const <Widget>[
    verticalSpaceMedium,
    Divider(color: Colors.blueGrey, height: 5.0),
    verticalSpaceMedium,
  ],
);
double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

Color getBkgColor(context) => Theme.of(context).backgroundColor;

Widget verticalSpace(double height) => SizedBox(height: height);

double screenWidth(BuildContext context, {double percentage = 1}) =>
    MediaQuery.of(context).size.width * percentage;

double screenHeight(BuildContext context, {double percentage = 1}) =>
    MediaQuery.of(context).size.height * percentage;

Size screenSize(BuildContext context) => MediaQuery.of(context).size;

isDesktop(BuildContext context) => MediaQuery.of(context).size.width > 600;
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

IconData getIconForCategory(QuestType? category) {
  if (category == null) return Icons.location_on;
  if (category == QuestType.DistanceEstimate) {
    return Icons.arrow_right_alt;
  } else if (category == QuestType.TreasureLocationSearch) {
    return Icons.search;
  } else if (category == QuestType.QRCodeHunt) {
    return Icons.pets;
  } else if (category == QuestType.QRCodeHike) {
    return Icons.nature_people;
  } else if (category == QuestType.GPSAreaHike ||
      category == QuestType.GPSAreaHike) {
    return Icons.explore;
  } else {
    return Icons.map;
  }
}

String getStringForCategory(QuestType? category) {
  if (category == null) return "";
  switch (category) {
    case QuestType.DistanceEstimate:
      return "Estimating Distance";
    case QuestType.TreasureLocationSearch:
      return "Search";
    case QuestType.QRCodeHunt:
      return "QR Code Hunt";
    case QuestType.GPSAreaHunt:
      return "Hike";
    case QuestType.QRCodeHike:
      return "QR Code Hike";
    case QuestType.GPSAreaHike:
      return "Hike";
    default:
      return "Default Quest";
  }
}

Color getColorOfType(QuestType? category) {
  if (category == null) return kcPrimaryColor;
  switch (category) {
    case QuestType.DistanceEstimate:
      return kcScreenTimeBlue;
    case QuestType.TreasureLocationSearch:
      return kcBlue;
    case QuestType.QRCodeHunt:
      return kcOrange;
    case QuestType.QRCodeHike:
      return kcOrange;
    case QuestType.GPSAreaHike:
      return kcOrangeOpaque;
    case QuestType.GPSAreaHunt:
      return kcOrangeOpaque;
    default:
      return kcPrimaryColor;
  }
}

Widget aboveBottomBackButton({required Widget child}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: kBottomBackButtonPadding),
      child: child,
    ),
  );
}
