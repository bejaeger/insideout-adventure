
/* 
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
 */
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
}

Color getColorOfType(QuestType type) {
  if (type == QuestType.TreasureLocationSearch)
    return Colors.orange;
  else if (type == QuestType.QRCodeHike) {
    return Colors.red;
  } else if (type == QuestType.GPSAreaHike) {
    return Colors.green;
  } else if (type == QuestType.DistanceEstimate) {
    return Colors.blue;
  } else {
    return Colors.cyan;
  }
}
 */