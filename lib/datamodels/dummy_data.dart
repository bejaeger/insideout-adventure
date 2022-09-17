import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/quests/marker_note/marker_note.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Quest> getDummyQuests() {
  return [
    // starenWegNoListener(),
    // getZaehringenHike(),
    // getDummyVibrationSearchQuest(),
    // heidachTrohpy(),
    // manu(),
    // heidachTrohpy2(),
    // commercialTrophy(),
    // seeparkSpielplatz(),
    // getDummyVibrationSearchQuestHeuweiler(),
    // getQrCodeHuntJaeger(),
    getQrCodeHuntJaeger2(),
    // streeth11th2ndVibration(),
    // getDummyVibrationSearchQuestFreiburg(),
    getDummyQuest1(),
    getDummyVibrationSearchQuest(),
    getDistanceEstimate200(),
    getDistanceEstimate500(),
    getDistanceEstimate1000(),
    // getDistanceEstimate2000(),
    //getDummyQuest1(),
    getDummyQuest3(),
    // getDummyQuest5(),
    // getDummyQuest6(),
  ];
}

getDummyAchievements() {
  return [
    Achievement(id: "1", credits: 5, name: "Complete 1 quest", completed: true),
    Achievement(
        id: "1", credits: 10, name: "Complete 5 quests", completed: false),
    Achievement(
        id: "1",
        credits: 5,
        name: "Complete 2 quests on one day",
        completed: false),
    Achievement(
        id: "1", credits: 5, name: "Earn 200 credits", completed: false),
    Achievement(
        id: "1", credits: 5, name: "Claim 1 gift card", completed: false),
    Achievement(
        id: "1", credits: 10, name: "4 quests in one week", completed: false),
  ];
}

// TODO: Probably should introduce screen time category!?
List<ScreenTimeSession> getDummyScreenTimes({required String uid}) {
  return [
    ScreenTimeSession(
        sessionId: "",
        uid: uid,
        createdByUid: uid,
        userName: "DummyName",
        minutes: 30,
        status: ScreenTimeSessionStatus.active,
        afkCredits: 500),
  ];
}

// burnaby quest
Quest getDummyQuest1() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "D1qn76RJwqDlcbtcKaLm",
    name: "Grouse Grind",
    description: "Make it up the hill in less than 1 hour",
    afkCredits: 100,
    markers: [
      getDummyMarker1(),
      getDummyMarker2(),
      getDummyMarker3(),
      getDummyMarker4()
    ],
    type: QuestType.QRCodeHike,
    startMarker: getDummyMarker1(),
    finishMarker: getDummyMarker2(),
    location: geo.point(
      latitude: 49.32738998905981,
      longitude: -123.05923572987633,
    ),
  );
}

// Distance Estimate
Quest getDistanceEstimate200() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "sANrbvqSYZJX8IS1CCKL",
    name: "Distance Estimate 200m",
    description: "Estimate 200m",
    afkCredits: 20,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 200,
    location: geo.point(
      latitude: 49.32738998905994,
      longitude: -123.05923572987650,
    ),
  );
}

// Distance Estimate
Quest getDistanceEstimate500() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "E46GBs5XcGwGHeSmCMSh",
    name: "Distance Estimate 500m",
    description: "Estimate 500m",
    afkCredits: 20,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 500,
    location: geo.point(
      latitude: 49.32738998905999,
      longitude: -123.05923572987680,
    ),
  );
}

// Distance Estimate
Quest getDistanceEstimate1000() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "Sg9NFY1sReWmiL2t1Ks9",
    name: "Distance Estimate 1km",
    description: "Estimate 1km",
    afkCredits: 20,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 1000,
    location: geo.point(
      latitude: 49.32738998905336,
      longitude: -123.05923572987790,
    ),
  );
}

// Distance Estimate
Quest getDistanceEstimate2000() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "kFMNafSAwBJA8DKLX275",
    name: "Distance Estimate 2km",
    description: "Estimate 2km",
    afkCredits: 999999999,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 2000,
    location: geo.point(
      latitude: 49.32738998905336,
      longitude: -123.05923572987790,
    ),
  );
}

// burnaby quest
Quest getDummyVibrationSearchQuest() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "VibrationSearch",
    name: "Woodway Vibrations",
    description: "Find the AFK Credits",
    afkCredits: 10,
    markers: [
      woodwayInFrontMarker(),
      myRoomParkSiteMarker(),
    ],
    type: QuestType.TreasureLocationSearch,
    startMarker: woodwayInFrontMarker(),
    finishMarker: myRoomParkSiteMarker(),
    location: geo.point(
      latitude: 49.2673185626,
      longitude: -122.9901804,
    ),
  );
}

