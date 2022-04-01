import 'dart:async';
import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/enums/screen_time_voucher_status.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';

class ScreenTimeService {
  // ----------------------------
  // services
  final log = getLogger('ScreenTimeService');
  final UserService _userService = locator<UserService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  // -----------------------------
  // Return values and state
  int get totalAvailableScreenTime => convertCreditsToScreenTime(
      credits: _userService.currentUserStats.afkCreditsBalance);

  DateTime? screenTimeStartTime;
  bool get hasActiveScreenTime => screenTimeStartTime != null;
  int? screenTimeLeft;
  // int get screenTimeLeft =>
  //     hasActiveScreenTime ? getScreenTimeLeftInMinutes() : -1;

  // ---------------------------------
  // Functions

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  int convertCreditsToScreenTime({required num credits}) {
    double screenTimeFactor = 1;
    return (credits * screenTimeFactor).toInt();
  }

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  void startScreenTime(
      {required int minutes, required void Function(int) callback}) {
    screenTimeStartTime = DateTime.now();
    screenTimeLeft = minutes * 60; // getScreenTimeLeftInMinutes();
    // Need to start a timer here
    // that counts down the screen time
    _stopWatchService.listenToSecondTime(callback: (int tick) {
      screenTimeLeft = minutes * 60 - tick;
      // screenTimeLeft = getScreenTimeLeftInMinutes();
      callback(tick);
    });
  }

  void stopScreenTime() {
    // TODO: Deduct AFK Credits
    screenTimeStartTime = null;
    screenTimeLeft = null;
    _stopWatchService.resetTimer();
  }

  // --------------------------
  // helpers
  int getScreenTimeLeftInMinutes() {
    return DateTime.now().difference(screenTimeStartTime!).inMinutes;
  }

  ///////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  // !!! BELOW IS DEPRECATED CODE!

  final _firestoreApi = locator<FirestoreApi>();
  final CloudFunctionsApi _cloudFunctionsApi = locator<CloudFunctionsApi>();
  StreamSubscription? _purchasedScreenTimesStreamSubscription;
  List<ScreenTimePurchase> purchasedScreenTimeVouchers = [];

  ////////////////////////////////////////////
  /// History of screen time
  // adds listener to money pools the user is contributing to
  // allows to wait for the first emission of the stream via the completer
  Future<void>? setupPurchasedScreenTimeListener(
      {required Completer<void> completer,
      required String uid,
      void Function()? callback}) async {
    if (_purchasedScreenTimesStreamSubscription == null) {
      bool listenedOnce = false;
      _purchasedScreenTimesStreamSubscription = _firestoreApi
          .getPurchasedScreenTimesStream(uid: uid)
          .listen((snapshot) {
        listenedOnce = true;
        purchasedScreenTimeVouchers = snapshot;
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
        log.v("Listened to ${purchasedScreenTimeVouchers.length} screen time");
      });
      if (!listenedOnce) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      return completer.future;
    } else {
      log.w(
          "Already listening to list of purchased screen time, not adding another listener");
      completer.complete();
    }
  }

  Future switchScreenTimeStatus({
    required ScreenTimePurchase screenTimePurchase,
    required ScreenTimeVoucherStatus newStatus,
    required String uid,
  }) async {
    log.i("Switching status of screen time to $newStatus");
    ScreenTimePurchase newScreenTimePurchase =
        screenTimePurchase.copyWith(status: newStatus);
    await _firestoreApi.updateScreenTimePurchase(
        screenTimePurchase: newScreenTimePurchase,
        newStatus: newStatus,
        uid: uid);
  }

  Future purchaseScreenTime(
      {required ScreenTimePurchase screenTimePurchase}) async {
    return await _cloudFunctionsApi.purchaseScreenTime(
        screenTimePurchase: screenTimePurchase);
  }
  ////////////////////////////////////////////////////////////
  // Clean-up

  void clearData() {
    log.i("Clear purchased screen time vouchers");
    purchasedScreenTimeVouchers = [];
    _purchasedScreenTimesStreamSubscription?.cancel();
    _purchasedScreenTimesStreamSubscription = null;
  }

  void cancelPurchasedScreenTimeSubscription() {
    _purchasedScreenTimesStreamSubscription?.cancel();
    _purchasedScreenTimesStreamSubscription = null;
  }
}
