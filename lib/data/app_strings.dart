import 'package:insideout_ui/insideout_ui.dart';

// file that ultimately should hold all text appearing in the app

const String WarningQuestNotFinished = "Cancel Incomplete Quest?";

const String WarningScannedMarkerNotInQuest =
    "Scanned marker does not belong to quest.";

const String WarningNotNearbyMarker =
    "Try to walk to the center of a checkpoint.";

const String WarningScannedMarkerAlreadyCollected =
    "Marker has already been collected.";

const String WarningNoQuestsDownloaded = "No quests found in this area.";

const String WarningFirestoreCallTimeout = "Firestore call timed out";

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
    returnVal = "Search";
  }
  if (noCaps) {
    return returnVal.toLowerCase();
  } else {
    return returnVal;
  }
}
