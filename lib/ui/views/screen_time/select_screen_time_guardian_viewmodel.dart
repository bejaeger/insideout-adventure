import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/inside_out_credit_system.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/select_value_viewmodel.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_guardian_view.form.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectScreenTimeGuardianViewModel extends SelectValueViewModel {
  final UserService _userService = locator<UserService>();
  final DialogService _dialogService = locator<DialogService>();
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final log = getLogger("SelectScreenTimeGuardianViewModel");

  int get totalAvailableScreenTime =>
      _userService.getTotalAvailableScreenTime(childId: childId);
  int get afkCreditsBalance =>
      _userService.getAfkCreditsBalance(childId: childId).round();

  int? screenTimePreset;

  String childId;
  SelectScreenTimeGuardianViewModel(
      {required this.childId,
      required super.recipientInfo,
      required super.senderInfo});

  bool isValidData([bool setNoMessage = false]) {
    bool returnValue = true;
    if (amountValue == null || amountValue == "" || amountValue == "-") {
      log.w("No valid amount, $setNoMessage");
      returnValue = false;
      if (!setNoMessage) {
        setCustomValidationMessage("Please enter valid amount.");
      }
    } else if (int.tryParse(amountValue!) == null) {
      log.w("amount not int");
      returnValue = false;
      if (!setNoMessage)
        setCustomValidationMessage("Please enter a whole number.");
    } else if (double.parse(amountValue!) > 1000) {
      log.w("Amount = ${double.parse(amountValue!)}  > 1000");
      returnValue = false;
      if (!setNoMessage)
        setCustomValidationMessage(
            "You cannot start screen time of more than 1000 minutes.");
    } else if (double.parse(amountValue!) > totalAvailableScreenTime) {
      log.w(
          "Amount = ${double.parse(amountValue!)}  > total available credits!");
      returnValue = false;
      if (!setNoMessage)
        setCustomValidationMessage(
            "Your child does not have enough credits to start a ${int.parse(amountValue!)} minutes screen time session.");
    }
    if (!setNoMessage) {
      notifyListeners();
    }
    return returnValue;
  }

  bool canStartScreenTime() {
    return isValidData(true);
  }

  Future startScreenTime() async {
    if (screenTimePreset == null) {
      return;
    }
    bool enoughCreditsAvailable = screenTimePreset! <= totalAvailableScreenTime;
    if (!enoughCreditsAvailable) {
      await _dialogService.showDialog(
          title: "Not enough credits",
          description:
              "Your child needs at least $screenTimePreset credits to start a $screenTimePreset min screen time session.");
      return;
    }

    ScreenTimeSession session = ScreenTimeSession(
      sessionId: _screenTimeService.getScreenTimeSessionDocId(),
      uid: childId,
      createdByUid: currentUser.uid,
      userName: _userService.explorerNameFromUid(childId),
      minutes: screenTimePreset!,
      status: ScreenTimeSessionStatus.notStarted,
      startedAt: DateTime.now().add(
        Duration(seconds: 10),
      ), // add 10 seconds because we wait for another 10 seconds in the next view!
      afkCredits: double.parse(
          InsideOutCreditSystem.screenTimeToCredits(screenTimePreset!)
              .toString()),
    );

    log.i("Navigating to start screen time session counter");
    navToScreenTimeCounterView(session: session);
    return true;
  }

  @override
  void setFormStatus() async {
    if (amountValue != null && amountValue != "") {
      if (isValidData(false)) {
        int tmpamount = int.parse(amountValue!);
        screenTimePreset = tmpamount;
        equivalentValue = InsideOutCreditSystem.screenTimeToCredits(tmpamount);
      }
    }
    await Future.delayed(Duration(milliseconds: 2000));
    customValidationMessage = null;
  }
}
