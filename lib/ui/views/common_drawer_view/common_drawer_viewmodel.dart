import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/services/feedback_service/feedback_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

import '../../../app/app.locator.dart';

class CommonDrawerViewModel extends BaseModel {
  final AppConfigProvider flavorConfigProvider = locator<AppConfigProvider>();
  final FeedbackService _feedbackService = locator<FeedbackService>();

  // ----------------------------------------
  // getters
  FeedbackCampaignInfo? get feedbackCampaignInfo =>
      _feedbackService.feedbackCampaignInfo;
  bool get userHasGivenFeedback => _feedbackService.userHasGivenFeedback();

  bool get showFeedbackBadge =>
      feedbackCampaignInfo?.surveyUrl != null &&
      feedbackCampaignInfo?.surveyUrl != "";

  // -----------------------------------------
  // functions
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
}
