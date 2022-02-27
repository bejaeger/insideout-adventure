import 'dart:async';
import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/enums/screen_time_voucher_status.dart';

class ScreenTimeService {
  final _firestoreApi = locator<FirestoreApi>();
  final CloudFunctionsApi _cloudFunctionsApi = locator<CloudFunctionsApi>();
  final log = getLogger('ScreenTimeService');

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

  Future switchScreenTimeStatus(
      {required ScreenTimePurchase screenTimePurchase,
      required String uid}) async {
    ScreenTimeVoucherStatus newStatus = screenTimePurchase.status;
    log.i("Switching status of screen time to $newStatus");
    ScreenTimePurchase newScreenTimePurchase = purchasedScreenTimeVouchers
        .where((element) => element.purchaseId == screenTimePurchase.purchaseId)
        .first
        .copyWith(status: newStatus);
    _firestoreApi.updateScreenTimePurchase(
        screenTimePurchase: newScreenTimePurchase, uid: uid);
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
