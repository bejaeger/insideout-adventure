import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_datamodels.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/payments/money_transfer_query_config.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/completed_quest/completed_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreApi {
  final log = getLogger('FirestoreApi');
  final firestoreInstance = FirebaseFirestore.instance;
  //List<UserFavPlaces>? places;
  // Create user documents

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

  //Create a List of My Favourite Places
  Future<void> createUserFavouritePlaces(
      {required userId, required UserFavPlaces favouritePlaces}) async {
    try {
      final _docRef = getUserFavouritePlacesDocument(uid: userId);
      if (_docRef != null) {
        await _docRef.set(favouritePlaces.toJson());
        log.v('Favourite Places document added to ${_docRef.path}' + '\n');
        log.v('Your Document Reference is: ${_docRef.toString()}');
      }
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

  //Create a List of Completed Quest By Users.
  Future<void> createUserCompletedQuest(
      {required userId, required CompletedQuest? completedQuest}) async {
    try {
      final _docRef = getUserStatisticsCollection(uid: userId);
      if (_docRef != null) {
        await _docRef.set(completedQuest!.toJson());
        log.v('Favourite Places document added to ${_docRef.path}' + '\n');
        log.v('Your Document Reference is: ${_docRef.toString()}');
      }
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

  //Create a List of My Favourite Places
  Future<void> createMarkers({required AFKMarker markers}) async {
    try {
      final _docRef = getMarkersDocs(markerId: markers.id);
      if (_docRef != null) {
        await _docRef.set(markers.toJson());
        log.v('Favourite Places document added to ${_docRef.path}' + '\n');
        log.v('Your Document Reference is: ${_docRef.toString()}');
      }
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

  // when explorer is added without authentication so without ID
  // we need to generate that id and add it to the datamodel.
  DocumentReference createUserDocument() {
    final docRef = usersCollection.doc();
    return docRef;
  }

  ////////////////////////////////////////////////////////
  // Get user if exists
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
      return User.fromJson(userData.data()!);
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to get user',
        devDetails: '$error',
      );
    }
  }

// Get User Favourite Places.
  Future<List<UserFavPlaces>?>? getUserFavouritePlaces(
      {required String userId}) async {
    final userFavouritePlaces = await usersCollection
        .doc(userId)
        .collection(userFavouritePlacesCollectionKey)
        .get();

    if (userFavouritePlaces.docs.isNotEmpty) {
      try {
        return userFavouritePlaces.docs
            .map((docs) => UserFavPlaces.fromJson(docs.data()))
            .toList();
      } catch (e) {
        throw FirestoreApiException(
            message: 'Failed to get the Places', devDetails: '$e');
      }
    } else {
      return null;
    }
  }

// Get Places For the Quest.
  Future<List<Places>?>? getPlaces() async {
    final _places = await placesCollection.get();

    if (_places.docs.isNotEmpty) {
      try {
        return _places.docs
            .map((docs) => Places.fromJson(docs.data()))
            .toList();
      } catch (e) {
        throw FirestoreApiException(
            message: 'Failed to get the Places', devDetails: '$e');
      }
    } else {
      return null;
    }
  }

// Get Markers For the Quest.
  Future<List<AFKMarker>?>? getMarkers() async {
    final _markers = await markersCollection.get();

    if (_markers.docs.isNotEmpty) {
      try {
        return _markers.docs
            .map((docs) => AFKMarker.fromJson(docs.data()))
            .toList();
      } catch (e) {
        throw FirestoreApiException(
            message: 'Failed to get the Places', devDetails: '$e');
      }
    } else {
      return null;
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
        final id = doc.docs.first.id;
        log.v("Found user with name $name, returning user object");
        return User.fromJson(doc.docs.first.data());
      } else {
        log.v("No user found with name $name");
        return null;
      }
    } catch (e) {
      log.e("Error when getting user document: $e");
    }
  }

  ///////////////////////////////////////////////////////
  // Fetch user statistics once
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
            UserStatistics.fromJson(docRef.data()!);
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

  ///////////////////////////////////////////////////////
  // Get user streams
  Stream<UserStatistics> getUserSummaryStatisticsStream({required String uid}) {
    return getUserSummaryStatisticsDocument(uid: uid).snapshots().map((event) {
      if (!event.exists || event.data() == null) {
        throw FirestoreApiException(
            message: "User statistics document not valid!",
            devDetails:
                "Something must have failed before when creating user account with id $uid. This is likely due to some backwards-compatibility-breaking updates to the data models or firestore collection setup.");
      }
      return UserStatistics.fromJson(event.data()!);
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

  Future addSponsorIdToUser(
      {required String uid, required String sponsorId}) async {
    try {
      firestoreInstance.runTransaction((transaction) async {
        final doc = await usersCollection.doc(uid).get();
        User otherUser = User.fromJson(doc.data()!);
        List<String> newSponsorIds = [];
        newSponsorIds.addAll(otherUser.explorerIds);
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

  Stream<User> getUserStream({required String uid}) {
    return usersCollection.doc(uid).snapshots().map((event) {
      if (!event.exists || event.data() == null) {
        throw FirestoreApiException(
            message: "User document not valid!",
            devDetails:
                "Something must have failed before when creating user account. This is likely due to some backwards-compatibility-breaking updates to the data models or firestore collection setup.");
      }
      return User.fromJson(event.data()!);
    });
  }

  /// invitations
  Stream<List<User>> getExplorersDataStream({required String uid}) {
    try {
      final returnStream = usersCollection
          .where("sponsorIds", arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => User.fromJson(doc.data())).toList());
      return returnStream;
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when listening to money pools the user is invited to",
          devDetails: '$e');
    }
  }

  //////////////////////////////////////////////////////
  /// Queries for existing users

  Future<List<PublicUserInfo>> queryExplorers(
      {required String queryString}) async {
    QuerySnapshot foundUsers = await usersCollection
        .where("role", isEqualTo: getStringFromEnum(UserRole.explorer))
        .where("fullNameSearch", arrayContains: queryString.toLowerCase())
        .get();
    final results = foundUsers.docs.map((DocumentSnapshot doc) {
      return PublicUserInfo(
          name: doc.get("fullName"),
          uid: doc.get("uid"),
          email: doc.get("email"));
    }).toList();
    log.v("Queried users and found ${results.length} matches");
    return results;
  }

  ///////////////////////////////////////////////////////
  /// Get Money Transfer Stream
  Stream<List<MoneyTransfer>> getTransferDataStream(
      {required MoneyTransferQueryConfig config, required String uid}) {
    Query query;
    query = paymentsCollection
        .where("transferDetails.senderId", isEqualTo: config.senderId!)
        .orderBy("createdAt", descending: true);
    if (config.maxNumberReturns != null)
      query = query.limit(config.maxNumberReturns!);

    log.v("converting snapshot to list of money transfers");

    try {
      // convert Stream<QuerySnapshot> to Stream<List<MoneyTransfer>>
      Stream<List<MoneyTransfer>> returnStream = query.snapshots().map(
            (event) => event.docs.map(
              (doc) {
                //log.v("Data to read into MoneyTransfer document ${doc.data()}");
                return MoneyTransfer.fromJson(doc.data());
              },
            ).toList(),
          );
      return returnStream;
    } catch (e) {
      throw FirestoreApiException(
          message: "Failed to read money transfer documents into dart model",
          devDetails:
              "Are you sure your documents in the backend are valid? Are you running with an emulator? Check the logs for concrete data that could not be read into the MoneyTransfer document");
    }
  }

  ////////////////////////////////////////////////////////
  /// Everything related to quests

  // Returns dummy data for now!
  Quest? getQuest({required String questId}) {
    return getDummyQuest();
  }

  // Returns dummy data for now!
  Future pushFinishedQuest({required ActivatedQuest? quest}) async {
    if (quest == null) {
      log.wtf("Quest to push is null! This should not happen");
      return;
    }
    try {
      final docRef = activeQuestsCollection.doc();
      ActivatedQuest newQuest = quest.copyWith(
          id: docRef.id, createdAt: FieldValue.serverTimestamp());
      //log.v("Adding the following quest to firestore: ${newQuest.toJson()}");
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

  ///////////////////////////////////////////////////
  /// Functions related to markers
  Future<AFKMarker?> getMarkerFromQrCodeId({required String qrCodeId}) async {
    /////////////////////////////////////////////
    // For now we return dummy data!
    return Future.value(
        AFKMarker(id: "MarkerId", qrCodeId: "QRCodeId", lat: 49.1, lon: -122));

    //////////////////////////////////////////////
    // QuerySnapshot snapshot =
    //     await markersCollection.where(qrCodeId, isEqualTo: qrCodeId).get();
    // if (snapshot.docs.length > 1) {
    //   throw FirestoreApiException(
    //       message:
    //           "Found more than one marker with id $qrCodeId. This should never happen!",
    //       devDetails:
    //           "Maybe this is some inconsistency in the backend during development?");
    // }
    // if (snapshot.docs.length == 0) {
    //   throw FirestoreApiException(
    //       message: "No marker with id $qrCodeId found. Returning null",
    //       devDetails:
    //           "Maybe this is some inconsistency in the backend during development?");
    // }
    // final marker = Marker.fromJson(snapshot.docs[0].data());
    // return marker;
  }

  Future<List<Quest>> getQuestsWithStartMarkerId(
      {required String? startMarkerId}) async {
    return [getDummyQuest()];
    // QuerySnapshot snapshot = await questsCollection
    //     .where(startMarkerId, isEqualTo: startMarkerId)
    //     .get();
    // try {
    //   List<Quest> quests =
    //       snapshot.docs.map((e) => Quest.fromJson(e.data())).toList();
    //   return quests;
    // } catch (e) {
    //   throw FirestoreApiException(
    //     message: 'Failed to get quests with startMarkerId $startMarkerId',
    //     devDetails: 'Error thrown: $e',
    //   );
    // }
  }

  /////////////////////////////////////////////////////////
  // Collection's getter
  DocumentReference getUserStatisticsCollection({required String uid}) {
    return usersCollection
        .doc(uid)
        .collection(userStatisticsCollectionKey)
        .doc();
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
}
