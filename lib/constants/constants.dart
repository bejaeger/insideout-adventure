import 'package:cloud_firestore/cloud_firestore.dart';

const String kAppName = "InsideOut Adventure";
const NoKey = 'NoKey';
const GoogleMapsEnvKey = 'GOOGLE_MAPS_API_KEY_ENV_VARIABLE';
const ProdGoogleMapsEnvKey = 'PROD_GOOGLE_MAPS_API_KEY_ENV_VARIABLE';
const kLocalStorageUidKey = "uid";
const kLocalStorageRoleKey = "role";
const kLocalStorageSponsorPinKey = "pinKey";
const kLocalStorageSponsorReferenceKey = "PARENT_ID";
const kLocalStorageSawOnBoardingKey = "SAW_ONBOARDING";
const kConfiguredArKey = "CONFIGURED_AR";
final appName = 'InsideOut Adventure';

// local storage keys
final String kActivatedQuestLocalFileName = "activatedQuest.json";

// Firebase collections and document keys
final String userStatisticsCollectionKey = "statistics";
final String userFavouritePlacesCollectionKey = "FavouritePlaces";
final String activatedQuestsCollectionKey = "activatedQuests";
final String screenTimeSessionsCollectionKey = "screenTimeSessions";
final String userSummaryStatisticsDocumentKey = "summaryStats";
final String purchasedScreenTimeCollectionKey = "screentime";
final String feedbackCampaignInfoDocumentKey = "campaignInfo";
final String generalFeedbackDocumentKey = "generalFeedback";
final String feedbackCollectionKey = "feedback";
final String faqDocumentKey = "faqs";

// properties
final String kQuestGeoPointPropertyName = "location";

// collection references
final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference feedbackCollection =
    FirebaseFirestore.instance.collection('feedback');
final CollectionReference screenShotsCollection =
    FirebaseFirestore.instance.collection('screenshots');
final CollectionReference picturesCollection =
    FirebaseFirestore.instance.collection('pictures');
final CollectionReference paymentsCollection =
    FirebaseFirestore.instance.collection('transfers');
var questsCollection = FirebaseFirestore.instance.collection('quests');
final CollectionReference screenTimeSessionCollection =
    FirebaseFirestore.instance.collection(screenTimeSessionsCollectionKey);
final CollectionReference globalStatsCollection =
    FirebaseFirestore.instance.collection("globalStats");
final CollectionReference markersCollection =
    FirebaseFirestore.instance.collection("markers");
final CollectionReference faqCollection =
    FirebaseFirestore.instance.collection("faqs");
final afkMarkersPositionsCollection =
    FirebaseFirestore.instance.collection("afkMarkersPositions");
final CollectionReference activatedQuestsCollection =
    FirebaseFirestore.instance.collection(activatedQuestsCollectionKey);

const String AUTHORITYDEV = "us-central1-afk-credits-112d2.cloudfunctions.net";
const String URIPATHPREPENDDEV = "";

// TODO: This is still the dev environment cloud functions!
const String AUTHORITYPROD = "us-central1-afk-credits-prod.cloudfunctions.net";
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

// layout
const double kHorizontalPadding = 20.0;
const double kVerticalPadding = 10.0;
const double kBottomNavigationBarIconSize = 35;
const double kAppBarExtendedHeight = 80;
const double kActiveQuestPanelMaxHeight = 200;
const double kActiveQuestMinSize = 60;
const double kBottomNavigationBarHeightCustom = 60;

// for notion api
const String kDevNotionFeedbackToken =
    "secret_JyfVJ2khuaLre3df4tAjlPy3I8k01vDc4uWQ5BAPLKK";
const String kProdNotionFeedbackToken =
    "secret_ibRlTwcBglfbKJGgvl36iZg0hmH5IX07jxr5otF8sgh";
// @see: https://www.notion.so/fdd1923780ed460c8c213670bd45404e?v=29c5ff15ff424a0ebede114ebaaf3e5c
const String kDevNotionFeedbackDatabaseId = "fdd1923780ed460c8c213670bd45404e";
// @see: https://www.notion.so/a24ab0b6691c4b71a3b836fb6f63935b?v=e696cc5722674485800a0deaeaf14f21
const String kProdNotionFeedbackDatabaseId = "a24ab0b6691c4b71a3b836fb6f63935b";

/// Quest settings!
const int kMaxDistanceFromMarkerInMeterQrCodeHunt = 200;
const int kMaxQuestTimeInSeconds = 24 * 60 * 60;
const int kMaxDistanceFromMarkerInMeter = 50;
bool shownDummyModeDialog = false;

// for Location Search

// will be scaled down once closer to the treasure!
const double kMinDistanceFromLastCheckInMeters = 20;
const int kCheckDistanceReloadDurationInSeconds = 10;
const double kMinDistanceToCatchTrophyInMeters = 40;
const double kMinRequiredAccuracyLocationSearch = 50;
const int kDeadTimeAfterVibrationInSeconds = 5;

// for distance estimate (deprecated)
const int kNumberTriesToRevealDistance = 3;
const double kMaxDeviationOfGoalInPercent = 0.2;
const double kMinRequiredAccuracyDistanceEstimate = 50;
const double kDistanceFilterDistanceEstimate = 10;
const double latitude = 49.268429;
const double longitude = -122.997176;
const double kDistanceFilterHikeQuest = 10;

// QRCodeHike
const int kDistanceFromCenterOfArea = 50;

/// QrCode Hunt
const double kThresholdGPSAccuracyToShowInfo = 50;
const double kMinLocationAccuracy = 100;
const double kUnrealisticallyHighDistance = 100000000;
const int kDistanceFilterForCalibration = 5;
const int kDefaultGeolocationDistanceFilter = 10;
const double kDefaultQuestDownloadRadiusInKm = 10;

// Google Maps View Settings
const double kInitialZoomAvatarView = 17.3;
const double kInitialBearing = 0;
const double kInitialTilt = 90;
const double kMaxZoom = 18;
const double kInitialZoomBirdsView = 14;
const double kMinZoomAvatarView = 17;
const int kMapAnimationSpeedAndroid = 1000;
const int kMapAnimationSpeedIos = 500;
const double kMapAnimationSpeedFractionIos = 0.5;
const double kMapAnimationSpeedFractionAndroid = 1;

/// notification keys and settings
const String kDefaultNotificationIconPath =
    "resource://drawable/res_notification_icon";
const String kPermanentNotificationKey = "permanent_notification";
const String kPermanentNotificationName = "Permanent notifications";
const String kScheduledNotificationChannelKey = "scheduled_notification";
const String kScheduledNotificationChannelName = "Scheduled notifications";
const String kScheduledNotificationActionKey = "action_key";
const String kUpdatedScreenTimeNotificationKey =
    "screentime_update_notification";
const String kUpdatedScreenTimeNotificationChannelName =
    "Screentime notifications";

/// Gamification system
const double kTotalCreditsEarnedToLevelConversion = 1 / 20;

/// Sign in
const String kAppleRedirectUri =
    "https://afk-credits-prod.firebaseapp.com/__/auth/handler";
const String kAppleClientId = "com.firebaseapp.hercules";
