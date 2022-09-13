import 'package:afkcredits_ui/afkcredits_ui.dart';

const String WarningQuestNotFinished = "Cancel Incomplete Quest?";

const String WarningScannedMarkerNotInQuest =
    "Scanned marker does not belong to quest.";

const String WarningNotNearbyMarker =
    "You are not close to the actual marker. ";

const String WarningScannedMarkerAlreadyCollected =
    "Your scanned marker has already been collected.";

const String WarningNoQuestsDownloaded = "No quests found in the area.";

String getShortQuestType(QuestType? type, {bool noCaps = false}) {
  String returnVal = "Unknown";
  if (type == null) return returnVal;
  if (type == QuestType.GPSAreaHike) {
    returnVal = "Hike";
  }
  if (type == QuestType.GPSAreaHunt) {
    returnVal = "Hike";
  }
  if (type == QuestType.TreasureLocationSearch) {
    returnVal = "Search Quest";
  }
  if (noCaps) {
    return returnVal.toLowerCase();
  } else {
    return returnVal;
  }
}
