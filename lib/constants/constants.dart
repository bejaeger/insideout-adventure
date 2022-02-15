import 'package:cloud_firestore/cloud_firestore.dart';

const String kAppName = "AFK Credits";
const NoKey = 'NoKey';
const GoogleMapsEnvKey = 'GOOGLE_MAPS_API_KEY';
const GoogleMapsEnvKeyIOS = 'GOOGLE_MAPS_API_KEY_IOS';
const kLocalStorageUidKey = "uid";
const kLocalStorageRoleKey = "role";
const kLocalStorageSponsorPinKey = "pinKey";

final appName = 'AFK Credits';

/////////////////////////////////////////////////
// Firebase collections and keys

// collection keys
final String userStatisticsCollectionKey = "statistics";
final String userFavouritePlacesCollectionKey = "FavouritePlaces";
final String activatedQuestsCollectionKey = "activatedQuests";

// document keys
final String userSummaryStatisticsDocumentKey = "summaryStats";
final String purchasedGiftCardsCollectionKey = "giftcards";

// collection references
final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
// collection references
final CollectionReference giftCardsCollection =
    FirebaseFirestore.instance.collection('giftCardCategories');

final CollectionReference preGiftCardsCollection =
    FirebaseFirestore.instance.collection('prePurchasedGiftCards');

final CollectionReference paymentsCollection =
    FirebaseFirestore.instance.collection('transfers');
final CollectionReference questsCollection =
    FirebaseFirestore.instance.collection('quests');
final CollectionReference globalStatsCollection =
    FirebaseFirestore.instance.collection("globalStats");
final CollectionReference markersCollection =
    FirebaseFirestore.instance.collection("markers");
final CollectionReference activatedQuestsCollection =
    FirebaseFirestore.instance.collection(activatedQuestsCollectionKey);

////////////////////////////////////////////////////
/// Cloud functions

// when running on production backend
const String AUTHORITYDEV = "us-central1-afk-credits-112d2.cloudfunctions.net";
const String URIPATHPREPENDDEV = "";

// when running on production backend
// TODO: This is still the dev environment cloud functions!
const String AUTHORITYPROD = "us-central1-afk-credits-prod.cloudfunctions.net";
// "us-central1-afkcredits.cloudfunctions.net";
const String URIPATHPREPENDPROD = "";

const List<String> questType = [
  "Hike",
  "Hunt",
  "DistanceEstimate",
  "QRCodeHunt",
  "QRCodeSearch",
  "QRCodeSearchIndoor",
  "TreasureLocationSearch",
  "TreasureLocationSearchAutomatic"
];
//////////////////////////////////////////////////////////
/// Quest settings!

const int kMaxQuestTimeInSeconds = 24 * 60 * 60;

const int kMaxDistanceFromMarkerInMeter = 50;

bool foundMarker = false;
bool shownDummyModeDialog = false;

////////////////////////////////////
// for Location Search

// will be scaled down once closer to the treasure!
const double kMinDistanceFromLastCheckInMeters = 40;
const int kCheckDistanceReloadDurationInSeconds = 10;

const double kMinDistanceToCatchTrophyInMeters = 30;
const double kMinRequiredAccuracyLocationSearch = 50;
// for vibration search automatic
const int kDeadTimeAfterVibrationInSeconds = 5;

//////////////////////////////////
// for distance estimate
const int kNumberTriesToRevealDistance = 3;
// tolerance
const double kMaxDeviationOfGoalInPercent = 0.2;
const double kMinRequiredAccuracyDistanceEstimate = 50;
const double kDistanceFilterDistanceEstimate = 10;
const double latitude = 49.268429;
const double longitude = -122.997176;

//////////////////////////////////
// for distance estimate
const double kDistanceFilterHikeQuest = 10;

//////////////////////////////////
// QRCodeHike
const int kDistanceFromCenterOfArea = 50;

//////////////////////////////////
/// QrCode Hunt
const int kMaxDistanceFromMarkerInMeterQrCodeHunt = 200;

////////////////////////////
/// General
const double kThresholdGPSAccuracyToShowInfo = 50;
const double kMinLocationAccuracy = 100;
const double kUnrealisticallyHighDistance = 100000000;

const int kDistanceFilterForCalibration = 5;
