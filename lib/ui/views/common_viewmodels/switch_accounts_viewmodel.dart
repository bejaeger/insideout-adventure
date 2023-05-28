import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/guardian_reference/guardian_reference.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/guardian_verification_status.dart';
import 'package:afkcredits/services/email_service/email_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

abstract class SwitchAccountsViewModel extends QuestViewModel {
  final log = getLogger("SwitchAccountsViewModel");
  final EmailService _emailService = locator<EmailService>();
  final String? wardUid;

  User? get ward => userService.supportedWards[wardUid];
  UserStatistics get stats => userService.supportedWardStats[wardUid]!;
  List<ActivatedQuest> get history =>
      userService.supportedWardQuestsHistory[wardUid]!;

  SwitchAccountsViewModel({this.wardUid});

  Future handleGuardianConsent() async {
    if (currentUser.guardianVerificationStatus ==
        GuardianVerificationStatus.verified) {
      return;
    } else {
      // TODO: Implement logic for parental consent

      // Logic:
      // 1. Go to guardianConsentView (link terms&conditions and privacy policy)
      // 2. Have them input an email (as default use email they signed up with)
      // 3. Send email with code when they click send code via email
      // 4. Move to next screen where they input the code
      // 5. When they accept, update guardianVerificationStatus to verified

      // Can use same code as in creation of quest or creation of user!

      // TODO: Maybe need to do that logic in the creation of the user already?

      _emailService.sendConsentEmail(
          code: "AB38",
          userName: "Alfred Super Boy",
          email: "benjamin.jaeger@posteo.de");
      userService.updateGuardianVerificationStatus(
          status: GuardianVerificationStatus.pending);
    }
  }

  Future handleSwitchToWardEvent({String? wardUidInput}) async {
    User? tmpWard;
    if (wardUidInput != null) {
      tmpWard = userService.supportedWards[wardUidInput];
    } else {
      tmpWard = ward;
    }

    // await handleGuardianConsent();

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
