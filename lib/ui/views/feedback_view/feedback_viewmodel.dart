import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/feedback/feedback.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_result.dart';
import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_service.dart';
import 'package:afkcredits/services/feedback_service/feedback_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/utils/image_selector.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'feedback_view.form.dart';
import 'package:afkcredits/app/app.logger.dart';

class FeedbackViewModel extends FormViewModel with NavigationMixin {
  // ----------------------------------
  // services
  final ImageSelector _imageSelector = locator<ImageSelector>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final FeedbackService _feedbackService = locator<FeedbackService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("FeedbackViewModel");
  // ------------------------------
  // state
  File? selectedImage;
  String? feedbackInputValidationMessage;
  bool isInitializing = true;
  FeedbackCampaignInfo? feedbackCampaignInfo;

  // --------------------------------
  // functions
  void initialize() async {
    isInitializing = true;
    notifyListeners();
    feedbackCampaignInfo = await _feedbackService.getFeedbackCampaignInfo();
    isInitializing = false;
    notifyListeners();
  }

  Future selectImage() async {
    var tmpImage = await _imageSelector.selectImage();
    if (tmpImage != null) {
      selectedImage = File(tmpImage.path);
      notifyListeners();
    }
  }

  bool isValidInput() {
    if (feedbackValue == null || feedbackValue == "") {
      return false;
    }
    return true;
  }

  Future sendFeedback({bool generalFeedback = true}) async {
    // uploading text
    if (!isValidInput() && selectedImage == null) {
      feedbackInputValidationMessage = "No feedback provided";
      notifyListeners();
      return;
    }
    setBusy(true);
    // maybe uploading image
    CloudStorageResult? result;
    if (selectedImage != null) {
      result = await _cloudStorageService.uploadImage(
          imageToUpload: selectedImage!, title: "");
      if (!result.hasError) {
        // successfully uploaded image
        log.i("Uploaded image");
      } else {
        _snackbarService.showSnackbar(
            message: "The text-based feedback will still be send",
            title: "Failure uploading image",
            duration: Duration(seconds: 2));
        await Future.delayed(Duration(seconds: 2));
      }
    }

    // ----------------------------------------------
    // prepare feedback file and upload to firestore
    FeedbackCampaignInfo campaignInfo =
        await _feedbackService.getFeedbackCampaignInfo();
    String deviceInfo = await _feedbackService.getDeviceInfoString();
    Feedback feedback = Feedback(
      uid: _userService.currentUser.uid,
      userName: _userService.currentUser.fullName,
      feedback: feedbackValue!,
      questions: campaignInfo.questions,
      campaign: campaignInfo.currentCampaign,
      imageFileName: result?.imageFileName,
      imageUrl: result?.imageUrl,
      deviceInfo: deviceInfo,
    );
    try {
      await _feedbackService.uploadFeedback(
          feedback: feedback,
          currentFeedbackDocumentKey: generalFeedback
              ? generalFeedbackDocumentKey
              : campaignInfo.currentCampaign);
    } catch (e) {
      log.e("Error uploading feedback. Error: $e");
      await _dialogService.showDialog(
          title: "Sorry",
          description: "Could not send feedback. Do you have data connection?");
      return;
    }
    // successfully uploaded feedback document
    log.i("Uploaded feedback");
    setBusy(false);
    _snackbarService.showSnackbar(
        message: "Thanks for helping us", title: "Successfully sent feedback");
    await Future.delayed(Duration(seconds: 2));
    selectedImage = null;
    notifyListeners();
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}
