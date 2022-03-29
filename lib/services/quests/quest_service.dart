import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_ui_style.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:stacked/stacked.dart';

class QuestService with ReactiveServiceMixin {
  // -----------------------------------
  // services
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("QuestService");

  // ---------------------------------------------
  // state
  List<ActivatedQuest> activatedQuestsHistory = [];
  StreamSubscription? _pastQuestsStreamSubscription;
  //Turned local variable pvt
  List<Quest> _nearbyQuests = [];
  List<Quest> get getNearByQuest => _nearbyQuests;

  Quest? _questToUpdate;
  Quest? get getQuestToUpdate => _questToUpdate;

  bool sortedNearbyQuests = false;
  List<QuestType> allQuestTypes = [];

  void setQuestToUpdate({required Quest quest}) {
    if (quest.id.isNotEmpty) {
      _questToUpdate = quest;
    }
  }

  Future<void> updateQuestData({required Quest quest}) async {
    if (quest.id.isNotEmpty) {
      await _firestoreApi.updateQuestData(quest: quest);
    } else {
      log.wtf('You cannot provide me, an Empty Quest ID: ${quest.id}');
    }
  }

  // Get a List of Quests
  // Get Markers For the Quest.
  Future<List<AFKMarker?>?> getAllMarkers() async {
    //So Far I will only return the Markers with the FB.
    return await _firestoreApi.getAllMarkers();
  }

  // remove quest from database
  Future<void> removeQuest({required Quest quest}) async {
    try {
      if (quest.id != "") {
        await _firestoreApi.removeQuest(quest: quest);
      } else {
        log.wtf('You are Providing me Empty Ids ${quest.id}');
      }
    } catch (e) {
      log.i(e.toString());
    }
  }

  Future<AFKMarker?> getMarkerFromQrCodeId({required String qrCodeId}) async {
    // TODO: Check wether marker is in active quest or whether it needs to be downloaded!
    return await _firestoreApi.getMarkerFromQrCodeId(qrCodeId: qrCodeId);
  }

  ////////////////////////////////////////////
  /// History of quests
  // adds listener to money pools the user is contributing to
  // allows to wait for the first emission of the stream via the completer
  Future<void>? setupPastQuestsListener(
      {required Completer<void> completer,
      required String uid,
      void Function()? callback}) async {
    if (_pastQuestsStreamSubscription == null) {
      bool listenedOnce = false;
      _pastQuestsStreamSubscription =
          _firestoreApi.getPastQuestsStream(uid: uid).listen((snapshot) {
        listenedOnce = true;
        activatedQuestsHistory = snapshot
            .where((element) => element.status == QuestStatus.success)
            .toList();
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
        log.v("Listened to ${activatedQuestsHistory.length} quests");
      });
      if (!listenedOnce) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      return completer.future;
    } else {
      log.w("Already listening to list of quests, not adding another listener");
      completer.complete();
    }
  }

  Future loadNearbyQuests({bool force = false}) async {
    if (_nearbyQuests.isEmpty || force) {
      // TODO: In the future retrieve only nearby quests
      _nearbyQuests = await _firestoreApi.getNearbyQuests(
          pushDummyQuests: _flavorConfigProvider.pushAndUseDummyQuests);
      log.i("Found ${_nearbyQuests.length} nearby quests.");
    } else {
      log.i("Quests already loaded.");
    }
  }

  Future getQuestsOfType({required QuestType questType}) async {
    if (_nearbyQuests.isEmpty) {
      // Not very efficient to load all quests and then extract only the ones of a specific type!
      await loadNearbyQuests();
    }
    return extractQuestsOfType(quests: _nearbyQuests, questType: questType);
  }

  List<Quest> extractQuestsOfType(
      {required List<Quest> quests, required QuestType questType}) {
    List<Quest> returnQuests = [];
    if (quests.isNotEmpty) {
      for (Quest _q in quests) {
        if (_q.type == questType) {
          returnQuests.add(_q);
        }
      }
    } else {
      log.w('No nearby quests found');
    }
    return returnQuests;
  }

  void extractAllQuestTypes() {
    if (_nearbyQuests.isNotEmpty) {
      for (Quest _q in _nearbyQuests) {
        if (!allQuestTypes.any((element) => element == _q.type)) {
          allQuestTypes.add(_q.type);
        }
      }
    } else {
      log.w('No nearby quests found');
    }
  }

  // Very likely deprecated!
  // Useful for UI, check if active quest screen is standalone ui or map view!
  QuestUIStyle getQuestUIStyle({Quest? quest}) {
    return QuestUIStyle.standalone;
  }

  Future sortNearbyQuests() async {
    if (_nearbyQuests.isNotEmpty) {
      log.i("Check distances for current quest list");

      // need to use normal for loop to await results
      for (var i = 0; i < _nearbyQuests.length; i++) {
        if (_nearbyQuests[i].startMarker != null) {
          double distance =
              await _geolocationService.distanceBetweenUserAndCoordinates(
                  lat: _nearbyQuests[i].startMarker!.lat,
                  lon: _nearbyQuests[i].startMarker!.lon);
          _nearbyQuests[i] =
              _nearbyQuests[i].copyWith(distanceFromUser: distance);
        } else {
          _nearbyQuests[i] = _nearbyQuests[i]
              .copyWith(distanceFromUser: kUnrealisticallyHighDistance);
          sortedNearbyQuests = true;
        }
      }
      _nearbyQuests
          .sort((a, b) => a.distanceFromUser!.compareTo(b.distanceFromUser!));
    } else {
      log.w(
          "Curent quests empty, or distance check not required. Can't check distances");
    }
    log.i("Notify listeners");
  }

  Future getQuest({required String questId}) async {
    return _firestoreApi.getQuest(questId: questId);
  }

  Future<bool> createQuest({required Quest quest}) async {
    //TODO: Refactor this code.
    if (quest.id.isNotEmpty) {
      return await _firestoreApi.createQuest(quest: quest);
    }
    return false;

    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
  }

  // Changed the Scope of the Method. from _pvt to public
  Future<List<Quest>> downloadNearbyQuests() async {
    return await _firestoreApi.downloadNearbyQuests();
  }

  Future<List<Quest>> getQuestsWithStartMarkerId(
      {required String markerId}) async {
    // get Quests with start marker id
    late List<Quest> quests;
    if (_nearbyQuests.length == 0) {
      quests = await _firestoreApi.downloadQuestsWithStartMarkerId(
          startMarkerId: markerId);
    } else {
      quests = _nearbyQuests
          .where((element) => element.startMarker?.id == markerId)
          .toList();
    }
    return quests;
  }

  void clearData() {
    log.i("Clear quest history");
    activatedQuestsHistory = [];
    _nearbyQuests = [];
    _questToUpdate = null;
    allQuestTypes = [];
    sortedNearbyQuests = false;
    _pastQuestsStreamSubscription?.cancel();
    _pastQuestsStreamSubscription = null;
  }
}
