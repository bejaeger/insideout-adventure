import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String kAppName = "AFK Credits";
const NoKey = 'NoKey';
const GoogleMapsEnvKey = 'GOOGLE_MAPS_API_KEY';
const kLocalStorageUidKey = "uid";
const kTestUid = "TestId";
/////////////////////////////////////////////////
// Firebase collections and keys
final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
final String userStatisticsCollectionKey = "statistics";
final String userSummaryStatisticsDocumentKey = "summaryStats";
final CollectionReference paymentsCollection =
    FirebaseFirestore.instance.collection('transfers');
final CollectionReference questsCollection =
    FirebaseFirestore.instance.collection('quests');
final appName = 'AFK Credits';
final CollectionReference globalStatsCollection =
    FirebaseFirestore.instance.collection("globalStats");
