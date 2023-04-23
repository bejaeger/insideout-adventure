import 'package:afkcredits/constants/inside_out_credit_system.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectScreenTimeViewModel extends BaseModel {
  String? childId;
  SelectScreenTimeViewModel({this.childId}) {
    if (screenTimePreset > totalAvailableScreenTime) {
      screenTimePreset = totalAvailableScreenTime;
    }
  }

  final log = getLogger("SelectScreenTimeViewModel");

  int get totalAvailableScreenTime =>
      userService.getTotalAvailableScreenTime(childId: childId);
  int get afkCreditsBalance =>
      userService.getAfkCreditsBalance(childId: childId).round();

  int screenTimePreset = 20; // in minutes
  int? screenTimePresetCustom;

  void selectScreenTime({required int minutes}) {
    log.v("set screen time preset to $minutes min");
    screenTimePreset = minutes;
    if (screenTimePreset == -1) {
      screenTimePreset =
          userService.getTotalAvailableScreenTime(childId: childId);
    }
    notifyListeners();
  }

  Future selectCustomScreenTime() async {
    DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.CustomScreenTime, barrierDismissible: true);
    if (response?.confirmed == true) {
      if (response?.data is int) {
        screenTimePreset = response?.data;
        screenTimePresetCustom = response?.data;
        log.v("set screen time preset to $screenTimePreset min");
        notifyListeners();
      } else {
        log.e(
            "Error parsing minutes from custom screen time dialog to integer. Parsed minutes is not an integer");
        await showGenericInternalErrorDialog();
      }
    }
  }

  Future startScreenTime() async {
    bool enoughCreditsAvailable = screenTimePreset <= totalAvailableScreenTime;
    if (!enoughCreditsAvailable) {
      await dialogService.showDialog(
          title: "Sorry", description: "You don't have enough credits.");
      return;
    }

    if (isParentAccount && childId == null) {
      log.wtf(
          "childId cannot be null when accessing screen time from parent account!");
      showGenericInternalErrorDialog();
      popView();
      return;
    }

    ScreenTimeSession session = ScreenTimeSession(
      sessionId: screenTimeService.getScreenTimeSessionDocId(),
      uid: isParentAccount ? childId! : currentUser.uid,
      createdByUid: currentUser.uid,
      userName: isParentAccount
          ? userService.explorerNameFromUid(childId!)
          : currentUser.fullName,
      minutes: useSuperUserFeatures ? 1 : screenTimePreset,
      status: ScreenTimeSessionStatus.notStarted,
      startedAt: DateTime.now().add(
        Duration(seconds: 10),
      ), // add 10 seconds because we wait for another 10 seconds in the next view!
      afkCredits: double.parse(InsideOutCreditSystem.screenTimeToCredits(
              useSuperUserFeatures ? 1 : screenTimePreset)
          .toString()),
    );

    if (isParentAccount ||
        !userService.currentUserSettings.isAcceptScreenTimeFirst) {
      log.i("Navigating to start screen time session counter");
      navToScreenTimeCounterView(session: session);
    } else {
      session = session.copyWith(status: ScreenTimeSessionStatus.requested);
      // if child starts screen time we first need confirmation from parents
      navToScreenTimeRequestedView(session: session);
    }
  }
}
