import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';

List<Quest> getDummyQuests() {
  return [
    getDummyQuest1(),
    getDummyQuest3(),
    getDummyQuest4(),
    getDummyQuest2(),
    getDummyQuest5(),
  ];
}

// burnaby quest
Quest getDummyQuest1() {
  return Quest(
    id: "QuestId01",
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

// Angola quest
Quest getDummyQuest2() {
  return Quest(
    id: "QuestId02",
    name: "Angola Adventure",
    description: "Explore the coast of Angola",
    afkCredits: 900,
    markers: [
      getDummyMarker5(),
      getDummyMarker6(),
      getDummyMarker7(),
      getDummyMarker8(),
      getDummyMarker9()
    ],
    type: QuestType.Hike,
    startMarker: getDummyMarker5(),
    finishMarker: getDummyMarker9(),
  );
}

// Angola quest
Quest getDummyQuest3() {
  return Quest(
    id: "QuestId03",
    name: "Fun at Brentwood",
    description:
        "Whether it's long street or high street...you'll have the time of your life",
    afkCredits: 200,
    markers: [
      woodwayMarker1(),
      woodwayMarker2(),
      woodwayMarker3(),
      woodwayMarker4(),
      woodwayMarker5(),
      woodwayMarker6(),
    ],
    type: QuestType.Hike,
    startMarker: woodwayMarker1(),
    finishMarker: woodwayMarker6(),
  );
}

// Angola quest
Quest getDummyQuest4() {
  return Quest(
    id: "QuestId04",
    name: "Woodway Adventures",
    description: "Find the most precious hidden codes at Woodway",
    afkCredits: 50,
    markers: [
      intimateWoodwayMarker1(),
      intimateWoodwayMarker2(),
      intimateWoodwayMarker3(),
      intimateWoodwayMarker4(),
    ],
    type: QuestType.Hike,
    startMarker: intimateWoodwayMarker1(),
    finishMarker: intimateWoodwayMarker4(),
  );
}

// Angola quest
Quest getDummyQuest5() {
  return Quest(
    id: "My Room",
    name: "Party at Mine!",
    description: "Come and test it",
    afkCredits: 100,
    markers: [
      myRoomMarker(),
    ],
    type: QuestType.Hike,
    startMarker: myRoomMarker(),
    finishMarker: myRoomMarker(),
  );
}

/////////////////////////////////////
/// Markers in Burnaby
AFKMarker getDummyMarker1() {
  return AFKMarker(
    id: "9hJodek7hlwwUVl0VgzN",
    qrCodeId: "QRCode01Id",
    lat: 49.32738998905981,
    lon: -123.05923572987633,
  );
}

AFKMarker getDummyMarker2() {
  return AFKMarker(
    id: "nc9tNP2lSdzbjjC1p574",
    qrCodeId: "QRCode02Id",
    lat: 49.35738998905981,
    lon: -122.99023572987633,
  );
}

AFKMarker getDummyMarker3() {
  return AFKMarker(
    id: "Marker3Id",
    qrCodeId: "QRCode03Id",
    lat: 49.36738998905981,
    lon: -122.95023572987633,
  );
}

AFKMarker getDummyMarker4() {
  return AFKMarker(
    id: "Marker4Id",
    qrCodeId: "QRCode04Id",
    lat: 49.34738998905981,
    lon: -122.97023572987633,
  );
}

////////////////////////////////////////////
// Markers in Angola!

AFKMarker getDummyMarker5() {
  return AFKMarker(
      id: "Marker5Id",
      qrCodeId: "QRCode05Id",
      lat: -8.816743732957665,
      lon: 13.241324424548074);
}

AFKMarker getDummyMarker6() {
  return AFKMarker(
    id: "Marker6Id",
    qrCodeId: "QRCode06Id",
    lat: -8.815229378701293,
    lon: 13.237849838653474,
  );
}

AFKMarker getDummyMarker7() {
  return AFKMarker(
    id: "Marker7Id",
    qrCodeId: "QRCode07Id",
    lat: -8.818170008910567,
    lon: 13.312826089029407,
  );
}

AFKMarker getDummyMarker8() {
  return AFKMarker(
    id: "Marker8Id",
    qrCodeId: "QRCode08Id",
    lat: -8.816773720107985,
    lon: 13.236453935149965,
  );
}

AFKMarker getDummyMarker9() {
  return AFKMarker(
    id: "Marker9Id",
    qrCodeId: "QRCode09Id",
    lat: -8.823430807206417,
    lon: 13.239321606477823,
  );
}

////////////////////////////////////
/// Markers near woodway
AFKMarker woodwayMarker1() {
  return AFKMarker(
    id: "woodway1",
    qrCodeId: "woodway1",
    lat: 49.267442,
    lon: -122.990101,
  );
}

AFKMarker woodwayMarker2() {
  return AFKMarker(
    id: "woodway2",
    qrCodeId: "woodway2",
    lat: 49.267395,
    lon: -122.992182,
  );
}

AFKMarker woodwayMarker3() {
  return AFKMarker(
    id: "woodway3",
    qrCodeId: "woodway3",
    lat: 49.268429,
    lon: -122.997176,
  );
}

AFKMarker woodwayMarker4() {
  return AFKMarker(
    id: "woodway4",
    qrCodeId: "woodway4",
    lat: 49.268316,
    lon: -122.992263,
  );
}

AFKMarker woodwayMarker5() {
  return AFKMarker(
    id: "woodway5",
    qrCodeId: "woodway5",
    lat: 49.268033,
    lon: -123.003743,
  );
}

AFKMarker woodwayMarker6() {
  return AFKMarker(
    id: "woodway6",
    qrCodeId: "woodway6",
    lat: 49.266695,
    lon: -123.006713,
  );
}

AFKMarker intimateWoodwayMarker1() {
  return AFKMarker(
    id: "intimateWoodwayMarker1",
    qrCodeId: "intimateWoodwayMarker1",
    lat: 49.266586,
    lon: -122.990129,
  );
}

AFKMarker intimateWoodwayMarker2() {
  return AFKMarker(
    id: "intimateWoodwayMarker2",
    qrCodeId: "intimateWoodwayMarker2",
    lat: 49.266508,
    lon: -122.988709,
  );
}

AFKMarker intimateWoodwayMarker3() {
  return AFKMarker(
    id: "intimateWoodwayMarker3",
    qrCodeId: "intimateWoodwayMarker3",
    lat: 49.267229,
    lon: -122.989160,
  );
}

AFKMarker intimateWoodwayMarker4() {
  return AFKMarker(
      id: "intimateWoodwayMarker4",
      qrCodeId: "intimateWoodwayMarker4",
      lat: 49.267480,
      lon: -122.990532);
}

AFKMarker myRoomMarker() {
  return AFKMarker(
      id: "myRoomMarker",
      qrCodeId: "myRoomMarker",
      lat: 49.267489,
      lon: -122.990541);
}
