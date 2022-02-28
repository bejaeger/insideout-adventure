import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/screen_time_voucher_status.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/string_utils.dart';

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

  Future onActivatePressed(ScreenTimePurchase screenTimePurchase,
      [bool deactivate = false]) async {
    if (!deactivate) {
      final result = await dialogService.showDialog(
        title: "Go have fun for ${screenTimePurchase.hours} hours!",
        description: "Activate the voucher and show it to your parents!",
        buttonTitle: "Activate",
        cancelTitle: "Cancel",
      );
      if (result?.confirmed == true) {
        await _screenTimeService.switchScreenTimeStatus(
            screenTimePurchase: screenTimePurchase,
            newStatus: ScreenTimeVoucherStatus.used,
            uid: currentUser.uid);
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } else {
      await _screenTimeService.switchScreenTimeStatus(
          screenTimePurchase: screenTimePurchase,
          newStatus: ScreenTimeVoucherStatus.unused,
          uid: currentUser.uid);
      // snackbarService.showSnackbar(
      //     title: "Voucher deactivated", message: "You can use it later");
      notifyListeners();
      return true;
    }
  }

  void onVoucherTap(ScreenTimePurchase screenTimePurchase) async {
    if (screenTimePurchase.status == ScreenTimeVoucherStatus.unused) {
      dialogService.showDialog(
          title: "Activate & Play",
          description: "Activate voucher and show it to your parents");
    } else {
      dialogService.showDialog(
          title: "${screenTimePurchase.hours} hours of fun!",
          description: "Activated on: " +
              formatDateDetailsType2(screenTimePurchase.activatedOn is String
                  ? DateTime.now()
                  : screenTimePurchase.activatedOn?.toDate()));
    }
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
