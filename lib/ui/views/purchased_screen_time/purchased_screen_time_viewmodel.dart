import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class PurchasedScreenTimeViewModel extends BaseModel {
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  List<ScreenTimePurchase> get purchasedScreenTime =>
      _screenTimeService.purchasedScreenTimeVouchers;

  Future listenToData() async {
    setBusy(true);
    Completer completerThree = Completer<void>();
    _screenTimeService.setupPurchasedScreenTimeListener(
        completer: completerThree,
        uid: currentUser.uid,
        callback: () => notifyListeners());
    await Future.wait([
      completerThree.future,
    ]);
    setBusy(false);
  }

  void onRedeemedPressed(ScreenTimePurchase screenTimePurchase) async {
    _screenTimeService.switchScreenTimeStatus(
        screenTimePurchase: screenTimePurchase, uid: currentUser.uid);
  }

  void navigateToScreenTimeView() {
    replaceWithMainView(index: BottomNavBarIndex.giftcard);
  }

  @override
  void dispose() {
    _screenTimeService.cancelPurchasedScreenTimeSubscription();
    super.dispose();
  }
}
