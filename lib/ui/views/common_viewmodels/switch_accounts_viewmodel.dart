import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/guardian_reference/guardian_reference.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

abstract class SwitchAccountsViewModel extends QuestViewModel {
  final log = getLogger("SwitchAccountsViewModel");
  final String? wardUid;

  User? get ward => userService.supportedWards[wardUid];
  UserStatistics get stats => userService.supportedWardStats[wardUid]!;
  List<ActivatedQuest> get history =>
      userService.supportedWardQuestsHistory[wardUid]!;

  SwitchAccountsViewModel({this.wardUid});

  Future handleSwitchToWardEvent({String? wardUidInput}) async {
    User? tmpWard;
    if (wardUidInput != null) {
      tmpWard = userService.supportedWards[wardUidInput];
    } else {
      tmpWard = ward;
    }

    if (tmpWard == null) {
      log.e("Please provide an wardUid you want to switch to!");
      await showGenericInternalErrorDialog();
      return;
    }

    final result = await bottomSheetService.showBottomSheet(
        title: "Switch to " + tmpWard.fullName + "'s area",
        description: "Do you want to lock this parent area with a passcode?",
        confirmButtonTitle: "Yes",
        cancelButtonTitle: "No");
    if (result != null) {
      String? pin;
      bool setPin = result.confirmed == true;
      if (setPin) {
        log.i("Asking to set PIN before switching to ward session");
        final pinResult = await navigationService.navigateTo(Routes.setPinView);
        if (pinResult == null) {
          return;
        }
        pin = pinResult.pin;
      }
      await switchToWardAccount(pin: pin, ward: tmpWard);
    }
  }

  Future switchToWardAccount({String? pin, required User ward}) async {
    setBusy(true);
    await userService.saveGuardianReference(
        uid: currentUser.uid, authMethod: currentUser.authMethod, pin: pin);
    await clearServiceData(
        logOutFromFirebase: false, doNotClearGuardianReference: true);
    mapViewModel.clearAllMapData();
    try {
      log.i("Syncing ward account");
      await userService.syncUserAccount(uid: ward.uid, fromLocalStorage: true);
    } catch (e) {
      log.wtf("Error when trying to sync ward account.");
      await dialogService.showDialog(
          title: "Internal Failure",
          description: "Sorry, an internal error occured: $e");
      await navigationService.clearStackAndShow(Routes.loginView);
      return;
    }
    await clearStackAndNavigateToHomeView(
        showBewareDialog: true, showNumberQuestsDialog: true);

    setBusy(false);
  }

  Future handleSwitchToGuardianEvent() async {
    if (userService.guardianReference == null) {
      await dialogService.showDialog(
          title: "Error",
          description:
              "No parent account found. Please first logout and then sign in to a parrent account.");
      return;
    } else {
      if (userService.guardianReference!.withPasscode) {
        final pinResult = await navigationService.navigateTo(Routes.setPinView);
        if (pinResult == null) {
          return;
        } else {
          final valid =
              await userService.validateGuardianPin(pin: pinResult.pin);
          setBusy(true);
          if (valid != null && valid == true) {
            await switchToGuardianAccount(
                guardianReference: userService.guardianReference!);
          } else {
            await dialogService.showDialog(
                title: "Pin not correct",
                description: "You entered a wrong passcode.");
          }
          setBusy(false);
        }
      } else {
        final confirmation = await bottomSheetService.showBottomSheet(
            title: "Switch to parent area?",
            confirmButtonTitle: "Switch",
            cancelButtonTitle: "Cancel");
        if (confirmation?.confirmed == true) {
          await switchToGuardianAccount(
              guardianReference: userService.guardianReference!);
        }
      }
    }
  }

  Future switchToGuardianAccount(
      {required GuardianReference guardianReference}) async {
    setBusy(true);
    await clearServiceData(logOutFromFirebase: false);
    mapViewModel.clearAllMapData();
    try {
      log.i("Syncing guardian account");
      await userService.syncUserAccount(
          uid: guardianReference.uid, fromLocalStorage: false);
    } catch (e) {
      log.e("Error when trying to sync ward account.");
      await dialogService.showDialog(
          title: "Internal Failure",
          description: "Sorry, an internal error occured: $e");
      navigationService.clearStackAndShow(Routes.loginView);
      return;
    }
    await clearStackAndNavigateToHomeView();
    userService.clearGuardianReference();
    setBusy(false);
  }
}
