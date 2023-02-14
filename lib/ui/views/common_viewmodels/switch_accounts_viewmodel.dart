import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/sponsor_reference/sponsor_reference.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

abstract class SwitchAccountsViewModel extends QuestViewModel {
  final log = getLogger("SwitchAccountsViewModel");
  final String? explorerUid;

  User? get explorer => userService.supportedExplorers[explorerUid];
  UserStatistics get stats => userService.supportedExplorerStats[explorerUid]!;
  List<ActivatedQuest> get history =>
      userService.supportedExplorerQuestsHistory[explorerUid]!;

  SwitchAccountsViewModel({this.explorerUid});

  Future handleSwitchToExplorerEvent({String? explorerUidInput}) async {
    User? tmpExplorer;
    if (explorerUidInput != null) {
      tmpExplorer = userService.supportedExplorers[explorerUidInput];
    } else {
      tmpExplorer = explorer;
    }

    if (tmpExplorer == null) {
      log.e("Please provide an explorerUid you want to switch to!");
      await showGenericInternalErrorDialog();
      return;
    }

    final result = await bottomSheetService.showBottomSheet(
        title: "Switch to " + tmpExplorer.fullName + "'s area",
        description: "Do you want to lock this parent area with a passcode?",
        confirmButtonTitle: "Yes",
        cancelButtonTitle: "No");
    if (result != null) {
      String? pin;
      bool setPin = result.confirmed == true;
      if (setPin) {
        log.i("Asking to set PIN before switching to explorer session");
        final pinResult = await navigationService.navigateTo(Routes.setPinView);
        if (pinResult == null) {
          return;
        }
        pin = pinResult.pin;
      }
      await switchToExplorerAccount(pin: pin, explorer: tmpExplorer);
    }
  }

  Future switchToExplorerAccount({String? pin, required User explorer}) async {
    setBusy(true);
    await userService.saveSponsorReference(
        uid: currentUser.uid, authMethod: currentUser.authMethod, pin: pin);
    await clearServiceData(
        logOutFromFirebase: false, doNotClearSponsorReference: true);
    mapViewModel.clearAllMapData();
    try {
      log.i("Syncing explorer account");
      await userService.syncUserAccount(
          uid: explorer.uid, fromLocalStorage: true);
    } catch (e) {
      log.wtf("Error when trying to sync explorer account.");
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

  Future handleSwitchToSponsorEvent() async {
    if (userService.sponsorReference == null) {
      await dialogService.showDialog(
          title: "Error",
          description:
              "No parent account found. Please first logout and then sign in to a parrent account.");
      return;
    } else {
      if (userService.sponsorReference!.withPasscode) {
        final pinResult = await navigationService.navigateTo(Routes.setPinView);
        if (pinResult == null) {
          return;
        } else {
          final valid =
              await userService.validateSponsorPin(pin: pinResult.pin);
          setBusy(true);
          if (valid != null && valid == true) {
            await switchToSponsorAccount(
                sponsorReference: userService.sponsorReference!);
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
          await switchToSponsorAccount(
              sponsorReference: userService.sponsorReference!);
        }
      }
    }
  }

  Future switchToSponsorAccount(
      {required SponsorReference sponsorReference}) async {
    setBusy(true);
    await clearServiceData(logOutFromFirebase: false);
    mapViewModel.clearAllMapData();
    try {
      log.i("Syncing sponsor account");
      await userService.syncUserAccount(
          uid: sponsorReference.uid, fromLocalStorage: false);
    } catch (e) {
      log.e("Error when trying to sync explorer account.");
      await dialogService.showDialog(
          title: "Internal Failure",
          description: "Sorry, an internal error occured: $e");
      navigationService.clearStackAndShow(Routes.loginView);
      return;
    }
    await clearStackAndNavigateToHomeView();
    userService.clearSponsorReference();
    setBusy(false);
  }
}
