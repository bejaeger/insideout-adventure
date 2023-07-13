import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/enums/guardian_verification_status.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/feedback_service/feedback_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/guardian_home/guardian_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/terms_and_privacy.dart';

import '../../../app/app.locator.dart';

class CommonDrawerViewModel extends BaseModel {
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final FeedbackService _feedbackService = locator<FeedbackService>();

  FeedbackCampaignInfo? get feedbackCampaignInfo =>
      _feedbackService.feedbackCampaignInfo;
  bool get userHasGivenFeedback => _feedbackService.userHasGivenFeedback();
  bool get hasGivenConsent => userService.hasGivenConsent;
  bool get showFeedbackBadge =>
      feedbackCampaignInfo?.surveyUrl != null &&
      feedbackCampaignInfo?.surveyUrl != "";

  void handleLogoutEvent() async {
    final result = await dialogService.showDialog(
        barrierDismissible: true,
        title: "Sure",
        description: "Are you sure you want to logout?",
        buttonTitle: "YES",
        cancelTitle: "NO");
    if (result?.confirmed == true) {
      logout();
    }
  }

  void handleDeleteAccountEvent() async {
    final result = await dialogService.showDialog(
        barrierDismissible: true,
        title: "Delete account",
        description: "Are you sure you want to delete your account?",
        buttonTitle: "YES",
        cancelTitle: "NO");
    if (result?.confirmed == true) {
      final result2 = await dialogService.showDialog(
          barrierDismissible: true,
          title: "WARNING: This action is irreversible",
          description:
              "You will loose all your data if you delete your account.",
          buttonTitle: "DELETE ACCOUNT",
          cancelTitle: "CANCEL");
      if (result2?.confirmed == true) {
        deleteAccount();
      }
    }
  }

  Future handleToggleConsent() async {
    if (hasGivenConsent) {
      final res = await dialogService.showDialog(
          barrierDismissible: true,
          title: "Sure",
          description:
              "Are you sure you want to revoke consent? You will not be able to switch to children accounts.",
          buttonTitle: "YES",
          cancelTitle: "NO");
      if (res?.confirmed == true) {
        await userService.updateGuardianVerificationStatus(
            status: GuardianVerificationStatus.notInitiated);
        popView();
        snackbarService.showSnackbar(
            title: "Revoked consent",
            message:
                "You cannot switch to children accounts without giving consent.");
      }
    } else {
      final res =
          await navigationService.navigateTo(Routes.guardianConsentView);
      if (res == true) {
        popView();
      }
    }
  }

  Future deleteAccount() async {
    snackbarService.showSnackbar(
        title: "Your account is being deleted",
        message: "Come back anytime.",
        duration: Duration(seconds: 3));
    final viewmodel = locator<GuardianHomeViewModel>();
    viewmodel.setBusy(true);
    setBusy(true);
    try {
      await clearServiceData();
      await Future.wait([
        Future.delayed(Duration(seconds: 3)),
        userService.deleteUserAccount(),
      ]);
      await navigationService.clearStackAndShow(Routes.loginView);
    } catch (error) {
      if (error is UserServiceException) {
        await dialogService.showDialog(
            title: "Error", description: error.message, buttonTitle: "OK");
      } else {
        rethrow;
      }
    }
    viewmodel.setBusy(false);
    setBusy(false);
  }
}
