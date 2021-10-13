import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';

// burnaby quest
Quest getDummyQuest1() {
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

// Angola quest
Quest getDummyQuest2() {
  return Quest(
    id: "QuestId02",
    name: "Angola Adventure",
    description: "Explore the coast of Angola",
    afkCredits: 100,
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
