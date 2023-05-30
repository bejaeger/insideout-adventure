import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/enums/guardian_verification_status.dart';
import 'package:afkcredits/services/feedback_service/feedback_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
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
}
