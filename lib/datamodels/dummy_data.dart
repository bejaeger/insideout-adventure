import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Quest> getDummyQuests() {
  return [
    getDummyVibrationSearchQuest(),

    heidachTrohpy(),
    commercialTrophy(),
    //getDummyVibrationSearchQuest2(),
    // getDummyQuestQrCodeSearch(),
    getDummyVibrationSearchQuestHeuweiler(),
    getQrCodeHuntJaeger(),
    getDummyQuestQrCodeHuntBelek(),
    getDummyQuestQrCodeSearchStarenweg(),
    streeth11th2ndVibration(),
    getDummyVibrationSearchQuestFreiburg(),
    //getDummyVibrationSearchQuest4(),
    getDistanceEstimate200(),
    getDistanceEstimate500(),
    getDistanceEstimate1000(),
    getDistanceEstimate2000(),
    getDummyQuest1(),
    getDummyQuest3(),
    // getDummyQuest4(),
    // getDummyQuest2(),
    getDummyQuest5(),
    getDummyQuest6(),
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

// Distance Estimate
Quest getDistanceEstimate200() {
  return Quest(
    id: "Distance Estimate 200",
    name: "Distance Estimate 200m",
    description: "Estimate 200m",
    afkCredits: 20,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 200,
  );
}

// Distance Estimate
Quest getDistanceEstimate500() {
  return Quest(
    id: "Distance Estimate 500",
    name: "Distance Estimate 500m",
    description: "Estimate 500m",
    afkCredits: 20,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 500,
  );
}

// Distance Estimate
Quest getDistanceEstimate1000() {
  return Quest(
    id: "Distance Estimate 1km",
    name: "Distance Estimate 1km",
    description: "Estimate 1km",
    afkCredits: 20,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 1000,
  );
}

// Distance Estimate
Quest getDistanceEstimate2000() {
  return Quest(
    id: "Distance Estimate 2km",
    name: "Distance Estimate 2km",
    description: "Estimate 2km",
    afkCredits: 999999999,
    markers: [],
    type: QuestType.DistanceEstimate,
    distanceToTravelInMeter: 2000,
  );
}

// burnaby quest
Quest getDummyVibrationSearchQuest() {
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
  );
}

// burnaby quest
Quest getDummyVibrationSearchQuest2() {
  return Quest(
    id: "VibrationSearch 2",
    name: "Woodway Vibrations Nr. 2",
    description: "Find the AFK Credits",
    afkCredits: 10,
    markers: [
      intimateWoodwayMarker7(),
      intimateWoodwayMarker3(),
    ],
    type: QuestType.TreasureLocationSearchAutomatic,
    startMarker: intimateWoodwayMarker7(),
    finishMarker: intimateWoodwayMarker3(),
  );
}

Quest getDummyVibrationSearchQuestFreiburg() {
  return Quest(
    id: "FreiburgLocationSearch",
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
  );
}

Quest getDummyVibrationSearchQuest4() {
  return Quest(
    id: "VibrationSearch 4",
    name: "Brentwood Vibrations",
    description: "Find the AFK Credits",
    afkCredits: 10,
    markers: [
      start1(),
      brentwood(),
    ],
    type: QuestType.TreasureLocationSearchAutomatic,
    startMarker: start1(),
    finishMarker: brentwood(),
  );
}

// burnaby quest
Quest streeth11th2ndVibration() {
  return Quest(
      id: "VibrationSearch at 11th and 2nd",
      name: "10th Street Fun!",
      description: "Find the AFK Credits",
      afkCredits: 10,
      markers: [street11th2nd(), street11th2ndEnd()],
      type: QuestType.TreasureLocationSearch,
      startMarker: street11th2nd(),
      finishMarker: street11th2ndEnd());
}

// burnaby quest
Quest heidachTrohpy() {
  return Quest(
      id: "heidach trophy",
      name: "Finde den Schatz im Heidach",
      description:
          "Ein großer Schatz wurde im Heidach vergraben, kannst du ihn finden?",
      afkCredits: 30,
      markers: [heidach1(), heidach2()],
      type: QuestType.TreasureLocationSearch,
      startMarker: heidach1(),
      finishMarker: heidach2());
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

Quest getDummyQuestQrCodeSearch() {
  return Quest(
    id: "QuestIdQrCodeSearch",
    name: "Search For Codes at Woodway",
    description: "Find hidden codes at Woodway place",
    afkCredits: 50,
    markers: [
      intimateWoodwayMarker2(),
      intimateWoodwayMarker3(),
      intimateWoodwayMarker4(),
    ],
    type: QuestType.QRCodeSearch,
    startMarker: intimateWoodwayMarker2(),
    finishMarker: intimateWoodwayMarker4(),
  );
}

Quest getQrCodeHuntJaeger() {
  return Quest(
    id: "Starenweg Hunt",
    name: "Versteckter Schatz bei Jägers!",
    description: "Finde alle Codes im Hause Jägers!",
    afkCredits: 50,
    markers: [
      starenweg1(),
      starenweg2(),
      starenweg3(),
      starenweg4(),
      starenweg5(),
      starenweg6(),
    ],
    // TODO: QRCodeHuntIndoor
    type: QuestType.QRCodeHuntIndoor,
    startMarker: starenweg1(),
    finishMarker: starenweg6(),
  );
}

Quest getDummyQuestQrCodeHuntBelek() {
  return Quest(
    id: "Belek Hunt",
    name: "Versteckter Schatz bei Belek!",
    description: "Finde alle Codes im Hause Beleks!",
    afkCredits: 50,
    markers: [
      belek1(),
      belek2(),
      belek3(),
      belek4(),
      belek5(),
    ],
    // TODO: QRCodeHuntIndoor
    type: QuestType.QRCodeHuntIndoor,
    startMarker: belek1(),
    finishMarker: belek2(),
  );
}

Quest getDummyQuestQrCodeSearchStarenweg() {
  return Quest(
    id: "Starenweg Hunt",
    name: "Versteckte Schätze im Starenweg!",
    description: "Finde alle Codes im Starenweg!",
    afkCredits: 50,
    markers: [
      starenweg1(),
      starenweg2(),
      starenweg3(),
    ],
    // TODO: QRCodeHuntIndoor
    type: QuestType.QRCodeSearch,
    startMarker: starenweg1(),
    finishMarker: starenweg3(),
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

Quest getDummyQuest6() {
  return Quest(
    id: "Starenweg Hike",
    name: "Starenweg Hike!",
    description: "",
    afkCredits: 1,
    markers: [
      starenweg4(),
      starenweg3(),
    ],
    type: QuestType.Hike,
    startMarker: starenweg4(),
    finishMarker: starenweg3(),
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
      nextLocationHint: "Der erste Code ist unter dir!");
}

AFKMarker starenweg2() {
  return AFKMarker(
      id: "starenweg2",
      qrCodeId: "starenweg2",
      lat: 48.068320041351725,
      lon: 7.904803866026531,
      nextLocationHint: "Suche in Opa's Arbeitszimmer.");
}

AFKMarker starenweg3() {
  return AFKMarker(
      id: "starenweg3",
      qrCodeId: "starenweg3",
      lat: 48.06831568327273,
      lon: 7.904792787613575,
      nextLocationHint: "Unter einem Bett");
}

AFKMarker starenweg4() {
  return AFKMarker(
      id: "starenweg4",
      qrCodeId: "starenweg4",
      lat: 48.06831568327273,
      lon: 7.904892787613575,
      nextLocationHint: "In einem Küchenschrank");
}

AFKMarker starenweg5() {
  return AFKMarker(
      id: "starenweg5",
      qrCodeId: "starenweg5",
      lat: 48.06831568327273,
      lon: 7.904892787613575,
      nextLocationHint: "In einer der Schubladen im Flur im 1. Stock");
}

AFKMarker starenweg6() {
  return AFKMarker(
      id: "starenweg6",
      qrCodeId: "starenweg6",
      lat: 48.06831568327273,
      lon: 7.904892787613575,
      nextLocationHint: "");
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

AFKMarker belek1() {
  return AFKMarker(
      id: "belek1",
      qrCodeId: "belek1",
      lat: 48.04959523177769,
      lon: 7.901375792193425,
      nextLocationHint: "Der erste Marker ist unter dir mein Kleiner ;)");
}

AFKMarker belek2() {
  return AFKMarker(
      id: "belek2",
      qrCodeId: "belek2",
      lat: 48.04959523177769,
      lon: 7.901375792193425,
      nextLocationHint: "Schau mal in den Kühlschrank!");
}

AFKMarker belek3() {
  return AFKMarker(
      id: "belek3",
      qrCodeId: "belek3",
      lat: 48.04959523177769,
      lon: 7.901375792193425,
      nextLocationHint: "Bring mir ein Bier und ich sage dir den nächsten Tip");
}

AFKMarker belek4() {
  return AFKMarker(
      id: "belek4",
      qrCodeId: "belek4",
      lat: 48.04959523177769,
      lon: 7.901375792193425,
      nextLocationHint: "Unter einem Möbelstück!");
}

AFKMarker belek5() {
  return AFKMarker(
      id: "belek5",
      qrCodeId: "belek5",
      lat: 48.04959523177769,
      lon: 7.901375792193425,
      nextLocationHint: "Im Kleiderschrank!!");
}

AFKMarker belekLocSearch1() {
  return AFKMarker(
      id: "belekLocSearch1",
      qrCodeId: "belekLocSearch1",
      lat: 48.050260829411386,
      lon: 7.9010928692091635,
      nextLocationHint: "");
}

AFKMarker belekLocSearch() {
  return AFKMarker(
      id: "belekLocSearch",
      qrCodeId: "belekLocSearch",
      lat: 48.05194200805362,
      lon: 7.90323708024672,
      nextLocationHint: "");
}

// burnaby quest
Quest getDummyVibrationSearchQuestHeuweiler() {
  return Quest(
      id: "VibrationSearch",
      name: "Heuweiler Trophy Search!",
      description: "Find the Trophy Hidden in Heuweiler Best Town!",
      afkCredits: 30,
      markers: [
        belekLocSearch1(),
        belekLocSearch(),
      ],
      type: QuestType.TreasureLocationSearch,
      startMarker: belekLocSearch1(),
      finishMarker: belekLocSearch());
}

AFKMarker heidach1() {
  return AFKMarker(
      id: "heidach1",
      qrCodeId: "heidach1",
      lat: 48.06808982011085,
      lon: 7.905153161233762,
      nextLocationHint: "");
}

AFKMarker heidach2() {
  return AFKMarker(
      id: "heidach2",
      qrCodeId: "heidach2",
      lat: 48.06701330843975,
      lon: 7.903736956224777,
      nextLocationHint: "");
}

Quest commercialTrophy() {
  return Quest(
      id: "commercial trophy",
      name: "Find the biggest secret of commercial drive!",
      description:
          "Learn how to enjoy life by finding the treasure at commercial drive",
      afkCredits: 30,
      markers: [commercial1(), commercial2()],
      type: QuestType.TreasureLocationSearch,
      startMarker: commercial1(),
      finishMarker: commercial2());
}

AFKMarker commercial1() {
  return AFKMarker(
      id: "commercial1",
      qrCodeId: "commercial1",
      lat: 49.273658969631974,
      lon: -123.0705730554199,
      nextLocationHint: "");
}

AFKMarker commercial2() {
  return AFKMarker(
      id: "commercial2",
      qrCodeId: "commercial2",
      lat: 49.27631049183584,
      lon: -123.06956197567348,
      nextLocationHint: "");
}
