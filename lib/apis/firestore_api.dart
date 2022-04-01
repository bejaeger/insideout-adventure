import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/giftcards/pre_purchased_gift_cards/pre_purchased_gift_card.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/payments/money_transfer_query_config.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/datamodels/users/admin/user_admin.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/gift_card_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/screen_time_voucher_status.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreApi {
  final log = getLogger('FirestoreApi');
  final firestoreInstance = FirebaseFirestore.instance;
  //List<UserFavPlaces>? places;
  // Create user documents
  DocumentReference? _documentReference;

  List<GiftCardCategory> giftCartCategory = [];

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

//For Admin Starts Here
  Future<void> createUserAdmin({required UserAdmin userAdmin}) async {
    try {
      log.i("User:$userAdmin");
      final userAdminDocument = usersCollection.doc(userAdmin.id);
      await userAdminDocument.set(userAdmin.toJson());
      log.v('User document added to ${userAdminDocument.path}');
      //print(result);
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create new user',
        devDetails: '$error',
      );
    }
  }
  //Ends Here

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
      await _docRef.set(favouritePlaces.toJson());
      log.v('Favourite Places document added to ${_docRef.path}' + '\n');
      log.v('Your Document Reference is: ${_docRef.toString()}');
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

  //Create a List of My Favourite Places
  Future<void> addMarkers({required AFKMarker markers}) async {
    try {
      final _docRef = getMarkersDocs(markerId: markers.id);
      log.i("Document Reference: " + _docRef.toString());
      log.i("Marker ID: " + markers.id);
      await _docRef.set(markers.toJson());
      log.v('Favourite Places document added to ${_docRef.path}' + '\n');
      log.v('Your Document Reference is: ${_docRef.toString()}');
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

  ////////////////////////////////////////////////////////
  // This is the User who will managed The App Code for the BackOffice
  Future<UserAdmin?> getUserAdmin({required String uid}) async {
    log.i('userId: $uid');
    if (uid.isNotEmpty) {
      final userDoc = await usersCollection.doc(uid).get();
      if (!userDoc.exists) {
        log.v("User $uid does not exist in our DB ");
        return null;
      }
      final userData = userDoc.data();
      return UserAdmin.fromJson(userData!);
    } else {
      throw FirestoreApiException(message: 'You have passed an empty Id');
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

/* // Get Places For the Quest.
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
  } */

  // Get Markers For the Quest.
  // ignore: non_constant_identifier_names
  Future<List<AFKMarker>> getAllMarkers() async {
    final _markers = await markersCollection.get();
    if (_markers.docs.isNotEmpty) {
      try {
        return _markers.docs
            .map((docs) => AFKMarker.fromJson(docs.data()))
            .toList();
      } catch (e) {
        throw FirestoreApiException(
            message: 'Failed to get the Markers', devDetails: '$e');
      }
    } else {
      return [];
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
        return User.fromJson(doc.docs.first.data());
      } else {
        log.v("No user found with name $name");
        return null;
      }
    } catch (e) {
      log.e("Error when getting user document: $e");
    }
    return null;
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

  Future<void> updateQuestData({required Quest quest}) async {
    try {
      await questsCollection
          .doc(quest.id)
          .set(quest.toJson(), SetOptions(merge: true));

      //return result;
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

  Future<void> removeQuest({required Quest quest}) async {
    //Remove The quest from Firebase
    await questsCollection.doc(quest.id).delete();
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
    log.i("Get dummy quest");
    return getDummyQuest1();
  }

  // Returns dummy data for now!
  Future<List<Quest>> getNearbyQuests({bool? pushDummyQuests}) async {
    if (pushDummyQuests == true) {
      late List<Quest> questsOnFirestore;
      try {
        log.i("Downloading quests now");
        questsOnFirestore = await downloadNearbyQuests();
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
      return await downloadNearbyQuests();
    }
  }

  Future _uploadQuest({required Quest quest}) async {
    log.i("Upload quest with id ${quest.id} to firestore");
    //Get the Document Created Reference
    _documentReference = await questsCollection.add(
      quest.toJson(),
    );
    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
    await questsCollection
        .doc(_documentReference!.id)
        .update({'id': _documentReference!.id});
  }

  Future<bool> createQuest({required Quest quest}) async {
    log.i("Upload quest with id ${quest.id} to firestore");
    //Get the Document Created Reference
    _documentReference = await questsCollection.add(quest.toJson());
    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
    await questsCollection
        .doc(_documentReference!.id)
        .update({'id': _documentReference!.id});
    if (_documentReference!.id.isNotEmpty) {
      log.i(
          'This is the Document Id Being Created Harguilar ${_documentReference!.id}');
      return true;
    }
    return false;
  }

  // TODO: Only dowload nearby quests in the future
  // Changed the Scope of the Method. from _pvt to public
  Future<List<Quest>> downloadNearbyQuests() async {
    final quests = await questsCollection.get();
    if (quests.docs.isNotEmpty) {
      log.v('Found list of quests in database');
      return quests.docs
          .map(
            (docs) => Quest.fromJson(
              docs.data(),
            ),
          )
          .toList();
    } else {
      log.wtf('There is no \'quests\' collection on firestore');
      throw FirestoreApiException(
          message: "Quest data could not be found",
          devDetails: "Quest document is empty");
    }
  }

  // Returns dummy data for now!
  Future pushFinishedQuest({required ActivatedQuest? quest}) async {
    if (quest == null) {
      log.wtf("Quest to push is null! This should not happen");
      return;
    }
    try {
      final docRef = activatedQuestsCollection.doc();
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

  Future<List<Quest>> downloadQuestsWithStartMarkerId(
      {required String? startMarkerId}) async {
    // List<Quest> quests = await getNearbyQuests();
    // return quests
    //     .where((element) => element.startMarker.id == startMarkerId)
    //     .toList();
    QuerySnapshot snapshot = await questsCollection
        .where(startMarkerId, isEqualTo: startMarkerId)
        .get();
    try {
      List<Quest> quests =
          snapshot.docs.map((e) => Quest.fromJson(e.data())).toList();
      return quests;
    } catch (e) {
      throw FirestoreApiException(
        message: 'Failed to get quests with startMarkerId $startMarkerId',
        devDetails: 'Error thrown: $e',
      );
    }
  }

  ////////////////////////////////////////////////////////
  // Quest collection
  Stream<List<ActivatedQuest>> getPastQuestsStream({required String uid}) {
    try {
      final returnStream = activatedQuestsCollection
          .where("uids", arrayContains: uid)
          .orderBy("createdAt", descending: true)
          .where("status",
              isEqualTo: describeEnum(QuestStatus.success.toString()))
          .snapshots()
          .map((event) => event.docs
              .map((doc) => ActivatedQuest.fromJson(doc.data()))
              .toList());
      return returnStream;
    } catch (e) {
      throw FirestoreApiException(
          message:
              "Unknown expection when listening to past quests the user has successfully done",
          devDetails: '$e');
    }
  }

  ////////////////////////////////////////////////////////
  // Quest collection
  Stream<List<Achievement>> getAchievementsStream({required String uid}) {
    // TODO: Dummy for now!
    return Stream.value(getDummyAchievements());
    // try {
    //   final returnStream = activatedQuestsCollection
    //       .where("uids", arrayContains: uid)
    //       .orderBy("createdAt", descending: true)
    //       .where("status",
    //           isEqualTo: describeEnum(QuestStatus.success.toString()))
    //       .snapshots()
    //       .map((event) => event.docs
    //           .map((doc) => ActivatedQuest.fromJson(doc.data()))
    //           .toList());
    //   return returnStream;
    // } catch (e) {
    //   throw FirestoreApiException(
    //       message:
    //           "Unknown expection when listening to past quests the user has successfully done",
    //       devDetails: '$e');
    // }
  }

  ////////////////////////////////////////////////////////
  // Gift Cards functions
  //

  Future<List<GiftCardCategory>> getGiftCardsForCategory(
      {required String categoryName}) async {
    try {
      final giftCards = await giftCardsCollection
          .where("name", isEqualTo: categoryName)
          .get();
      if (giftCards.docs.isNotEmpty) {
        log.v('This is our List of Gift Cards: $giftCards in our Database');
        return giftCards.docs
            .map((docs) => GiftCardCategory.fromJson(docs.data()))
            .toList();
      } else {
        log.wtf('You are Providing me Empty Document $giftCards' +
            GiftCardType.Steam.toString());
        throw FirestoreApiException(
            message: "Data could not be found",
            devDetails: "gift card document is empty");
      }
    } catch (e) {
      throw FirestoreApiException(
          message: "Error Was Thrown",
          devDetails: "$e" + GiftCardType.Steam.toString());
    }
  }

  Future<List<PrePurchasedGiftCard?>> getPreGiftCardsForCategory() async {
    try {
      final prePurchasedGiftCards = await preGiftCardsCollection.get();
      if (prePurchasedGiftCards.docs.isNotEmpty) {
        log.v(
            'This is our List of Gift Cards: $prePurchasedGiftCards in our Database');
        return prePurchasedGiftCards.docs
            .map(
              (docs) => PrePurchasedGiftCard.fromJson(
                docs.data(),
              ),
            )
            .toList();
      } else {
        log.wtf('You are Providing me Empty Document $prePurchasedGiftCards');
      }
    } catch (e) {
      throw FirestoreApiException(
          message: "Error Was Thrown",
          devDetails: "$e" + GiftCardType.Steam.toString());
    }
    return [];
  }

  getListQuerySnapShot({QuerySnapshot? query}) {
    List<QuerySnapshot> snapShot = [];
    if (query!.docs.isNotEmpty) {
      snapShot.add(query);
      return snapShot;
    } else
      return [];
  }

  Future<List<GiftCardCategory>> getAllGiftCards() async {
    try {
      final giftCards = await giftCardsCollection.get();
      getListQuerySnapShot(query: giftCards);
      if (giftCards.docs.isNotEmpty) {
        log.v('This is our List of Gift Cards: $giftCards in our Database');
        return giftCards.docs
            .map((docs) => GiftCardCategory.fromJson(docs.data()))
            .toList();
      } else {
        log.wtf('You are Providing me Empty Document $giftCards' +
            GiftCardType.Steam.toString());
        throw FirestoreApiException(
            message: "Data could not be found",
            devDetails: "gift card document is empty");
      }
    } catch (e) {
      throw FirestoreApiException(
          message: "Error Was Thrown",
          devDetails: "$e" + GiftCardType.Steam.toString());
    }
  }

  Stream<List<GiftCardPurchase>> getPurchasedGiftCardsStream(
      {required String uid}) {
    try {
      final returnStream = getUserGiftCardsCollection(uid: uid)
          .orderBy("purchasedAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .map((doc) => GiftCardPurchase.fromJson(doc.data()))
              .toList());
      return returnStream;
    } catch (e) {
      throw FirestoreApiException(
          message: "Unknown expection when listening to purchased gift cards",
          devDetails: '$e');
    }
  }

  Stream<List<ScreenTimePurchase>> getPurchasedScreenTimesStream(
      {required String uid}) {
    try {
      final returnStream = getUserScreenTimeCollection(uid: uid)
          .orderBy("purchasedAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .map((doc) => ScreenTimePurchase.fromJson(doc.data()))
              .toList());
      return returnStream;
    } catch (e) {
      throw FirestoreApiException(
          message: "Unknown expection when listening to purchased screen times",
          devDetails: '$e');
    }
  }

  Future updateGiftCardPurchase(
      {required GiftCardPurchase giftCardPurchase, required String uid}) async {
    getUserGiftCardsCollection(uid: uid)
        .doc(giftCardPurchase.transferId)
        .update(giftCardPurchase.toJson());
  }

  Future updateScreenTimePurchase(
      {required ScreenTimePurchase screenTimePurchase,
      required ScreenTimeVoucherStatus newStatus,
      required String uid}) async {
    late ScreenTimePurchase newScreenTimePurchase;
    newScreenTimePurchase = screenTimePurchase.copyWith(
        activatedOn: newStatus == ScreenTimeVoucherStatus.unused
            ? ""
            : FieldValue.serverTimestamp());
    await getUserScreenTimeCollection(uid: uid)
        .doc(newScreenTimePurchase.purchaseId)
        .update(newScreenTimePurchase.toJson());
  }

  Future<bool> addGiftCardCategory(
      {required GiftCardCategory giftCardCategory}) async {
    //TODO: Refactor this code .
    if (giftCardCategory.categoryId.isNotEmpty) {
      log.i("Upload quest with id ${giftCardCategory.categoryId} to firestore");
      //Get the Document Created Reference
      _documentReference =
          await giftCardsCollection.add(giftCardCategory.toJson());
      //update the newly created document reference with the Firestore Id.
      //This is to make suret that the document has the same id as the quest.
      await giftCardsCollection
          .doc(_documentReference!.id)
          .update({'id': _documentReference!.id});
      log.i(
          'These are the Documents Id Being Created Harguilar ${_documentReference!.id}');
      return true;
    }
    return false;

    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
  }

  Future<bool> insertPrePurchasedGiftCardCategory(
      {required PrePurchasedGiftCard prePurchasedGiftCard}) async {
    //TODO: Refactor this code .
    if (prePurchasedGiftCard.categoryId.isNotEmpty) {
      log.i(
          "Upload quest with id ${prePurchasedGiftCard.categoryId} to firestore");
      //Get the Document Created Reference
      _documentReference =
          await preGiftCardsCollection.add(prePurchasedGiftCard.toJson());
      //update the newly created document reference with the Firestore Id.
      //This is to make suret that the document has the same id as the quest.
      await preGiftCardsCollection
          .doc(_documentReference!.id)
          .update({'id': _documentReference!.id});
      log.i(
          'These are the Documents Id Being Created Harguilar ${_documentReference!.id}');
      return true;
    }
    return false;

    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
  }

  // !!! HIGHLY CRITICAL This is a cheat feautre for the super user
// !!! REMOVE IN PRODUCTION
  Future addAfkCreditsCheat(
      {required String uid,
      required UserStatistics currentStats,
      num deltaCredits = 50}) async {
    await getUserSummaryStatisticsDocument(uid: uid).update(currentStats
        .copyWith(
            afkCreditsBalance: currentStats.afkCreditsBalance + deltaCredits)
        .toJson());
  }
}

/////////////////////////////////////////////////////////
// Collection's getter
DocumentReference getUserStatisticsCollection({required String uid}) {
  return usersCollection.doc(uid).collection(userStatisticsCollectionKey).doc();
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

CollectionReference getUserGiftCardsCollection({required String uid}) {
  return usersCollection.doc(uid).collection(purchasedGiftCardsCollectionKey);
}

CollectionReference getUserScreenTimeCollection({required String uid}) {
  return usersCollection.doc(uid).collection(purchasedScreenTimeCollectionKey);
}
