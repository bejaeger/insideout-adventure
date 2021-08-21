import 'dart:async';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/datamodels/users/user_statistics.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreApi {
  final log = getLogger('FirestoreApi');

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
                "Something must have failed before when creating user account. This is likely due to some backwards-compatibility-breaking updates to the data models or firestore collection setup.");
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

  /////////////////////////////////////////////////////////
  // Collection's getter
  CollectionReference getUserStatisticsCollection({required String uid}) {
    return usersCollection.doc(uid).collection(userStatisticsCollectionKey);
  }

  DocumentReference getUserSummaryStatisticsDocument({required String uid}) {
    return usersCollection
        .doc(uid)
        .collection(userStatisticsCollectionKey)
        .doc(userSummaryStatisticsDocumentKey);
  }
}
