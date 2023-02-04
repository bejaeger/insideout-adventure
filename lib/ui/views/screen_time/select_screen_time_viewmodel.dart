import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectScreenTimeViewModel extends BaseModel {
  // ----------------------------------
  // services
  final log = getLogger("SelectScreenTimeViewModel");

  // ------------------------------------
  // getters
  int get totalAvailableScreenTime =>
      userService.getTotalAvailableScreenTime(childId: childId);
  int get afkCreditsBalance =>
      userService.getAfkCreditsBalance(childId: childId).round();
  // ------------------------
  // state
  int screenTimePreset = 20; // in minutes
  int? screenTimePresetCustom;

  // ------------------
  // constructor
  String? childId;
  SelectScreenTimeViewModel({this.childId}) {
    if (screenTimePreset > totalAvailableScreenTime) {
      screenTimePreset = totalAvailableScreenTime;
    }
  }

  // ---------------------------------
  // functions

  // preset screen time selecter / switcher
  void selectScreenTime({required int minutes}) {
    log.v("set screen time preset to $minutes min");
    screenTimePreset = minutes;
    if (screenTimePreset == -1) {
      screenTimePreset =
          userService.getTotalAvailableScreenTime(childId: childId);
    }
    notifyListeners();
  }

  // preset screen time selecter / switcher
  Future selectCustomScreenTime() async {
    DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.CustomScreenTime);
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
    // Function that starts screen time
    // Should ultimately do the following:

    // 1. Check whether enough credits are available
    if (screenTimePreset > totalAvailableScreenTime) {
      await dialogService.showDialog(
          title: "Sorry", description: "You don't have enough credits.");
      return;
    }

    // 4. Navigate to Active Screen Time Screen
    //    which also starts screen time
    //    First go to view where we can cancel the timer again.
    if (isParentAccount && childId == null) {
      log.wtf(
          "childId cannot be null when accessing screen time from parent account!");
      showGenericInternalErrorDialog();
      popView();
      return;
    }
    // Create screen time session
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
      afkCredits: double.parse(
          HerculesWorldCreditSystem.screenTimeToCredits(useSuperUserFeatures ? 1 : screenTimePreset)
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
