import 'dart:io';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/apis/notion_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/feedback/feedback.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:afkcredits/app/app.logger.dart';

// ? service for managing feedback campaigns!
class FeedbackService {
  // -------------------------------
  // services
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final NotionApi _notionApi = locator<NotionApi>();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final log = getLogger("FeedbackService");
  // --------------------------
  // functions
  Future<String> getCurrentFeedbackCampaignDocumentKey() async {
    FeedbackCampaignInfo info = await getFeedbackCampaignInfo();
    return info.currentCampaign;
  }

  Future<FeedbackCampaignInfo> getFeedbackCampaignInfo() async {
    return await _firestoreApi.getFeedbackCampaignInfo();
  }

  Future uploadFeedback(
      {required Feedback feedback, String? currentFeedbackDocumentKey}) async {
    if (currentFeedbackDocumentKey == null) {
      currentFeedbackDocumentKey = generalFeedbackDocumentKey;
    }
    await _firestoreApi.uploadFeedback(
        feedback: feedback, feedbackDocumentKey: currentFeedbackDocumentKey);
    _notionApi.uploadFeedback(feedback: feedback);
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