Quest getDummyVibrationSearchQuestFreiburg() {
  Geoflutterfire geo = Geoflutterfire();

  return Quest(
    id: "BYC9JvJaz64vMmyuV2Cc",
    name: "Freiburg Location Search",
    description: "Find the AFK Credits",
    afkCredits: 10,
    markers: [
      freiburg1(),
      freiburg2(),
    ],
    type: QuestType.TreasureLocationSearch,
    startMarker: freiburg1(),
    finishMarker: freiburg2(),
    location: geo.point(
      latitude: 48.01397259778941,
      longitude: 7.854593947833285,
    ),
  );
}

// burnaby quest
Quest streeth11th2ndVibration() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "aeyLAC1r0OsnA0IBj6uT",
    name: "10th Street Fun!",
    description: "Find the AFK Credits",
    afkCredits: 10,
    markers: [street11th2nd(), street11th2ndEnd()],
    type: QuestType.TreasureLocationSearch,
    startMarker: street11th2nd(),
    finishMarker: street11th2ndEnd(),
    location: geo.point(
      latitude: 49.22308671447031,
      longitude: -122.92246584976317,
    ),
  );
}

// burnaby quest
Quest heidachTrohpy() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "JxoJaX3QNKHmE8pTwIWl",
    name: "Finde den Schatz im Heidach",
    description:
        "Ein großer Schatz wurde im Heidach vergraben, kannst du ihn finden?",
    afkCredits: 30,
    markers: [heidach1(), heidach2()],
    type: QuestType.TreasureLocationSearch,
    startMarker: heidach1(),
    finishMarker: heidach2(),
    location: geo.point(
      latitude: 48.06808982011085,
      longitude: 7.905153161233762,
    ),
  );
}

// burnaby quest
Quest heidachTrohpy2() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "CIwxujQ9zSyu2ZFlvv7h",
    name: "Finde den Heidach 2 Schatz",
    description:
        "Ein großer Schatz wurde im Heidach vergraben, kannst du ihn finden?",
    afkCredits: 50,
    markers: [heidach3(), heidach4()],
    type: QuestType.TreasureLocationSearch,
    startMarker: heidach3(),
    finishMarker: heidach4(),
    location: geo.point(
      latitude: 48.068605211860955,
      longitude: 7.904684129866282,
    ),
  );
}

// Angola quest
Quest getDummyQuest2() {
  Geoflutterfire geo = Geoflutterfire();
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
    type: QuestType.QRCodeHike,
    startMarker: getDummyMarker5(),
    finishMarker: getDummyMarker9(),
    location: geo.point(
      latitude: -8.816743732957665,
      longitude: 13.241324424548074,
    ),
  );
}

// Angola quest
Quest getDummyQuest3() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "tagiVjLVAUr8r3fPMqba",
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
    type: QuestType.QRCodeHike,
    startMarker: woodwayMarker1(),
    finishMarker: woodwayMarker6(),
    location: geo.point(
      latitude: 49.267442,
      longitude: -122.990101,
    ),
  );
}

// Angola quest
Quest getDummyQuest4() {
  Geoflutterfire geo = Geoflutterfire();
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
    type: QuestType.QRCodeHike,
    startMarker: intimateWoodwayMarker1(),
    finishMarker: intimateWoodwayMarker4(),
    location: geo.point(
      latitude: 49.266586,
      longitude: -122.990129,
    ),
  );
}

Quest getQrCodeHuntJaeger() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "aHynXLPBE68rxe3Y083L",
    name: "Versteckter Schatz bei Jägers!",
    description: "Finde alle Codes im Hause Jägers!",
    afkCredits: 50,
    markerNotes: [
      MarkerNote(note: "Start"),
      MarkerNote(note: "In einem der Bäder"),
      MarkerNote(note: "Im Wohnzimmer"),
      MarkerNote(note: "Hinter einem Fernseher"),
      MarkerNote(note: "Im Kinderzimmer"),
      MarkerNote(note: "Draußen!"),
    ],
    markers: [
      starenweg1(),
      heidach4(),
      heidach3(),
      heidach2(),
      heidach1(),
      starenweg3(),
    ],
    // TODO: QRCodeHuntIndoor
    type: QuestType.QRCodeHunt,
    startMarker: starenweg1(),
    finishMarker: starenweg3(),
    location: geo.point(
      latitude: -8.816743732957665,
      longitude: 13.241324424548074,
    ),
  );
}

