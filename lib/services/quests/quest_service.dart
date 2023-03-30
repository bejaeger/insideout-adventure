import 'dart:async';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

class QuestService with ReactiveServiceMixin {
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("QuestService");

  List<Quest> get getNearByQuest => _nearbyQuests;
  List<Quest> get getNearByQuestTodo => _nearbyQuestsTodo;
  Quest? get getQuestToUpdate => _questToUpdate;

  double? lonAtLatestQuestDownload;
  double? latAtLatestQuestDownload;
  List<ActivatedQuest> activatedQuestsHistory = [];
  StreamSubscription? _pastQuestsStreamSubscription;
  List<Quest> _nearbyQuests = [];
  List<Quest> _nearbyQuestsTodo = [];
  Quest? _questToUpdate;
  bool sortedNearbyQuests = false;
  List<QuestType> allQuestTypes = [];
  bool showReloadQuestButton = false;
  bool isReloadingQuests = false;

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

  // not used atm
  Future<void>? setupPastQuestsListener(
      {required Completer<void> completer,
      required String uid,
      void Function()? callback}) async {
    if (_pastQuestsStreamSubscription == null) {
      bool listenedOnce = false; // not sure why this is needed
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

  Future loadNearbyQuests(
      {required List<String> sponsorIds,
      bool force = false,
      double? lat,
      double? lon,
      bool addQuestsToExisting =
          false // if true quests will be added to already downloaded ones
      }) async {
    if (_nearbyQuests.isEmpty || force) {
      // TODO: In the future retrieve only nearby quests
      try {
        Position? position;
        if (lat == null || lon == null) {
          position = await _geolocationService
              .getAndSetCurrentLocation(); // this call is supposed to be fast and just return the previously known position
        }
        latAtLatestQuestDownload = lat ?? position!.latitude;
        lonAtLatestQuestDownload = lon ?? position!.longitude;

        final newQuests = await _firestoreApi.getNearbyQuests(
            lat: latAtLatestQuestDownload!,
            lon: lonAtLatestQuestDownload!,
            radius: kDefaultQuestDownloadRadiusInKm,
            pushDummyQuests: _flavorConfigProvider.pushAndUseDummyQuests,
            sponsorIds: sponsorIds);
        if (addQuestsToExisting) {
          Set<String> existingQuests = Set.from(_nearbyQuests.map((q) => q.id));
          newQuests.forEach((newq) {
            if (!existingQuests.contains(newq.id)) {
              existingQuests.add(newq.id);
              _nearbyQuests.add(newq);
            }
          });
        } else {
          _nearbyQuests = newQuests;
        }
      } catch (e) {
        if (e is FirestoreApiException &&
            e.message == WarningNoQuestsDownloaded) {
          throw QuestServiceException(
              message: e.message,
              devDetails: e.devDetails,
              prettyDetails: e.prettyDetails);
        } else {
          rethrow;
        }
      }
      log.i("Found ${_nearbyQuests.length} nearby quests.");
    } else {
      log.i("Quests already loaded.");
    }
  }

  void removeFromNearbyQuests({required Quest quest}) {
    if (quest.id.isNotEmpty) {
      _nearbyQuests.removeWhere((element) => element.id == quest.id);
    } else {
      log.e(
          'Cannot remove quest from nearby quests, empty quest id provided ${quest.id}');
    }
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

  Future sortNearbyQuests() async {
    if (_nearbyQuests.isNotEmpty) {
      log.v("Check distances for current quest list");
      final position = await _geolocationService.getAndSetCurrentLocation();
      for (var i = 0; i < _nearbyQuests.length; i++) {
        if (_nearbyQuests[i].startMarker != null) {
          double distance = _geolocationService.distanceBetween(
              lat1: position.latitude,
              lon1: position.longitude,
              lat2: _nearbyQuests[i].startMarker!.lat,
              lon2: _nearbyQuests[i].startMarker!.lon);
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
  }

  void loadNearbyQuestsTodo({required List<String> completedQuestIds}) {
    log.v("Extracting only quests that are not completed");
    _nearbyQuestsTodo = [];
    if (_nearbyQuests.isNotEmpty) {
      _nearbyQuests.forEach(
        (element) {
          if (!completedQuestIds.contains(element.id)) {
            if (!_nearbyQuestsTodo.any((el) => el.id == element.id)) {
              _nearbyQuestsTodo.add(element);
            }
          }
        },
      );
    }
  }

  Future getQuest({required String questId}) async {
    return _firestoreApi.getQuest(questId: questId);
  }

  Future createQuest({required Quest quest}) async {
    if (quest.id.isNotEmpty) {
      return await _firestoreApi.createQuest(quest: quest);
    }
    return false;
  }

  Future<List<Quest>> getQuestsWithStartMarkerId(
      {required String markerId}) async {
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
