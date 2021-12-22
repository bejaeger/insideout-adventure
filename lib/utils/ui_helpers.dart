import 'package:afkcredits/enums/quest_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 18.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);

const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 18.0);
const Widget verticalSpaceMedium = SizedBox(height: 25.0);
const Widget verticalSpaceMediumLarge = SizedBox(height: 40.0);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);
const Widget verticalSpaceMassive = SizedBox(height: 120.0);

Widget spacedDivider = Column(
  children: const <Widget>[
    verticalSpaceMedium,
    const Divider(color: Colors.blueGrey, height: 5.0),
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

String formatDate(DateTime timestamp) {
  return DateFormat.MMMEd().format(timestamp);
}

String formatDateDetails(DateTime timestamp) {
  return DateFormat.yMd().add_jm().format(timestamp);
}

IconData getIconForCategory(QuestType category) {
  switch (category) {
    case QuestType.DistanceEstimate:
      return Icons.arrow_right_alt;
    case QuestType.TreasureLocationSearch:
      return Icons.location_on;
    case QuestType.QRCodeSearchIndoor:
      return Icons.search_rounded;
    case QuestType.QRCodeHuntIndoor:
      return Icons.pets;
    case QuestType.Hike:
      return Icons.nature_people;
    default:
      return Icons.explore;
  }
}

String getStringForCategory(QuestType? category) {
  if (category == null) return "";
  switch (category) {
    case QuestType.DistanceEstimate:
      return "Estimating Distance";
    case QuestType.TreasureLocationSearch:
      return "Treasure Search";
    case QuestType.QRCodeSearchIndoor:
      return "QR Code Search";
    case QuestType.QRCodeHuntIndoor:
      return "Indoor QR Code Hunt";
    case QuestType.Hike:
      return "Hike";
    case QuestType.QRCodeSearch:
      return "QR Code Search";
    default:
      return "Default Quest";
  }
}

Color getColorOfType(QuestType type) {
  if (type == QuestType.TreasureLocationSearch)
    return Colors.orange;
  else if (type == QuestType.Hike) {
    return Colors.red;
  } else if (type == QuestType.DistanceEstimate) {
    return Colors.blue;
  } else if (type == QuestType.QRCodeSearch) {
    return Colors.green;
  } else {
    return Colors.cyan;
  }
}
