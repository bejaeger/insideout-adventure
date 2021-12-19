import 'package:cloud_firestore/cloud_firestore.dart';

const String kAppName = "AFK Credits";
const NoKey = 'NoKey';
const GoogleMapsEnvKey = 'GOOGLE_MAPS_API_KEY';
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

//////////////////////////////////////////////////////////
/// Quest settings!

const int kMaxQuestTimeInSeconds = 24 * 60 * 60;

const int kMaxDistanceFromMarkerInMeter = 50;

bool foundMarker = false;
bool shownDummyModeDialog = false;
