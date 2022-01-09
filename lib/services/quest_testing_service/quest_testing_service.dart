import 'dart:math';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/helpers/quest_data_point.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/enums/position_retrieval.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:io' show Platform;
import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/general/property.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/notion/objects/pages.dart';
import 'package:notion_api/notion/objects/parent.dart';
import 'package:notion_api/responses/notion_response.dart';

//TODO

// 1. delete all Locations when quest is cancelled?
//    -> could ask user to send diagnostics data

// 2. option to upload all locations at the end of the quest if it wasn't already done
//    -> should be done within dialog?

// 3. -> Send diagnostics after quest

class QuestTestingService {
  late String trial;
  QuestTestingService() {
    var rng = new Random();
    trial = rng.nextInt(100000).toString();
  }
  final UserService userService = locator<UserService>();
  final GeolocationService geolocationService = locator<GeolocationService>();

  // // final GeolocationService geolocationService = locator<GeolocationService>();
  final NotionClient notion =
      NotionClient(token: 'secret_q0fv8n18xW5l1PS9ipqljUphAXvmvCyXqKfGjcqXvWs');
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final log = getLogger("QuestTestingService");
  List<QuestDataPoint> allQuestDataPoints = [];

  // // really only allow user settings when user is super user
  bool get isRecordingLocationData =>
      _isRecordingLocationData && userService.isSuperUser;
  bool get isPermanentAdminMode =>
      _isPermanentAdminMode && userService.isSuperUser;
  bool get isPermanentUserMode =>
      _isPermanentUserMode && userService.isSuperUser;

  bool _isRecordingLocationData = true;
  bool _isPermanentAdminMode = false;
  bool _isPermanentUserMode = false;

  int? distanceFilter;
  String? deviceInfoString;

  String? _questTrialId;
  String? _questId;
  String? _questCategory;

  void setIsRecordingLocationData(bool b) {
    _isRecordingLocationData = b;
  }

  void setIsPermanentAdminMode(bool b) {
    if (b == true) {
      _isPermanentUserMode = false;
    }
    _isPermanentAdminMode = b;
  }

  void setIsPermanentUserMode(bool b) {
    if (b == true) {
      _isPermanentAdminMode = false;
    }
    _isPermanentUserMode = b;
  }

  void resetSettings() {
    _isRecordingLocationData = true;
    _isPermanentAdminMode = false;
    _isPermanentUserMode = false;
    allQuestDataPoints = [];
  }

  void maybeReset() {
    if (!isRecordingLocationData) return;
    allQuestDataPoints = [];
    _questTrialId = null;
    _questId = null;
    _questCategory = null;
  }

  void maybeInitialize({
    ActivatedQuest? activatedQuest,
    String? activatedQuestTrialId,
  }) {
    if (!isRecordingLocationData) return;
    _questTrialId = activatedQuestTrialId;
    _questId = activatedQuest?.quest.id;
    _questCategory = activatedQuest != null
        ? describeEnum(activatedQuest.quest.type).toString()
        : "nan";
    log.i(
        "Initialized quest testing data for quest with trial id '$_questTrialId', and quest id '$_questId'");
  }

  Future maybeRecordData({
    required QuestDataPointTrigger trigger,
    String? userEventDescription,
    Position? position,
    String? questTrialId,
    ActivatedQuest? activatedQuest,
    bool pushToNotion = true,
  }) async {
    if (!isRecordingLocationData) return;
    QuestDataPoint questDataPoint = await addQuestDataPoint(
      trigger: trigger,
      position: position,
      questTrialId: questTrialId,
      activatedQuest: activatedQuest,
      userEventDescription: userEventDescription,
    );
    log.v("Adding quest data point location entry");
    bool returnValue = true;
    if (pushToNotion) {
      try {
        final result = await pushNotionDatabaseEntry(questDataPoint);
        if (result == true) {
          questDataPoint.pushedToNotion = true;
        }
      } catch (e) {
        log.e("Error pushing entry to notion db: $e");
        returnValue = false;
      }
    }
    allQuestDataPoints.add(questDataPoint);
    return returnValue;
  }

  Future addQuestDataPoint({
    required QuestDataPointTrigger trigger,
    Position? position,
    ActivatedQuest? activatedQuest,
    String? questTrialId,
    String? userEventDescription,
  }) async {
    if (trigger == QuestDataPointTrigger.manualLocationFetchingEvent) {
      await geolocationService.getLastKnownAndCurrentPosition(trigger: trigger);
    }
    final questDataPoint = QuestDataPoint(
      questId: activatedQuest?.quest.id ?? _questId,
      questTrialId: questTrialId ?? _questTrialId,
      questCategory: _questCategory,
      entryNumber: allQuestDataPoints.length,
      triggeredBy: trigger,
      livePosition: position,
      currentPosition: null,
      lastKnownPosition: null,
      currentLocationDistance: geolocationService.getCurrentDistancesToGoal(),
      liveLocationDistance: geolocationService.getLiveDistancesToGoal(),
      lastKnownLocationDistance:
          geolocationService.getLastKnownDistancesToGoal(),
      userEventDescription: userEventDescription,
    );
    return questDataPoint;
  }

  // ------------------------------------------------
  // -------------------------------------------------

  Future pushAllPositionsToNotion() async {
    bool ok = true;
    for (int i = 0; i < allQuestDataPoints.length; i++) {
      ok = ok & await pushNotionDatabaseEntry(allQuestDataPoints[i]);
    }
    return ok;
  }

  bool allLocationsPushed() {
    return !allQuestDataPoints.any((element) => element.pushedToNotion == false);
  }

  int numberPushedLocations() {
    return allQuestDataPoints
        .where((element) => element.pushedToNotion == true)
        .toList()
        .length;
  }

