import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/users/user_service.dart';

// https://berux.design/detective-rabbit
// https://iopscience.iop.org/article/10.1088/1742-6596/1187/5/052068/pdf#:~:text=2.1.,typically%2C%20word%20error%20rate).
class GamificationService {
  // ---------------------------------------
  // services
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final UserService _userService = locator<UserService>();

  final log = getLogger("GamificationService");

  // ----------------------------------
  // state
  List<Achievement> achievements = [];
  StreamSubscription? _achievementsStreamSubscription;

  // -------------------------------------------------------
  // Simple functions of level system
  int getCurrentLevel() {
    // every 20 points will let you reach another level
    return (_userService.currentUserStats.lifetimeEarnings *
                kTotalCreditsEarnedToLevelConversion +
            1)
        .truncate();
  }

  int getCreditsFromPreviousLevel() {
    return (_userService.currentUserStats.lifetimeEarnings %
            (1 / kTotalCreditsEarnedToLevelConversion))
        .round();
  }

  int getCreditsToNextLevel() {
    return (1 / kTotalCreditsEarnedToLevelConversion).round() -
        getCreditsFromPreviousLevel();
  }

  int getCreditsForNextLevel() {
    return ((getCurrentLevel()) / kTotalCreditsEarnedToLevelConversion).round();
  }

  double getPercentageOfNextLevel() {
    return getCreditsFromPreviousLevel() * kTotalCreditsEarnedToLevelConversion;
  }

  String getCurrentLevelName() {
    List<String> levelNames = [
      "Newbie",
      "Beginner",
      "Standard",
      "Athlete",
      "Beast",
      "Schwarzenegger",
    ];
    if (getCurrentLevel() < levelNames.length) {
      return levelNames[
          getCurrentLevel() - 1]; // minus one because level starts at 1
    } else {
      return levelNames.last;
    }
  }

  //---------------------------------------------------
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
