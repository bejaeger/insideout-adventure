import 'dart:io';

import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/apis/notion_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/feedback/feedback.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/services/email_service/email_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:afkcredits/app/app.logger.dart';

// service for managing feedback campaigns!

class FeedbackService {
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final NotionApi _notionApi = locator<NotionApi>();
  final EmailService _emailService = locator<EmailService>();
  final UserService _userService = locator<UserService>();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final log = getLogger("FeedbackService");

  FeedbackCampaignInfo? feedbackCampaignInfo;

  Future<String> getCurrentFeedbackCampaignDocumentKey() async {
    FeedbackCampaignInfo info = await loadFeedbackCampaignInfo();
    return info.currentCampaign;
  }

  Future loadFeedbackCampaignInfo() async {
    feedbackCampaignInfo = await _firestoreApi.getFeedbackCampaignInfo();
  }

  Future updateFeedbackCampaignInfo() async {
    if (feedbackCampaignInfo == null ||
        feedbackCampaignInfo!.takenByUserWithUids == null) {
      return;
    }
    List<String> uids = List.from(feedbackCampaignInfo!.takenByUserWithUids!);
    if (!feedbackCampaignInfo!.takenByUserWithUids!
        .contains(_userService.currentUser.uid)) {
      uids.add(_userService.currentUser.uid);
    }
    feedbackCampaignInfo =
        feedbackCampaignInfo!.copyWith(takenByUserWithUids: uids);
    await _firestoreApi.updateFeedbackCampaignInfo(
        feedbackCampaignInfo: feedbackCampaignInfo!);
  }

  bool userHasGivenFeedback() {
    if (feedbackCampaignInfo == null || feedbackCampaignInfo!.surveyUrl == "") {
      // when there is no feedback campaign or survey link, return true
      return true;
    }
    if (feedbackCampaignInfo!.takenByUserWithUids == null) {
      log.wtf(
          "feedbackCampaignInfo!.takenByUserWithUids is NULL. This should never happen");
      return true;
    }
    return feedbackCampaignInfo!.takenByUserWithUids!
        .contains(_userService.currentUser.uid);
  }

  Future uploadFeedback(
      {required Feedback feedback, String? currentFeedbackDocumentKey, String? uid, String? email}) async {
    if (currentFeedbackDocumentKey == null) {
      currentFeedbackDocumentKey = generalFeedbackDocumentKey;
    }
    await _firestoreApi.uploadFeedback(
        feedback: feedback, feedbackDocumentKey: currentFeedbackDocumentKey);
    _notionApi.uploadFeedback(feedback: feedback);
    try {
      await _emailService.sendFeedbackEmail(message: feedback.feedback, email: email, uid: uid);
    } catch(e) {
      // pass silently for now
      log.e("Error sending feedback email: $e");
    }
  }

  Future getDeviceInfoString() async {
    String deviceInfoString = "";
    if (!kIsWeb && Platform.isAndroid) {
      // Android-specific code
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log.v('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      deviceInfoString = "machine: " +
          androidInfo.model +
          ", systemVersion: " +
          androidInfo.version.release;
    } else if (!kIsWeb && Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log.v('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      deviceInfoString = iosInfo.utsname.machine +
          ", systemName: " +
          iosInfo.systemName +
          ", systemVersion: " +
          iosInfo.systemVersion;
      // iOS-specific code
    }
    return deviceInfoString;
  }
}