Quest getQrCodeHuntJaeger2() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "aHynXLPBE68rxe3Y083Lblubb",
    name: "Second treasure hunt",
    description: "Find hidden codes at Jaegers!",
    afkCredits: 50,
    markerNotes: [
      MarkerNote(note: "Start"),
      MarkerNote(note: "In einem der Bäder"),
      MarkerNote(note: "Was da los!"),
    ],
    markers: [
      heidach2(),
      heidach4(),
      starenweg1(),
    ],
    // TODO: QRCodeHuntIndoor
    type: QuestType.GPSAreaHunt,
    startMarker: heidach2(),
    finishMarker: starenweg1(),
    location: geo.point(
      latitude: 48.06701330843975,
      longitude: 7.903736956224777,
    ),
  );
}

// Quest getDummyQuestQrCodeSearchStarenweg() {
//   return Quest(
//     id: "elkHlNMiRLHsagfcATc3",
//     name: "Versteckte Schätze im Starenweg!",
//     description: "Finde alle Codes im Starenweg!",
//     afkCredits: 50,
//     markers: [
//       starenweg1(),
//       starenweg2(),
//       starenweg3(),
//     ],
//     // TODO: QRCodeHuntIndoor
//     type: QuestType.QRCodeSearch,
//     startMarker: starenweg1(),
//     finishMarker: starenweg3(),
//   );
// }

// Angola quest
Quest getDummyQuest5() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "LSwSs2c6ZtVKk23qyWxD",
    name: "Party at Mine!",
    description: "Come and test it",
    afkCredits: 100,
    markers: [
      myRoomMarker(),
    ],
    type: QuestType.QRCodeHike,
    startMarker: myRoomMarker(),
    finishMarker: myRoomMarker(),
    location: geo.point(latitude: 49.267408282, longitude: -122.9905778),
  );
}

Quest getDummyQuest6() {
  Geoflutterfire geo = Geoflutterfire();

  return Quest(
    id: "nJiVPrgw2jcGrxoABCBW",
    name: "Starenweg Hike!",
    description: "",
    afkCredits: 1,
    markers: [
      starenweg4(),
      heidach2(),
      heidach4(),
    ],
    type: QuestType.QRCodeHike,
    startMarker: starenweg4(),
    finishMarker: heidach4(),
    location: geo.point(
      latitude: 48.06831568327273,
      longitude: 7.904892787613575,
    ),
  );
}

Quest starenWegNoListener() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "nJiVPrgw2jcGrxoABCBW",
    name: "Starenweg Hike No Listener!",
    description: "",
    afkCredits: 1,
    markers: [
      heidach4(),
      heidach2(),
      starenweg4(),
    ],
    type: QuestType.GPSAreaHike,
    startMarker: heidach4(),
    finishMarker: starenweg4(),
    location: geo.point(
      latitude: 48.06814470824551,
      longitude: 7.906736569916654,
    ),
  );
}

