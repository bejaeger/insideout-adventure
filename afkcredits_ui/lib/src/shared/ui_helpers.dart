import 'package:flutter/material.dart';

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
/*
IconData getIconForCategory(QuestType category) {
  switch (category) {
    case QuestType.DistanceEstimate:
      return Icons.arrow_right_alt;
    case QuestType.TreasureLocationSearch:
      return Icons.location_on;
    case QuestType.QRCodeHunt:
      return Icons.pets;
    case QuestType.QRCodeHike:
      return Icons.nature_people;
    case QuestType.GPSAreaHike:
      return Icons.explore;
    default:
      return Icons.map;
  }
}
*/
IconData getIconForCategory(String? category) {
  if (category == QuestType.DistanceEstimate.toSimpleString()) {
    return Icons.arrow_right_alt;
  } else if (category == QuestType.TreasureLocationSearch.toSimpleString()) {
    return Icons.location_on;
  } else if (category == QuestType.QRCodeHunt.toSimpleString()) {
    return Icons.pets;
  } else if (category == QuestType.QRCodeHike.toSimpleString()) {
    return Icons.nature_people;
  } else if (category == QuestType.GPSAreaHike.toSimpleString()) {
    return Icons.explore;
  } else {
    return Icons.map;
  }
}

/* //Changed The Parameter from QuestType to String
String getStringForCategory(QuestType? category) {
  if (category == null) return "";
  switch (category) {
    case QuestType.DistanceEstimate:
      return "Estimating Distance";
    case QuestType.TreasureLocationSearch:
      return "Treasure Search";
    case QuestType.QRCodeHunt:
      return "QR Code Hunt";
    case QuestType.GPSAreaHunt:
      return "GPS Area Hunt";
    case QuestType.QRCodeHike:
      return "QR Code Hike";
    case QuestType.GPSAreaHike:
      return "GPS Area Hike";
    default:
      return "Default Quest";
  }
} */

String getStringForCategory(String? category) {
  if (category == null) return "";
  if (category == QuestType.DistanceEstimate.toSimpleString()) {
    return "Estimating Distance";
  } else if (category == QuestType.TreasureLocationSearch.toSimpleString()) {
    return "Treasure Search";
  } else if (category == QuestType.QRCodeHunt.toSimpleString()) {
    return "QR Code Hunt";
  } else if (category == QuestType.GPSAreaHunt.toSimpleString()) {
    return "GPS Area Hunt";
  } else if (category == QuestType.QRCodeHike.toSimpleString()) {
    return "QR Code Hike";
  } else if (category == QuestType.GPSAreaHike.toSimpleString()) {
    return "GPS Area Hike";
  } else {
    return "Default Quest";
  }
}

Color getColorOfType(String type) {
  if (type == QuestType.TreasureLocationSearch.toSimpleString()) {
    return Colors.orange;
  } else if (type == QuestType.QRCodeHike.toSimpleString()) {
    return Colors.red;
  } else if (type == QuestType.GPSAreaHike.toSimpleString()) {
    return Colors.green;
  } else if (type == QuestType.DistanceEstimate.toSimpleString()) {
    return Colors.blue;
  } else {
    return Colors.cyan;
  }
}
