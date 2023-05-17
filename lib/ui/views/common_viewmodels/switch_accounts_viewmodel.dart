import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/sponsor_reference/sponsor_reference.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/parental_verification_status.dart';
import 'package:afkcredits/services/email_service/email_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

abstract class SwitchAccountsViewModel extends QuestViewModel {
  final log = getLogger("SwitchAccountsViewModel");
  final EmailService _emailService  = locator<EmailService>();
  final String? explorerUid;

  User? get explorer => userService.supportedExplorers[explorerUid];
  UserStatistics get stats => userService.supportedExplorerStats[explorerUid]!;
  List<ActivatedQuest> get history =>
      userService.supportedExplorerQuestsHistory[explorerUid]!;

  SwitchAccountsViewModel({this.explorerUid});

  Future handleParentalConsent() async {
    if (currentUser.parentalVerificationStatus == ParentalVerificationStatus.verified) {
      return;
    } else {
      // TODO: Implement logic for parental consent

      // Logic:
      // 1. Go to parentalConsentView (link terms&conditions and privacy policy)
      // 2. Have them input an email (as default use email they signed up with)
      // 3. Send email with code when they click send code via email
      // 4. Move to next screen where they input the code
      // 5. When they accept, update parentalVerificationStatus to verified
      
      // Can use same code as in creation of quest or creation of user!

      // TODO: Maybe need to do that logic in the creation of the user already?
      
      _emailService.sendConsentEmail(code: "AB38", userName: "Alfred Super Boy", email: "benjamin.jaeger@posteo.de");
      userService.updateParentalVerificationStatus(status: ParentalVerificationStatus.pending);
    }

  }

  Future handleSwitchToExplorerEvent({String? explorerUidInput}) async {
    User? tmpExplorer;
    if (explorerUidInput != null) {
      tmpExplorer = userService.supportedExplorers[explorerUidInput];
    } else {
      tmpExplorer = explorer;
    }
    
    // await handleParentalConsent();

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
