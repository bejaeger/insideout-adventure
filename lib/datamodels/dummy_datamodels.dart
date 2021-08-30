import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';

Quest getDummyQuest() {
  return Quest(
    id: "QuestDummyId",
    name: "Grouse Grind",
    description: "Make it up the hill in less than 1 hour",
    afkCredits: 100,
    markers: [
      getDummyMarker1(),
      getDummyMarker2(),
      getDummyMarker3(),
    ],
    type: QuestType.Hike,
    startMarker: getDummyMarker1(),
    finishMarker: getDummyMarker3(),
  );
}

Marker getDummyMarker1() {
  return Marker(id: "Marker1Id", qrCodeId: "QRCode2Id", lat: 49, lon: -122);
}

Marker getDummyMarker2() {
  return Marker(id: "Marker2Id", qrCodeId: "QRCode2Id", lat: 49.1, lon: -122);
}

Marker getDummyMarker3() {
  return Marker(id: "Marker3Id", qrCodeId: "QRCode3Id", lat: 49.2, lon: -122);
}
