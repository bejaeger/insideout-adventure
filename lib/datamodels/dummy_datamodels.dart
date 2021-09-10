import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';

Quest getDummyQuest() {
  return Quest(
    id: "QuestId02",
    name: "Grouse Grind",
    description: "Make it up the hill in less than 1 hour",
    afkCredits: 100,
    markers: [
      getDummyMarker1(),
      getDummyMarker2(),
      getDummyMarker3(),
      getDummyMarker4()
    ],
    type: QuestType.Hike,
    startMarker: getDummyMarker1(),
    finishMarker: getDummyMarker2(),
  );
}

Markers getDummyMarker1() {
  return Markers(
      id: "9hJodek7hlwwUVl0VgzN",
      qrCodeId: "QRCode01Id",
      lat: 37.487846,
      lon: -122.236115,
      questId: 'QuestId');
}

Markers getDummyMarker2() {
  return Markers(
      id: "nc9tNP2lSdzbjjC1p574",
      qrCodeId: "QRCode02Id",
      lat: 37.75675,
      lon: -122.45027,
      questId: 'QuestId01');
}

Markers getDummyMarker3() {
  return Markers(
      id: "Marker3Id",
      qrCodeId: "QRCode03Id",
      lat: 37.4219983,
      lon: -122.084,
      questId: 'QuestId02');
}

Markers getDummyMarker4() {
  return Markers(
      id: "Marker4Id",
      qrCodeId: "QRCode04Id",
      lat: 37.4636,
      lon: -122.4286,
      questId: 'QuestId04');
}
