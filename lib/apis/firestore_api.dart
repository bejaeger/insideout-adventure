import 'dart:async';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/faqs/faqs.dart';
import 'package:afkcredits/datamodels/feedback/feedback.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreApi {
  final log = getLogger('FirestoreApi');
  final firestoreInstance = FirebaseFirestore.instance;

  List<Quest>? newQuestResult;
  Geoflutterfire geo = Geoflutterfire();
  Stream<dynamic>? query;
  StreamSubscription? publicQuestsStreamSubscription;
  Map<String, StreamSubscription?> parentQuestsStreamSubscriptions = {};

  Future<void> createUser(
      {required User user, required UserStatistics stats}) async {
    try {
      await createUserInfo(user: user);
      await createUserStatistics(uid: user.uid, stats: stats);
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create new user',
        devDetails: '$error',
      );
    }
  }

  Future<void> createUserInfo({required User user}) async {
    final userDocument = usersCollection.doc(user.uid);
    await userDocument.set(user.toJson());
    log.v('User document added to ${userDocument.path}');
  }

  Future<void> createUserStatistics(
      {required String uid, required UserStatistics stats}) async {
    final docRef = getUserSummaryStatisticsDocument(uid: uid);
    await docRef.set(stats.toJson());
    log.v('Stats document added to ${docRef.path}');
  }

  // when explorer is added without authentication so without ID
  // we need to generate that id and add it to the datamodel.
  DocumentReference createUserDocument() {
    final docRef = usersCollection.doc();
    return docRef;
  }

  Future<User?> getUser({required String uid}) async {
    var userData = await usersCollection.doc(uid).get();
    if (!userData.exists) {
      log.v("User does not exist");
      return null;
    }

    if (userData.data() == null) {
      log.wtf(
          "User data document could be found but it does not have any data! Something is seriously wrong");
      throw FirestoreApiException(
        message: 'Failed to get user',
        devDetails:
            "User data document could be found but it does not have any data! Something is seriously wrong",
      );
    }
    try {
      return User.fromJson(userData.data()! as Map<String, dynamic>);
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to get user',
        devDetails: '$error',
      );
    }
  }

  Future<User?> getUserWithName({required String? name}) async {
    if (name == null) return null;
    QuerySnapshot doc =
        await usersCollection.where("fullName", isEqualTo: name).get();
    try {
      if (doc.docs.length > 1) {
        log.wtf(
            "This should never happen! There is more than one user with name $name in the database");
        return null;
      }
      if (doc.docs.length == 1) {
        log.v("Found user with name $name, returning user object");
        return User.fromJson(doc.docs.first.data() as Map<String, dynamic>);
      } else {
        log.v("No user found with name $name");
        return null;
      }
    } catch (e) {
      log.e("Error when getting user document: $e");
    }
    return null;
  }

  Future<UserStatistics> getUserSummaryStatistics({required String uid}) async {
    try {
      final docRef = await getUserSummaryStatisticsDocument(uid: uid).get();
      if (docRef.data() == null) {
        log.e("Data of document could not be found!");
        throw FirestoreApiException(
          message: "User statistics document has no data.",
        );
      } else {
        log.i("Reading document: ${docRef.data()}");
        final UserStatistics userStats =
            UserStatistics.fromJson(docRef.data()! as Map<String, dynamic>);
        return userStats;
      }
    } catch (e) {
      log.e(
          "Error when trying to read document! Are your data models up-to-date?");
      throw FirestoreApiException(
          message: "User statistics document could not be fetched!",
          devDetails:
              "Something failed when fetching the user summary statistics document for user with id '$uid'. This is likely due to some backwards-compatibility-breaking updates to the data models or firestore collection setup. Thrown error message was: $e");
    }
  }

  Stream<UserStatistics> getUserSummaryStatisticsStream({required String uid}) {
    return getUserSummaryStatisticsDocument(uid: uid).snapshots().map((event) {
      if (!event.exists || event.data() == null) {
        throw FirestoreApiException(
            message: "User statistics document not valid!",
            devDetails:
                "Something must have failed before when creating user account with id $uid. This is likely due to some backwards-compatibility-breaking updates to the data models or firestore collection setup.");
      }
      return UserStatistics.fromJson(event.data()! as Map<String, dynamic>);
    });
  }

  Future updateUserData({required User user}) async {
    try {
      await usersCollection
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when updating user settings in users collection",
          devDetails: '$e');
    }
  }

  Future updateUserSettings(
      {required String uid,
      required String key,
      required dynamic value}) async {
    try {
      await usersCollection.doc(uid).set({
        "userSettings": {
          key: value,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when updating user settings in users collection",
          devDetails: '$e');
    }
  }

  Future<void> updateTokenForUser(
      {required String uid, required String token}) async {
    log.v("Updating fcm token for user with id $uid");
    usersCollection.doc(uid).update(
      {
        'tokens': [token],
      },
    );
  }

  Future<void> updateDeviceId(
      {required String uid, required String deviceId}) async {
    log.v("Updating device id for user with id $uid");
    usersCollection.doc(uid).update(
      {
        'deviceId': deviceId,
      },
    );
  }

  Future<void> updateQuestData({required Quest quest}) async {
    try {
      await questsCollection
          .doc(quest.id)
          .set(quest.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when updating user settings in quest collection",
          devDetails: '$e');
    }
  }

  Future addSponsorIdToUser(
      {required String uid, required String sponsorId}) async {
    try {
      firestoreInstance.runTransaction((transaction) async {
        final doc = await usersCollection.doc(uid).get();
        User otherUser = User.fromJson(doc.data()! as Map<String, dynamic>);
        List<String> newSponsorIds = [];
        newSponsorIds.addAll(otherUser.sponsorIds);
        if (newSponsorIds.contains(sponsorId)) {
          log.w(
              "Sponsor Id already added! Nothing is really brokwn but this should not happen and might be due to inconsistencies in the database. Better to look into this or use a transaction for updating a sponsor. Then this issue can't appear");
          return;
        }
        newSponsorIds.add(sponsorId);
        await usersCollection.doc(uid).set(
            otherUser.copyWith(sponsorIds: newSponsorIds).toJson(),
            SetOptions(merge: true));
      });
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when trying to add sponsor Id to users sponsor Ids",
          devDetails: '$e');
    }
  }

  Future removeSponsorIdFromUser(
      {required String uid, required String sponsorId}) async {
    try {
      firestoreInstance.runTransaction((transaction) async {
        final doc = await usersCollection.doc(uid).get();
        User otherUser = User.fromJson(doc.data()! as Map<String, dynamic>);
        List<String> newSponsorIds = [];
        newSponsorIds.addAll(otherUser.sponsorIds);
        if (!newSponsorIds.contains(sponsorId)) {
          log.w(
              "Sponsor Id not included! Nothing is really broken but this should not happen and might be due to inconsistencies in the database. Better to look into this or use a transaction for updating a sponsor. Then this issue can't appear");
          return;
        }
        newSponsorIds.remove(sponsorId);
        await usersCollection.doc(uid).set(
            otherUser.copyWith(sponsorIds: newSponsorIds).toJson(),
            SetOptions(merge: true));
      });
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when trying to remove sponsor Id from users sponsor Ids",
          devDetails: '$e');
    }
  }

  Future<void> removeQuest({required Quest quest}) async {
    await questsCollection.doc(quest.id).delete();
  }

  Stream<User> getUserStream({required String uid}) {
    return usersCollection.doc(uid).snapshots().map(
      (event) {
        if (!event.exists || event.data() == null) {
          throw FirestoreApiException(
              message: "User document not valid!",
              devDetails:
                  "Something must have failed before when creating user account. This is likely due to some backwards-compatibility-breaking updates to the data models or firestore collection setup.");
        }
        return User.fromJson(event.data()! as Map<String, dynamic>);
      },
    );
  }

  Stream<List<User>> getExplorersDataStream({required String uid}) {
    try {
      return usersCollection
          .where("sponsorIds", arrayContains: uid)
          .snapshots()
          .map((event) => event.docs
              .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when listening to money pools the user is invited to",
          devDetails: '$e');
    }
  }

  Future<List<PublicUserInfo>> queryExplorers(
      {required String queryString}) async {
    QuerySnapshot foundUsers = await usersCollection
        .where("role", isEqualTo: getStringFromEnum(UserRole.explorer))
        .where("fullNameSearch", arrayContains: queryString.toLowerCase())
        .get();
    final results = foundUsers.docs.map(
      (DocumentSnapshot doc) {
        return PublicUserInfo(
            name: doc.get("fullName"),
            uid: doc.get("uid"),
            email: doc.get("email"));
      },
    ).toList();
    log.v("Queried users and found ${results.length} matches");
    return results;
  }

  Quest? getQuest({required String questId}) {
    log.i("Get dummy quest");
    return getDummyQuest1();
  }

  Future _uploadQuest({required Quest quest}) async {
    log.i("Upload quest with id ${quest.id} to firestore");
    final _documentReference = await questsCollection.add(
      quest.toJson(),
    );
    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
    await questsCollection
        .doc(_documentReference.id)
        .update({'id': _documentReference.id});
  }

  Future createQuest({required Quest quest}) async {
    log.i("Upload quest with id ${quest.id} to firestore");
    final _documentReference = questsCollection.doc();
    bool timedout = false;
    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
    await questsCollection
        .doc(_documentReference.id)
        .set(quest.copyWith(id: _documentReference.id).toJson())
        .timeout(
      Duration(seconds: 5),
      onTimeout: () {
        timedout = true;
        log.w("Uploading quest timed out. No data connection");
      },
    );
    if (timedout) {
      return WarningFirestoreCallTimeout;
    }
    if (_documentReference.id.isNotEmpty) {
      log.i(
          'This is the Document Id Being Created Harguilar ${_documentReference.id}');
      return true;
    }
    return false;
  }

  Future<List<Quest>> downloadNearbyQuests(
      {required List<String> sponsorIds,
      required double lat,
      required double lon,
      required double radius}) async {
    List<Quest> returnQuests = [];
    Completer<void> completer1 = Completer();
    Completer<void> completer2 = Completer();
    try {
      final center = geo.point(latitude: lat, longitude: lon);

      // only returns quests NOT created by a standard parent
      // ? we can't query for ONLY quests that are NOT done by users, unfortunately.
      final questsRef = questsCollection.where("createdBy", isNull: true);
      Stream<List<DocumentSnapshot>> publicQuestsStream = geo
          .collection(collectionRef: questsRef)
          .within(
              center: center,
              radius: radius,
              field: kQuestGeoPointPropertyName,
              strictMode: true);

      publicQuestsStreamSubscription?.cancel();
      publicQuestsStreamSubscription = null;
      publicQuestsStreamSubscription = publicQuestsStream.listen(
        (List<DocumentSnapshot> docList) {
          if (docList.isNotEmpty) {
            try {
              List<Quest> questList = docList
                  .map(
                    (docs) => Quest.fromJson(
                      docs.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();
              returnQuests.addAll(questList);
            } catch (e) {
              log.e("Error loading quest datamodel from firestore: $e");
              rethrow;
            }
          } else {
            log.w('There is no public \'quests\' collection on firestore.');
          }
          if (!completer1.isCompleted) {
            completer1.complete();
          }
        },
      );

      if (sponsorIds.length == 0) {
        log.i(
            "No parent associated to child, not looking for custom created quests");
        if (!completer2.isCompleted) {
          completer2.complete();
        }
      }
      int counter = 0;
      for (String id in sponsorIds) {
        log.v("checking for quests from parent with id $id");
        counter = counter + 1;
        final qref = questsCollection.where("createdBy", isEqualTo: id);
        Stream<List<DocumentSnapshot>> parentQuestsStream = geo
            .collection(collectionRef: qref)
            .within(
                center: center,
                radius: radius,
                field: kQuestGeoPointPropertyName,
                strictMode: true);
        parentQuestsStreamSubscriptions[id]?.cancel();
        parentQuestsStreamSubscriptions[id] = null;
        parentQuestsStreamSubscriptions[id] = parentQuestsStream.listen(
          (List<DocumentSnapshot> docList) {
            if (docList.isNotEmpty) {
              try {
                List<Quest> questList = docList
                    .map(
                      (docs) => Quest.fromJson(
                        docs.data() as Map<String, dynamic>,
                      ),
                    )
                    .toList();
                returnQuests.addAll(questList);
              } catch (e) {
                log.e("Error loading quest datamodel from firestore: $e");
                rethrow;
              }
            } else {
              log.w(
                  'There is no \'quests\' collection from parents on firestore');
            }
            if (counter == sponsorIds.length) {
              if (!completer2.isCompleted) {
                completer2.complete();
              }
            }
          },
        );
      }
    } catch (e) {
      log.wtf("Error downloading quests: $e");
      throw FirestoreApiException(
          message: "Unknown expection when downloading to quests",
          devDetails: '$e');
    }
    await Future.wait([completer1.future, completer2.future]);
    if (returnQuests.length == 0) {
      throw FirestoreApiException(
        message: WarningNoQuestsDownloaded,
        devDetails: WarningNoQuestsDownloaded,
        prettyDetails:
            "No quests were found in this area. Ask your parents to create one.",
      );
    }
    log.i("Found ${returnQuests.length} nearby quests.");
    return returnQuests;
  }

  Future<List<Quest>> getNearbyQuests(
      {required List<String> sponsorIds,
      required double lat,
      required double lon,
      required double radius,
      bool? pushDummyQuests}) async {
    if (pushDummyQuests == true) {
      late List<Quest> questsOnFirestore;
      try {
        log.i("Downloading quests now");
        questsOnFirestore = await downloadNearbyQuests(
            sponsorIds: sponsorIds, lat: lat, lon: lon, radius: radius);
      } catch (e) {
        log.w(
            "Error thrown when downloading quests (might be harmless because we want to push new dummy quests): $e");
        questsOnFirestore = [];
      }
      final quests = getDummyQuests();
      quests.forEach(
        (el1) {
          if (!questsOnFirestore.any((el2) => el2.name == el1.name)) {
            // dummy quest not yet on firestore
            // adding it
            _uploadQuest(quest: el1);
          }
        },
      );
      return quests;
    } else {
      return await downloadNearbyQuests(
          sponsorIds: sponsorIds, lat: lat, lon: lon, radius: radius);
    }
  }

  Future pushFinishedQuest({required ActivatedQuest? quest}) async {
    if (quest == null) {
      log.wtf("Quest to push is null! This should not happen");
      return;
    }
    try {
      final docRef = activatedQuestsCollection.doc();
      ActivatedQuest newQuest = quest.copyWith(
          id: docRef.id, createdAt: FieldValue.serverTimestamp());
      await docRef.set(newQuest.toJson());
    } catch (e) {
      log.e(
          "Something went wrong when pushing a finished quest, this is the error: $e");
      throw FirestoreApiException(
          message: "A peculiar error occured",
          devDetails:
              "This problem is likely caused by some not well defined datamodels and their json serializability.");
    }
  }

  Future bookkeepFinishedQuest({required ActivatedQuest quest}) async {
    log.v("Uploading and bookkeeping finished quest");

    num? afkCreditsEarned = quest.afkCreditsEarned;
    String? questId = quest.quest.id;
    List<String>? uids = quest.uids;
    if (afkCreditsEarned == null) {
      log.wtf(
          "afkCreditsEarned field is null in ActivatedQuest. Can't upload anything");
      return;
    }
    if (uids == null) {
      log.wtf("Uids field empty in ActivatedQuest. Can't upload anything");
      return;
    }
    bool timedout = false;
    for (String uid in uids) {
      await firestoreInstance.runTransaction(
        (transaction) async {
          DocumentReference userDocRef =
              getUserSummaryStatisticsDocument(uid: uid);
          DocumentSnapshot userDoc = await transaction.get(userDocRef);
          if (!userDoc.exists) {
            log.wtf(
                "Summary statistics document of user with id $uid does not exist");
            throw FirestoreApiException(
                message: "Unknown expection when uploading quest",
                prettyDetails:
                    "An error occured when uploading a quest. Please make sure you have data connection and try again later.",
                devDetails:
                    "Summary statistics document of user with id $uid does not exist");
          }
          UserStatistics userStats =
              UserStatistics.fromJson(userDoc.data() as Map<String, dynamic>);

          final incrementCredits = FieldValue.increment(afkCreditsEarned);
          final decrementSponsoring =
              FieldValue.increment(-afkCreditsEarned * 10);

          transaction.update(
            userDocRef,
            {
              "availableSponsoring":
                  decrementSponsoring, // decrement available sponsoring of explorer
              "afkCreditsBalance":
                  incrementCredits, // increment afk credits balance
              "lifetimeEarnings":
                  incrementCredits, // increment lifetime earnings
              "numberQuestsCompleted": FieldValue.increment(
                  1), // increment number of quests completed
              "completedQuestIds": userStats.completedQuestIds + [questId],
            },
          );

          try {
            final docRef = activatedQuestsCollection.doc();
            ActivatedQuest newQuest = quest.copyWith(
                id: docRef.id, createdAt: FieldValue.serverTimestamp());
            transaction.set(
              docRef,
              newQuest.toJson(),
            );
          } catch (e) {
            log.e(
                "Something went wrong when pushing a finished quest, this is the error: $e");
            throw FirestoreApiException(
                message: "A peculiar error occured",
                devDetails:
                    "This problem is likely caused by some not well defined datamodels and their json serializability.");
          }
        },
      ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          timedout = true;
          log.w("Uploading quest timed out. Probs no data connection");
        },
      );
    }
    if (timedout) {
      return WarningFirestoreCallTimeout;
    }
  }

  Future<List<dynamic>?> getListOfScreenShotNames(
      {required String questType}) async {
    log.v("get list of screen shot names");
    final DocumentSnapshot docSnapshot =
        await screenShotsCollection.doc(questType).get();
    if (docSnapshot.exists) {
      try {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return data["screenshotUrls"];
      } catch (error) {
        log.wtf(
            'Failed to get list of screen shot names for quest Type $questType');
        throw FirestoreApiException(
          message:
              'Failed to get list of screen shot names for quest Type $questType',
          devDetails: '$error',
        );
      }
    } else {
      log.e(
          "screenshot document with id $questType does not exist in screenshots firestore collection");
    }
    return null;
  }

  Future<List<Quest>> downloadQuestsWithStartMarkerId(
      {required String? startMarkerId}) async {
    QuerySnapshot snapshot = await questsCollection
        .where(startMarkerId!, isEqualTo: startMarkerId)
        .get();
    try {
      List<Quest> quests = snapshot.docs
          .map((e) => Quest.fromJson(e.data() as Map<String, dynamic>))
          .toList();
      return quests;
    } catch (e) {
      throw FirestoreApiException(
        message: 'Failed to get quests with startMarkerId $startMarkerId',
        devDetails: 'Error thrown: $e',
      );
    }
  }

  Stream<List<ActivatedQuest>> getPastQuestsStream({required String uid}) {
    try {
      final returnStream = activatedQuestsCollection
          .where("uids", arrayContains: uid)
          .orderBy("createdAt", descending: true)
          .where("status",
              isEqualTo: describeEnum(QuestStatus.success.toString()))
          .limit(20) // limit query
          .snapshots()
          .map((event) => event.docs
              .map((doc) =>
                  ActivatedQuest.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
      return returnStream;
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when listening to past quests the user has successfully done",
          devDetails: '$e');
    }
  }

  Stream<List<Achievement>> getAchievementsStream({required String uid}) {
    // TODO: Dummy for now!
    return Stream.value(getDummyAchievements());
  }

  String getScreenTimeSessionDocId() {
    final docRef = screenTimeSessionCollection.doc();
    return docRef.id;
  }

  Future<void> addScreenTimeSession(
      {required ScreenTimeSession session}) async {
    log.i("Add screen time session to firestore");
    late Timestamp validStartedAt;
    if (session.startedAt is DateTime) {
      validStartedAt = Timestamp.fromDate(session.startedAt);
    } else {
      validStartedAt = session.startedAt;
    }
    screenTimeSessionCollection.doc(session.sessionId).set(
        session
            .copyWith(
              startedAt: validStartedAt,
            )
            .toJson(),
        SetOptions(merge: true));
  }

  Future removeScreenTimeSessionStatus({required String sessionId}) async {
    await screenTimeSessionCollection.doc(sessionId).delete();
  }

  Stream<ScreenTimeSession> getScreenTimeStream({required String sessionId}) {
    return screenTimeSessionCollection.doc(sessionId).snapshots().map((event) {
      if (!event.exists || event.data() == null) {
        throw FirestoreApiException(
            message: "screen time session document not valid!",
            devDetails:
                "Something must have failed before when creating the screen time session. This is likely due to some backwards-compatibility-breaking updates to the data models or firestore collection setup.");
      }
      return ScreenTimeSession.fromJson(event.data() as Map<String, dynamic>);
    });
  }

  Future updateScreenTimeSessionStatus(
      {required ScreenTimeSession session,
      required ScreenTimeSessionStatus status}) async {
    log.i("Update screen time session to firestore");
    session = session.copyWith(status: status);
    await screenTimeSessionCollection.doc(session.sessionId).update(
      {
        'status': session.toJson()["status"],
      },
    );
  }

  Future updateScreenTimeSession({required ScreenTimeSession session}) async {
    log.i("Update screen time session to firestore");
    await screenTimeSessionCollection.doc(session.sessionId).update(
      {
        'status': session.toJson()["status"],
        'afkCreditsUsed': session.afkCreditsUsed,
        'minutesUsed': session.minutesUsed,
      },
    );
  }

  Future cancelScreenTimeSession({required ScreenTimeSession session}) async {
    log.i("cancel screen time session on firestore");
    await screenTimeSessionCollection.doc(session.sessionId).update({
      'status': session.toJson()["status"],
      'afkCreditsUsed': session.afkCreditsUsed,
      'minutesUsed': session.minutesUsed,
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  Future deleteScreenTimeSession({required ScreenTimeSession session}) async {
    log.i("Delete screen time session to firestore");
    await screenTimeSessionCollection.doc(session.sessionId).delete();
  }

  Future<ScreenTimeSession?> getScreenTimeSession(
      {required String sessionId}) async {
    log.i("get screen time session from firestore");
    final sessionDoc = await screenTimeSessionCollection.doc(sessionId).get();
    if (sessionDoc.exists) {
      try {
        return ScreenTimeSession.fromJson(
            sessionDoc.data() as Map<String, dynamic>);
      } catch (error) {
        log.wtf('Failed to get screentime session with id $sessionId');
        throw FirestoreApiException(
          message: 'Failed to get screentime session with id $sessionId',
          devDetails: '$error',
        );
      }
    } else {
      log.wtf("Screen time session with id $sessionId does not exist");
      throw FirestoreApiException(
        message: "Screen time session with id $sessionId does not exist",
        devDetails:
            "Some inconsistency with saving out the session id to local storage",
      );
    }
  }

  Stream<List<ScreenTimeSession>> getScreenTimeSessionStream(
      {required String uid}) {
    try {
      final returnStream = screenTimeSessionCollection
          .where("uid", isEqualTo: uid)
          .orderBy("startedAt", descending: true)
          .limit(20)
          .snapshots()
          .map((event) => event.docs
              .map((doc) => ScreenTimeSession.fromJson(
                  doc.data() as Map<String, dynamic>))
              .toList());
      return returnStream;
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when listening to screen time sessions that are active",
          devDetails: '$e');
    }
  }

  Future uploadFeedback(
      {required Feedback feedback, String? feedbackDocumentKey}) async {
    log.i("Uploading feedback document");
    DocumentReference ref =
        createFeedbackDocument(feedbackDocumentKey: feedbackDocumentKey);
    await ref.set(feedback.toJson());
  }

  Future<FeedbackCampaignInfo> getFeedbackCampaignInfo() async {
    final feedback =
        await feedbackCollection.doc(feedbackCampaignInfoDocumentKey).get();
    if (feedback.exists) {
      try {
        return FeedbackCampaignInfo.fromJson(
            feedback.data() as Map<String, dynamic>);
      } catch (error) {
        log.wtf(
            'Failed to get feedback campaign info doc. Probably the document first needs to be created.');
        throw FirestoreApiException(
          message: 'Failed to get feedback campaign info doc',
          devDetails:
              'Probably the document first needs to be created. Error: $error',
        );
      }
    } else {
      log.wtf("Failed to get feedback info doc. Creating it now!");
      DocumentReference ref =
          feedbackCollection.doc(feedbackCampaignInfoDocumentKey);
      FeedbackCampaignInfo returnVal = FeedbackCampaignInfo(
          currentCampaign: generalFeedbackDocumentKey,
          questions: [],
          surveyUrl: "");
      await ref.set(returnVal.toJson());
      return returnVal;
    }
  }

  Future updateFeedbackCampaignInfo(
      {required FeedbackCampaignInfo feedbackCampaignInfo}) async {
    await feedbackCollection
        .doc(feedbackCampaignInfoDocumentKey)
        .update(feedbackCampaignInfo.toJson());
  }

  // ! It is important that this is a transaction.
  // ! In case two phones are used otherwise the stats might be updated
  // ! twice.
  Future updateStatsAfterScreenTimeFinished(
      {required ScreenTimeSession session,
      required num deltaCredits,
      required num deltaScreenTime}) async {
    final sessionId = session.sessionId;
    await firestoreInstance.runTransaction(
      (transaction) async {
        final ref = screenTimeSessionCollection.doc(sessionId);
        final sessionDoc = await transaction.get(ref);
        if (sessionDoc.exists) {
          try {
            ScreenTimeSession sessionOnServer = ScreenTimeSession.fromJson(
                sessionDoc.data() as Map<String, dynamic>);
            if (sessionOnServer.status != ScreenTimeSessionStatus.active) {
              log.w(
                  "Found screen time session already cancelled or completed. Return from running transaction to avoid updating stats twice!");
              return;
            } else {
              log.w("Updating stats after screen time finished!");

              // now we can update the credits and the total screen time balance
              // update credits balance and total screen time
              final ref2 = getUserSummaryStatisticsDocument(uid: session.uid);
              transaction.update(
                ref2,
                {
                  "afkCreditsBalance": FieldValue.increment(deltaCredits),
                  "totalScreenTime": FieldValue.increment(deltaScreenTime),
                },
              );

              final ref3 = screenTimeSessionCollection.doc(session.sessionId);
              transaction.update(
                ref3,
                {
                  'status': session.toJson()["status"],
                  'afkCreditsUsed': session.afkCreditsUsed,
                  'minutesUsed': session.minutesUsed,
                },
              );
            }
          } catch (error) {
            log.wtf(
                'Failed to update stats after screentime session was uploaded. sessionId: $sessionId');
            throw FirestoreApiException(
              message:
                  'Failed to upload stats after screentime session with id $sessionId finished',
              devDetails: '$error',
            );
          }
        } else {
          log.wtf("Screen time session with id $sessionId does not exist");
          throw FirestoreApiException(
            message: "Screen time session with id $sessionId does not exist",
            devDetails: "",
          );
        }
      },
    );
  }

  Future changeAfkCreditsBalanceCheat(
      {required String uid, num deltaCredits = 50}) async {
    bool timedout = false;
    await getUserSummaryStatisticsDocument(uid: uid).update(
      {
        "afkCreditsBalance": FieldValue.increment(deltaCredits),
      },
    ).timeout(
      Duration(seconds: 5),
      onTimeout: () {
        timedout = true;
        log.w("Uploading quest timed out. No data connection");
      },
    );
    if (timedout) {
      return WarningFirestoreCallTimeout;
    }
  }

  Future changeTotalScreenTime(
      {required String uid, required num deltaScreenTime}) async {
    await getUserSummaryStatisticsDocument(uid: uid).update({
      "totalScreenTime": FieldValue.increment(deltaScreenTime),
    });
  }

  Future<FAQs> getFaqs() async {
    DocumentReference doc = getFAQDocument();
    DocumentSnapshot snapshot = await doc.get();
    if (snapshot.exists && snapshot.data() != null) {
      try {
        return FAQs.fromJson(snapshot.data()! as Map<String, dynamic>);
      } catch (e) {
        throw FirestoreApiException(
            message: 'Failed to get the FAQs', devDetails: '$e');
      }
    } else {
      return FAQs(answers: [], questions: []);
    }
  }
}

DocumentReference getUserStatisticsCollection({required String uid}) {
  return usersCollection.doc(uid).collection(userStatisticsCollectionKey).doc();
}

DocumentReference createFeedbackDocument({String? feedbackDocumentKey}) {
  if (feedbackDocumentKey == null) {
    return feedbackCollection
        .doc(generalFeedbackDocumentKey)
        .collection(feedbackCollectionKey)
        .doc();
  } else {
    return feedbackCollection
        .doc(feedbackDocumentKey)
        .collection(feedbackCollectionKey)
        .doc();
  }
}

DocumentReference getUserSummaryStatisticsDocument({required String uid}) {
  return usersCollection
      .doc(uid)
      .collection(userStatisticsCollectionKey)
      .doc(userSummaryStatisticsDocumentKey);
}

DocumentReference getUserFavouritePlacesDocument({required String uid}) {
  return usersCollection
      .doc(uid)
      .collection(userFavouritePlacesCollectionKey)
      .doc();
}

DocumentReference getMarkersDocs({required String markerId}) {
  return markersCollection.doc(markerId);
}

DocumentReference getAFKMarkersPositionDocs({required String markerId}) {
  return afkMarkersPositionsCollection.doc(markerId);
}

CollectionReference getUserGiftCardsCollection({required String uid}) {
  return usersCollection.doc(uid).collection(purchasedGiftCardsCollectionKey);
}

CollectionReference getUserScreenTimeCollection({required String uid}) {
  return usersCollection.doc(uid).collection(purchasedScreenTimeCollectionKey);
}

DocumentReference getFAQDocument() {
  return faqCollection.doc(faqDocumentKey);
}
