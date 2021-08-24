import 'package:cloud_firestore/cloud_firestore.dart';

const String kAppName = "AFK Credits";
const NoKey = 'NoKey';
const GoogleMapsEnvKey = 'GOOGLE_MAPS_API_KEY';
const kLocalStorageUidKey = "uid";
const kTestUid = "TestId";

final appName = 'AFK Credits';

/////////////////////////////////////////////////
// Firebase collections and keys

// collection keys
final String userStatisticsCollectionKey = "statistics";
final String userFavouritePlacesCollectionKey = "FavouritePlaces";
final String activeQuestsCollectionKey = "activeQuests";

// document keys
final String userSummaryStatisticsDocumentKey = "summaryStats";

// collection references
final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference paymentsCollection =
    FirebaseFirestore.instance.collection('transfers');
final CollectionReference questsCollection =
    FirebaseFirestore.instance.collection('quests');
final CollectionReference globalStatsCollection =
    FirebaseFirestore.instance.collection("globalStats");
final CollectionReference activeQuestsCollection =
    FirebaseFirestore.instance.collection(activeQuestsCollectionKey);

////////////////////////////////////////////////////
/// Cloud functions

// when running on production backend
const String AUTHORITYDEV = "us-central1-afk-credits-112d2.cloudfunctions.net";
const String URIPATHPREPENDDEV = "";

// when running on production backend
const String AUTHORITYPROD = "us-central1-afkcredits.cloudfunctions.net";
const String URIPATHPREPENDPROD = "";
