import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
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
import 'package:url_launcher/url_launcher.dart';

import 'feedback_view.form.dart';

class FeedbackViewModel extends FormViewModel with NavigationMixin {
  final ImageSelector _imageSelector = locator<ImageSelector>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final FeedbackService _feedbackService = locator<FeedbackService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("FeedbackViewModel");

  FeedbackCampaignInfo? get feedbackCampaignInfo =>
      _feedbackService.feedbackCampaignInfo;
  bool get userHasGivenFeedback => _feedbackService.userHasGivenFeedback();

  File? selectedImage;
  String? feedbackInputValidationMessage;
  bool isInitializing = true;

  void initialize() async {
    isInitializing = true;
    notifyListeners();
    await _feedbackService.loadFeedbackCampaignInfo();
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
    if (!isValidInput() && selectedImage == null) {
      feedbackInputValidationMessage = "No feedback provided";
      notifyListeners();
      return;
    }
    setBusy(true);
    CloudStorageResult? result;
    if (selectedImage != null) {
      result = await _cloudStorageService.uploadImage(
          imageToUpload: selectedImage!, title: "");
      if (!result.hasError) {
        log.i("Uploaded image");
      } else {
        _snackbarService.showSnackbar(
            message: "The text-based feedback will still be send",
            title: "Failure uploading image",
            duration: Duration(seconds: 2));
        await Future.delayed(Duration(seconds: 2));
      }
    }

    await _feedbackService.loadFeedbackCampaignInfo();
    String deviceInfo = await _feedbackService.getDeviceInfoString();
    Feedback feedback = Feedback(
      uid: _userService.currentUser.uid,
      userName: _userService.currentUser.fullName,
      feedback: feedbackValue!,
      questions: feedbackCampaignInfo?.questions ?? [""],
      campaign: feedbackCampaignInfo?.currentCampaign ?? "",
      imageFileName: result?.imageFileName,
      imageUrl: result?.imageUrl,
      deviceInfo: deviceInfo,
    );
    try {
      await _feedbackService.uploadFeedback(
          feedback: feedback,
          currentFeedbackDocumentKey: generalFeedback
              ? generalFeedbackDocumentKey
              : feedbackCampaignInfo?.currentCampaign,
              uid: _userService.currentUser.uid,
              email: _userService.currentUser.email);
    } catch (e) {
      log.e("Error uploading feedback. Error: $e");
      await _dialogService.showDialog(
          title: "Sorry",
          description: "Could not send feedback. Do you have data connection?");
      return;
    }
    log.i("Uploaded feedback");
    setBusy(false);
    _snackbarService.showSnackbar(
        message: "Thanks for helping us", title: "Successfully sent feedback");
    await Future.delayed(Duration(seconds: 2));
    selectedImage = null;
    notifyListeners();
  }

  Future<void> launchUrlViewModel(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      } else {
        await _feedbackService.updateFeedbackCampaignInfo();
      }
    } else {
      print("=> Can't launch URL");
    }
    notifyListeners();
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}