Quest getZaehringenHike() {
  Geoflutterfire geo = Geoflutterfire();

  return Quest(
    id: "unknown",
    name: "Zähringen GPS Area Hike!",
    description: "",
    afkCredits: 5,
    markers: [
      freiburg1(),
      freiburg2(),
      freiburg3(),
    ],
    type: QuestType.GPSAreaHike,
    startMarker: freiburg1(),
    finishMarker: freiburg3(),
    location: geo.point(
      latitude: 48.01397259778941,
      longitude: 7.854593947833285,
    ),
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

AFKMarker intimateWoodwayMarker7() {
  return AFKMarker(
    id: "intimateWoodwayMarker7",
    qrCodeId: "intimateWoodwayMarker7",
    lat: 49.26703644791169,
    lon: -122.99101625330354,
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
      lat: 49.267408282,
      lon: -122.9905778);
}

AFKMarker woodwayInFrontMarker() {
  return AFKMarker(
      id: "woodwayInFrontMarker",
      qrCodeId: "woodwayInFrontMarker",
      lat: 49.2673185626,
      lon: -122.9901804);
}

AFKMarker myRoomParkSiteMarker() {
  return AFKMarker(
      id: "myRoomParkSiteMarker",
      qrCodeId: "myRoomParkSiteMarker",
      lat: 49.268019072977,
      lon: -122.9908816464);
}

AFKMarker street11th2nd() {
  return AFKMarker(
      id: "11th2nd",
      qrCodeId: "11th2nd",
      lat: 49.22308671447031,
      lon: -122.92246584976317);
}

AFKMarker street11th2ndEnd() {
  return AFKMarker(
      id: "street11th2ndEnd",
      qrCodeId: "street11th2ndEnd",
      lat: 49.22388203172556,
      lon: -122.92212046634603);
}

getDummyCoordinates() {
  return LatLng(49.267489, -122.990541);
}

AFKMarker buyLowOnFoods() {
  return AFKMarker(
      id: "lowonfoods",
      qrCodeId: "lowonfoods",
      lat: 49.26627169696727,
      lon: -122.97854513122365);
}

AFKMarker brentwood() {
  return AFKMarker(
      id: "brentwood",
      qrCodeId: "brentwood",
      lat: 49.26658976477327,
      lon: -123.00164076016931);
}

AFKMarker start1() {
  return AFKMarker(
      id: "start1",
      qrCodeId: "start1",
      lat: 49.266942346812016,
      lon: -122.99230178996156);
}

AFKMarker start2() {
  return AFKMarker(
      id: "start2",
      qrCodeId: "start2",
      lat: 49.26707714193788,
      lon: -122.99019351948672);
}

AFKMarker starenweg1() {
  return AFKMarker(
    id: "starenweg1",
    qrCodeId: "starenweg1",
    lat: 48.06831568327273,
    lon: 7.904692787613575,
  );
}

AFKMarker starenweg2() {
  return AFKMarker(
    id: "starenweg2",
    qrCodeId: "starenweg2",
    lat: 48.068320041351725,
    lon: 7.904803866026531,
  );
}

AFKMarker starenweg3() {
  return AFKMarker(
    id: "starenweg3",
    qrCodeId: "starenweg3",
    lat: 48.06831568327273,
    lon: 7.904792787613575,
  );
}

AFKMarker starenweg4() {
  return AFKMarker(
    id: "starenweg4",
    qrCodeId: "starenweg4",
    lat: 48.06831568327273,
    lon: 7.904892787613575,
  );
}

AFKMarker starenweg5() {
  return AFKMarker(
    id: "starenweg5",
    qrCodeId: "starenweg5",
    lat: 48.06831568327273,
    lon: 7.904892787613575,
  );
}

AFKMarker starenweg6() {
  return AFKMarker(
    id: "starenweg6",
    qrCodeId: "starenweg6",
    lat: 48.06831568327273,
    lon: 7.904892787613575,
  );
}

// AFKMarker starenweg6() {
//   return AFKMarker(
//     id: "starenweg6",
//     qrCodeId: "starenweg6",
//     lat: 48.06831568327273,
//     lon: 7.904892787613575,
//     nextLocationHint: "In einer Schublade im ersten OG");

// }

AFKMarker freiburg1() {
  return AFKMarker(
    id: "freiburg1",
    qrCodeId: "freiburg1",
    lat: 48.01397259778941,
    lon: 7.854593947833285,
  );
}

AFKMarker freiburg2() {
  return AFKMarker(
      id: "freiburg2",
      qrCodeId: "freiburg2",
      lat: 48.01694856856642,
      lon: 7.858700560921927);
}

AFKMarker freiburg3() {
  return AFKMarker(
      id: "freiburg3",
      qrCodeId: "freiburg3",
      lat: 48.01694856856642,
      lon: 7.851700560921927);
}

AFKMarker belek1() {
  return AFKMarker(
    id: "belek1",
    qrCodeId: "belek1",
    lat: 48.04959523177769,
    lon: 7.901375792193425,
  );
}

AFKMarker belek2() {
  return AFKMarker(
    id: "belek2",
    qrCodeId: "belek2",
    lat: 48.04959523177769,
    lon: 7.901375792193425,
  );
}

AFKMarker belek3() {
  return AFKMarker(
    id: "belek3",
    qrCodeId: "belek3",
    lat: 48.04959523177769,
    lon: 7.901375792193425,
  );
}

AFKMarker belek4() {
  return AFKMarker(
    id: "belek4",
    qrCodeId: "belek4",
    lat: 48.04959523177769,
    lon: 7.901375792193425,
  );
}

AFKMarker belek5() {
  return AFKMarker(
    id: "belek5",
    qrCodeId: "belek5",
    lat: 48.04959523177769,
    lon: 7.901375792193425,
  );
}

AFKMarker belekLocSearch1() {
  return AFKMarker(
    id: "belekLocSearch1",
    qrCodeId: "belekLocSearch1",
    lat: 48.050260829411386,
    lon: 7.9010928692091635,
  );
}

AFKMarker belekLocSearch() {
  return AFKMarker(
    id: "belekLocSearch",
    qrCodeId: "belekLocSearch",
    lat: 48.05194200805362,
    lon: 7.90323708024672,
  );
}

// burnaby quest
Quest getDummyVibrationSearchQuestHeuweiler() {
  Geoflutterfire geo = Geoflutterfire();

  return Quest(
    id: "860CQjbdDk0Pggj3NgBv",
    name: "Heuweiler Trophy Search!",
    description: "Find the Trophy Hidden in Heuweiler Best Town!",
    afkCredits: 30,
    markers: [
      belekLocSearch1(),
      belekLocSearch(),
    ],
    type: QuestType.TreasureLocationSearch,
    startMarker: belekLocSearch1(),
    finishMarker: belekLocSearch(),
    location: geo.point(
      latitude: 48.050260829411386,
      longitude: 7.9010928692091635,
    ),
  );
}

AFKMarker heidach1() {
  return AFKMarker(
    id: "heidach1",
    qrCodeId: "heidach1",
    lat: 48.06808982011085,
    lon: 7.905153161233762,
  );
}

AFKMarker heidach2() {
  return AFKMarker(
    id: "heidach2",
    qrCodeId: "heidach2",
    lat: 48.06701330843975,
    lon: 7.903736956224777,
  );
}

AFKMarker seepark1() {
  return AFKMarker(
    id: "seepark1",
    qrCodeId: "seepark1",
    lat: 48.012339128991236,
    lon: 7.823210791204063,
  );
}

AFKMarker seepark2() {
  return AFKMarker(
    id: "seepark2",
    qrCodeId: "seepark2",
    lat: 48.0087772794013,
    lon: 7.82192900039613,
  );
}

AFKMarker manu1() {
  return AFKMarker(
    id: "manu1",
    qrCodeId: "manu1",
    lat: 48.009741428013236,
    lon: 7.807971788403806,
  );
}

AFKMarker manu2() {
  return AFKMarker(
    id: "manu2",
    qrCodeId: "manu2",
    lat: 48.01085711811334,
    lon: 7.809597253462515,
  );
}

// TODO: Make second treasure hunt quest out of these!
AFKMarker heidach3() {
  return AFKMarker(
    id: "heidach3",
    qrCodeId: "heidach3",
    lat: 48.068605211860955,
    lon: 7.904684129866282,
  );
}

AFKMarker heidach4() {
  return AFKMarker(
    id: "heidach4",
    qrCodeId: "heidach4",
    lat: 48.06814470824551,
    lon: 7.906736569916654,
  );
}

Quest commercialTrophy() {
  Geoflutterfire geo = Geoflutterfire();
  return Quest(
    id: "Yz4HrA4AKxI2mHYmi4lt",
    name: "Find the biggest secret of commercial drive!",
    description:
        "Learn how to enjoy life by finding the treasure at commercial drive",
    afkCredits: 30,
    markers: [commercial1(), commercial2()],
    type: QuestType.TreasureLocationSearch,
    startMarker: commercial1(),
    finishMarker: commercial2(),
    location: geo.point(
      latitude: 49.273658969631974,
      longitude: -123.0705730554199,
    ),
  );
}

Quest seeparkSpielplatz() {
  Geoflutterfire geo = Geoflutterfire();

  return Quest(
    id: "Unknown",
    name: "Finde den Spielplatz!",
    description: "Im Seepark",
    afkCredits: 50,
    markers: [seepark1(), seepark2()],
    type: QuestType.TreasureLocationSearch,
    startMarker: seepark1(),
    finishMarker: seepark2(),
    location: geo.point(
      latitude: 48.012339128991236,
      longitude: 7.823210791204063,
    ),
  );
}

Quest manu() {
  Geoflutterfire geo = Geoflutterfire();

  return Quest(
    id: "Unknown",
    name: "Finde Manu!",
    description: "Im Seepark",
    afkCredits: 50,
    markers: [manu1(), manu2()],
    type: QuestType.TreasureLocationSearch,
    startMarker: manu1(),
    finishMarker: manu2(),
    location: geo.point(
      latitude: 48.01085711811334,
      longitude: 7.809597253462515,
    ),
  );
}

AFKMarker commercial1() {
  return AFKMarker(
    id: "commercial1",
    qrCodeId: "commercial1",
    lat: 49.273658969631974,
    lon: -123.0705730554199,
  );
}

AFKMarker commercial2() {
  return AFKMarker(
    id: "commercial2",
    qrCodeId: "commercial2",
    lat: 49.27631049183584,
    lon: -123.06956197567348,
  );
}

const double kTestLat = 48.06701330843975;
const double kTestLon = 7.903736956224777;
