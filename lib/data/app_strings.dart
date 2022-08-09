import 'package:afkcredits_ui/afkcredits_ui.dart';

const String WarningQuestNotFinished = "Cancel Incomplete Quest?";

const String WarningScannedMarkerNotInQuest =
    "Scanned marker does not belong to quest.";

const String WarningNotNearbyMarker =
    "You are not close to the actual marker. ";

const String WarningScannedMarkerAlreadyCollected =
    "Your scanned marker has already been collected.";

String getShortQuestType(QuestType? type) {
  if (type == null) return "Unknown";
  if (type == QuestType.GPSAreaHike) {
    return "Hike";
  }
  if (type == QuestType.GPSAreaHunt) {
    return "Hike";
  }
  if (type == QuestType.TreasureLocationSearch) {
    return "Search Quest";
  }
  return "Unknown";
}