  void resetLocationsList() {
    allQuestDataPoints = [];
  }

  Future pushNotionDatabaseEntry(QuestDataPoint entry) async {
    if (entry.pushedToNotion == true) {
      log.i("location entry nr. ${entry.entryNumber} already pushed to notion");
      return false;
    }
    // ID of manually created database
    final String databaseId = "3fa2284a2aec40a5a6d03089493be25a";

    Page newEntry = Page(
      parent: Parent.database(id: databaseId), // <- database
      title: Text(entry.entryNumber.toString()),
    );

    if (deviceInfoString == null) {
      if (Platform.isAndroid) {
        // Android-specific code
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        log.v('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
        deviceInfoString = "machine: " +
            androidInfo.model +
            ", systemVersion: " +
            androidInfo.version.release;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        log.v('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
        deviceInfoString = iosInfo.utsname.machine +
            ", systemName: " +
            iosInfo.systemName +
            ", systemVersion: " +
            iosInfo.systemVersion;
        // iOS-specific code
      }
    }

    addNotionDatabaseTextProperty(newEntry, deviceInfoKey, deviceInfoString);
    addNotionDatabaseTextProperty(newEntry, activeQuestIdKey, entry.questId);
    addNotionDatabaseTextProperty(
        newEntry, activeQuestCategoryKey, entry.questCategory);
    addNotionDatabaseTextProperty(
        newEntry, trialEntryKey, entry.questTrialId ?? trial);

    // timestamps
    addNotionDatabaseTextProperty(newEntry, currentLocationTimestampKey,
        entry.currentPosition?.timestamp.toString());
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationTimestampKey,
        entry.lastKnownPosition?.timestamp?.toString());
    addNotionDatabaseTextProperty(newEntry, liveLocationTimestampKey,
        entry.livePosition?.timestamp?.toString());

    // longitude
    addNotionDatabaseTextProperty(newEntry, currentLocationLongitudeKey,
        entry.currentPosition?.longitude.toString());
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationLongitudeKey,
        entry.lastKnownPosition?.longitude.toString());
    addNotionDatabaseTextProperty(newEntry, liveLocationLongitudeKey,
        entry.livePosition?.longitude.toString());

    // latitude
    addNotionDatabaseTextProperty(newEntry, currentLocationLatitudeKey,
        entry.currentPosition?.latitude.toString());
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationLatitudeKey,
        entry.lastKnownPosition?.latitude.toString());
    addNotionDatabaseTextProperty(newEntry, liveLocationLatitudeKey,
        entry.livePosition?.latitude.toString());

    // accuracy
    addNotionDatabaseTextProperty(newEntry, currentLocationAccuracyKey,
        entry.currentPosition?.accuracy.toStringAsFixed(2));
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationAccuracyKey,
        entry.lastKnownPosition?.accuracy.toStringAsFixed(2));
    addNotionDatabaseTextProperty(newEntry, liveLocationAccuracyKey,
        entry.livePosition?.accuracy.toStringAsFixed(2));

    addNotionDatabaseTextProperty(
        newEntry, currentLocationDistanceKey, entry.currentLocationDistance);
    addNotionDatabaseTextProperty(
        newEntry, liveLocationDistanceKey, entry.liveLocationDistance);
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationDistanceKey,
        entry.lastKnownLocationDistance);

    addNotionDatabaseTextProperty(
        newEntry,
        triggeredByKey,
        entry.triggeredBy != null
            ? describeEnum(entry.triggeredBy!).toString()
            : null);

    addNotionDatabaseTextProperty(
        newEntry, userEventDescriptionKey, entry.userEventDescription);

    try {
      final NotionResponse notionResponse = await notion.pages.create(newEntry);
      if (notionResponse.hasError) {
        log.e(
            "Error when pushing data to notion database: ${notionResponse.message}");
        return false;
      } else {
        log.i("Pushed entry to notion database");
        return true;
      }
    } catch (e) {
      log.wtf(e);
      return false;
    }
  }

  void addNotionDatabaseTextProperty(
      Page page, String propertyName, String? propertyContent) {
    page.addProperty(
      name: propertyName,
      property: RichTextProp(
        content: [
          Text(propertyContent ?? "nan"),
        ],
      ),
    );
  }

  // -----------------------------------------
  /// helpers
  ///
  ///  these are the names of the properties in the notion database
  String currentLocationDistanceKey = "currentLocationDistance";
  String liveLocationDistanceKey = "liveLocationDistance";
  String lastKnownLocationDistanceKey = "lastKnownLocationDistance";
  String triggeredByKey = "triggeredBy";
  String userEventDescriptionKey = "userEventDescription";

  String currentLocationTimestampKey = "currentLocationTimestamp";
  String liveLocationTimestampKey = "liveLocationTimestamp";
  String lastKnownLocationTimestampKey = "lastKnownLocationTimestamp";

  String currentLocationLatitudeKey = "currentLocationLatitude";
  String liveLocationLatitudeKey = "liveLocationLatitude";
  String lastKnownLocationLatitudeKey = "lastKnownLocationLatitude";

  String currentLocationLongitudeKey = "currentLocationLongitude";
  String liveLocationLongitudeKey = "liveLocationLongitude";
  String lastKnownLocationLongitudeKey = "lastKnownLocationLongitude";

  String currentLocationAccuracyKey = "currentLocationAccuracy";
  String liveLocationAccuracyKey = "liveLocationAccuracy";
  String lastKnownLocationAccuracyKey = "lastKnownLocationAccuracy";

  String trialEntryKey = "questTrial";
  String deviceInfoKey = "deviceInfo";
  String activeQuestIdKey = "questId";
  String activeQuestCategoryKey = "questCategory";
}
