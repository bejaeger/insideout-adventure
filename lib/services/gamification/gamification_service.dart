import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/app/app.logger.dart';

class GamificationService {
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  final log = getLogger("GamificationService");

  List<Achievement> achievements = [];
  StreamSubscription? _achievementsStreamSubscription;

  ////////////////////////////////////////////
  /// History of quests
  // adds listener to money pools the user is contributing to
  // allows to wait for the first emission of the stream via the completer
  Future<void>? setupAchievementsListener(
      {required Completer<void> completer,
      required String uid,
      void Function()? callback}) async {
    // ! REMOVE THIS WHEN IMPLEMENTED IN DATABASE!
    _achievementsStreamSubscription?.cancel();
    _achievementsStreamSubscription = null;

    if (_achievementsStreamSubscription == null) {
      bool listenedOnce = false;
      _achievementsStreamSubscription =
          _firestoreApi.getAchievementsStream(uid: uid).listen((snapshot) {
        listenedOnce = true;
        achievements = snapshot;
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
        log.v("Listened to ${achievements.length} quests");
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

  void clearData() {
    log.i("Clear gamification data");
    achievements = [];
    _achievementsStreamSubscription?.cancel();
    _achievementsStreamSubscription = null;
  }
}
