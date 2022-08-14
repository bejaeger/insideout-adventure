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

  ///////////////////////////////////////////////
  /// Switch from explorer back to sponsor account
  Future handleSwitchToExplorerEvent() async {
    // check if explorerUid is set:
    if (explorerUid == null || explorer == null) {
      log.e("Please provide an explorerUid you want to switch to!");
      await showGenericInternalErrorDialog();
      return;
    }

    // Check if user wants to set PIN
    final result = await bottomSheetService.showBottomSheet(
        title: "Switch to " + explorer!.fullName + "'s account",
        confirmButtonTitle: "With Passcode",
        cancelButtonTitle: "Without Passcode");

    if (result?.confirmed == true) {
      // Set PIN
      log.i("Asking to set PIN before switching to explorer session");
      final pinResult = await navigationService.navigateTo(Routes.setPinView);

      // If PIN not set correctly, show bottom sheet of this function again
      if (pinResult == null) {
        // ! Important return here
        return;
      } else {
        // Store PIN in local storage!
        // And keep reference to currently logged in user!
        // We don't even need google auth!
        await userService.saveSponsorReference(
            uid: currentUser.uid,
            pin: pinResult.pin,
            authMethod: currentUser.authMethod);
        await switchToExplorerAccount();
      }
    }
    if (result?.confirmed == false) {
      await userService.saveSponsorReference(
          uid: currentUser.uid, authMethod: currentUser.authMethod);
      await switchToExplorerAccount();
    }
  }

  Future switchToExplorerAccount() async {
    setBusy(true);
    // Clear all service data but keep logged in with firebase!
    await clearServiceData(logOutFromFirebase: false);

    try {
      log.i("Syncing explorer account");
      await userService.syncUserAccount(
          uid: explorerUid, fromLocalStorage: true);
    } catch (e) {
      log.wtf("Error when trying to sync explorer account.");
      await dialogService.showDialog(
          title: "Internal Failure",
          description: "Sorry, an internal error occured: $e");
      await navigationService.clearStackAndShow(Routes.loginView);
      return;
    }
    // navigate to screen
    await clearStackAndNavigateToHomeView();

    setBusy(false);
  }

  ///////////////////////////////////////////////
  /// Switch from explorer back to sponsor account

  Future handleSwitchToSponsorEvent() async {
    // If no reference found give hint what to do
    if (userService.sponsorReference == null) {
      await dialogService.showDialog(
          title: "Error",
          description:
              "No reference to sponsor found. Please first logout and then sign in to a sponsor account.");
      return;
    } else {
      if (userService.sponsorReference!.withPasscode) {
        // user has to type passcode to switch
        //layoutService.setShowBottomNavBar(false);
        final pinResult = await navigationService.navigateTo(Routes.setPinView);
        if (pinResult == null) {
          return;
        } else {
          // Check if pin is correct
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
        // no passcode provided.
        final confirmation = await bottomSheetService.showBottomSheet(
            title: "Do you want to switch to the associated sponsor account?",
            confirmButtonTitle: "Switch",
            cancelButtonTitle: "Cancel");
        if (confirmation?.confirmed == true) {
          await switchToSponsorAccount(
              sponsorReference: userService.sponsorReference!);
        }
      }
      //layoutService.setShowBottomNavBar(true);
    }
  }

  Future switchToSponsorAccount(
      {required SponsorReference sponsorReference}) async {
    setBusy(true);
    // Clear all service data but keep logged in with firebase!
    log.i("Clearing all explorer data");
    //await Future.delayed(Duration(seconds: 5));
    await clearServiceData(logOutFromFirebase: false);
    try {
      log.i("Syncing sponsor account");
      await userService.syncUserAccount(
          uid: sponsorReference.uid, fromLocalStorage: false);
    } catch (e) {
      log.wtf("Error when trying to sync explorer account.");
      await dialogService.showDialog(
          title: "Internal Failure",
          description: "Sorry, an internal error occured: $e");
      navigationService.clearStackAndShow(Routes.loginView);
      return;
    }
    // navigate to screen
    await clearStackAndNavigateToHomeView();
    userService.clearSponsorReference();
    setBusy(false);
  }
}
