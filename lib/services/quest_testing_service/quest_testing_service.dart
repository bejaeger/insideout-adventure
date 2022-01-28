import 'dart:async';
import 'dart:math';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/helpers/quest_data_point.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nanoid/nanoid.dart';

import 'dart:io' show Platform;
import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/general/property.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/notion/objects/database.dart';
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

  // secret of page
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
  bool _isPermanentUserMode = true;

  int? distanceFilter;

  String? deviceInfoString;
  String? machineName;

  String? _questTrialId;
  String? _questId;
  String? _questName;
  String? _questCategory;
  String? _currentUserName;

  bool _pushToNotion = false;
  int _numberQuestDataPoints = 0;

  Database? _questDataPointsDatabase;

  // counter whether data is pushed
  // to wait in case function is called a second time
  Map<String, Completer> completers = {};
  List<String> keyCompleterPrevious = [];

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

  void maybeReset() async {
    if (!isRecordingLocationData) return;
    allQuestDataPoints = [];
    _questTrialId = null;
    _questId = null;
    _questCategory = null;
    _questDataPointsDatabase = null;
    _numberQuestDataPoints = 0;
    keyCompleterPrevious = [];
    completers = {};
  }

  void maybeInitialize({
    ActivatedQuest? activatedQuest,
    String? activatedQuestTrialId,
    User? user,
  }) {
    if (!isRecordingLocationData) return;
    // function called multiple times with different inputs;
    // with the ?? we don't overwrite previously configured variables
    if (activatedQuestTrialId != null) {
      _questTrialId = activatedQuestTrialId;
    }
    if (activatedQuest != null) {
      _questId = activatedQuest.quest.id;
      _questName = activatedQuest.quest.name;
    }
    if (activatedQuest != null) {
      _questCategory = describeEnum(activatedQuest.quest.type).toString();
    }
    if (user != null) {
      _currentUserName = user.fullName;
    }
    log.i(
        "Initialized quest testing data for quest with trial id '$_questTrialId', and quest id '$_questId' and user name $_currentUserName");
  }

  Future maybeRecordData({
    required QuestDataPointTrigger trigger,
    String? userEventDescription,
    Position? position,
    String? questTrialId,
    ActivatedQuest? activatedQuest,
    bool pushToNotion = false,
    bool onlyIfDatabaseAlreadyCreated = false,
  }) async {
    if (onlyIfDatabaseAlreadyCreated && _questDataPointsDatabase == null)
      return;
    if (!isRecordingLocationData) return;
    QuestDataPoint questDataPoint = await getQuestDataPoint(
      trigger: trigger,
      position: position,
      questTrialId: questTrialId,
      activatedQuest: activatedQuest,
      userEventDescription: userEventDescription,
    );
    _numberQuestDataPoints = _numberQuestDataPoints + 1;
    log.v("Adding quest data point location entry");
    bool returnValue = true;
    if (pushToNotion) {
      String keyCompleterNew = nanoid(8);
      completers[keyCompleterNew] = Completer();
      try {
        // the following pushes the data.
        // in case this function is called multiple times we await the completer
        keyCompleterPrevious.add(keyCompleterNew);
        if ((completers.length) > 1) {
          if (completers[
                  keyCompleterPrevious[keyCompleterPrevious.length - 2]] !=
              null) {
            await completers[
                    keyCompleterPrevious[keyCompleterPrevious.length - 2]]!
                .future;
          }
        }
        final result = await pushNotionDatabaseEntry(questDataPoint);
        if (completers[keyCompleterNew] != null) {
          completers[keyCompleterNew]!.complete();
          completers.remove(keyCompleterNew);
        }

        if (result == true) {
          questDataPoint.pushedToNotion = true;
        }
      } catch (e) {
        log.i("completers.length = ${completers.length}");
        log.i("indexCompleter.= $keyCompleterNew");
        log.e("Error pushing entry to notion db: $e");
        log.e("User desription: $userEventDescription");
        if (completers[keyCompleterNew] != null) {
          completers[keyCompleterNew]!.complete();
        }
        completers.remove(keyCompleterNew);
        returnValue = false;
      }
    }
    addQuestDataPoint(dataPoint: questDataPoint);
    return returnValue;
  }

  void addQuestDataPoint({required QuestDataPoint dataPoint}) {
    allQuestDataPoints.add(dataPoint);
  }

  Future getQuestDataPoint({
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
      timestamp: DateTime.now(),
      questCategory: _questCategory,
      entryNumber: _numberQuestDataPoints,
      triggeredBy: trigger,
      livePosition: position ?? geolocationService.getUserLivePositionNullable,
      currentPosition: null,
      lastKnownPosition: null,
      currentLocationDistance: geolocationService.getCurrentDistancesToGoal(),
      liveLocationDistance: geolocationService.getLiveDistancesToGoal(),
      // liveLocationAccuracy: geolocationService.getLiveDistancesToGoal(),
      lastKnownLocationDistance:
          geolocationService.getLastKnownDistancesToGoal(),
      userEventDescription: userEventDescription,
    );
    return questDataPoint;
  }

  // ------------------------------------------------
  // -------------------------------------------------

  Future pushAllPositionsToNotion() async {
    for (int i = 0; i < allQuestDataPoints.length; i++) {
      final ok = await pushNotionDatabaseEntry(allQuestDataPoints[i]);
      if (ok) {
        allQuestDataPoints[i].pushedToNotion = true;
      }
    }
    return isAllQuestDataPointsPushed();
  }

  bool isAllQuestDataPointsPushed() {
    return !allQuestDataPoints
        .any((element) => element.pushedToNotion == false);
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
    String databaseId = "3fa2284a2aec40a5a6d03089493be25a";

    // notion.databases.create(database)

    if (deviceInfoString == null) {
      if (Platform.isAndroid) {
        // Android-specific code
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        log.v('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
        machineName = androidInfo.model;
        deviceInfoString = "machine: " +
            androidInfo.model +
            ", systemVersion: " +
            androidInfo.version.release;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        log.v('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
        machineName = iosInfo.utsname.machine;
        deviceInfoString = iosInfo.utsname.machine +
            ", systemName: " +
            iosInfo.systemName +
            ", systemVersion: " +
            iosInfo.systemVersion;
        // iOS-specific code
      }
    }

    bool isFirstDatabaseEntry = false;
    if (_questDataPointsDatabase == null) {
      isFirstDatabaseEntry = true;
      // TODO: Test if creating new database works. Would be useful!
      final String newInputsPageId = "e920b32e58b345b989ad33ded2c72e9c";
      _questDataPointsDatabase = Database.newDatabase(
          parent: Parent.page(id: newInputsPageId),
          title: [
            Text(formatDate(DateTime.now()) +
                " - " +
                (_questCategory ?? "") +
                " - " +
                (machineName ?? "") +
                " - " +
                (_currentUserName ?? ""))
          ]);
      if (_questDataPointsDatabase == null) {
        log.wtf("Code will crash now cause database is null!");
      }
    }

    Page newDatabaseEntry = Page(
      parent: Parent.database(
          id: _questDataPointsDatabase?.id ?? "nan"), // <- database
      title: Text(_numberQuestDataPoints.toString()),
    );

    // either add a page to an existing database
    // Or add first entry to database itself.

    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        deviceInfoKey, deviceInfoString);
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        activeQuestIdKey, entry.questId);
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        activeQuestCategoryKey, entry.questCategory);
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        trialEntryKey, entry.questTrialId ?? trial);

    // timestamps
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        currentLocationTimestampKey,
        entry.currentPosition?.timestamp.toString());
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        lastKnownLocationTimestampKey,
        entry.lastKnownPosition?.timestamp?.toString());
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        liveLocationTimestampKey, entry.livePosition?.timestamp?.toString());

    // longitude
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        currentLocationLongitudeKey,
        entry.currentPosition?.longitude.toString());
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        lastKnownLocationLongitudeKey,
        entry.lastKnownPosition?.longitude.toString());
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        liveLocationLongitudeKey, entry.livePosition?.longitude.toString());

    // latitude
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        currentLocationLatitudeKey, entry.currentPosition?.latitude.toString());
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        lastKnownLocationLatitudeKey,
        entry.lastKnownPosition?.latitude.toString());
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        liveLocationLatitudeKey, entry.livePosition?.latitude.toString());

    // accuracy
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        currentLocationAccuracyKey,
        entry.currentPosition?.accuracy.toStringAsFixed(2));
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        lastKnownLocationAccuracyKey,
        entry.lastKnownPosition?.accuracy.toStringAsFixed(2));
    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        liveLocationAccuracyKey,
        entry.livePosition?.accuracy.toStringAsFixed(2));

    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        currentLocationDistanceKey, entry.currentLocationDistance);
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        liveLocationDistanceKey, entry.liveLocationDistance);
    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        lastKnownLocationDistanceKey, entry.lastKnownLocationDistance);

    addNotionDatabaseTextProperty(
        newDatabaseEntry,
        _questDataPointsDatabase,
        triggeredByKey,
        entry.triggeredBy != null
            ? describeEnum(entry.triggeredBy!).toString()
            : null);

    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        userEventDescriptionKey, entry.userEventDescription);

    addNotionDatabaseTextProperty(newDatabaseEntry, _questDataPointsDatabase,
        timestampKey, entry.timestamp.toString());

    try {
      late NotionResponse notionResponse;
      if (isFirstDatabaseEntry) {
        // Create new database!
        notionResponse =
            await notion.databases.create(_questDataPointsDatabase!);
        _questDataPointsDatabase?.id = notionResponse.database?.id ?? "nan";
        newDatabaseEntry.parent =
            Parent.database(id: _questDataPointsDatabase?.id ?? "nan");
        notionResponse = await notion.pages.create(newDatabaseEntry);
        log.i("Created new notion database");
      } else {
        notionResponse = await notion.pages.create(newDatabaseEntry);
      }
      if (notionResponse.hasError) {
        log.e("Error when pushing data to notion: ${notionResponse.message}");
        return false;
      } else {
        log.v("Pushed entry to notion database");
        return true;
      }
    } catch (e) {
      log.wtf(e);
      return false;
    }
  }

  void addNotionDatabaseTextProperty(Page page, Database? database,
      String propertyName, String? propertyContent) {
    page.addProperty(
      name: propertyName,
      property: RichTextProp(
        content: [
          Text(propertyContent ?? "-"),
        ],
      ),
    );
    if (database != null) {
      database.addProperty(
        name: propertyName,
        property: RichTextProp(
          content: [
            Text(propertyContent ?? "-"),
          ],
        ),
      );
    }
  }

  // -----------------------------------------
  /// helpers
  ///
  ///  these are the names of the properties in the notion database
  String currentLocationDistanceKey = "currentLocationDistance";
  String liveLocationDistanceKey = "1liveLocationDistance";
  String lastKnownLocationDistanceKey = "lastKnownLocationDistance";
  String triggeredByKey = "4triggeredBy";
  String userEventDescriptionKey = "3userEventDescription";

  String currentLocationTimestampKey = "currentLocationTimestamp";
  String liveLocationTimestampKey = "5liveLocationTimestamp";
  String lastKnownLocationTimestampKey = "lastKnownLocationTimestamp";

  String timestampKey = "6timestamp";

  String currentLocationLatitudeKey = "currentLocationLatitude";
  String liveLocationLatitudeKey = "liveLocationLatitude";
  String lastKnownLocationLatitudeKey = "lastKnownLocationLatitude";

  String currentLocationLongitudeKey = "currentLocationLongitude";
  String liveLocationLongitudeKey = "liveLocationLongitude";
  String lastKnownLocationLongitudeKey = "lastKnownLocationLongitude";

  String currentLocationAccuracyKey = "currentLocationAccuracy";
  String liveLocationAccuracyKey = "2liveLocationAccuracy";
  String lastKnownLocationAccuracyKey = "lastKnownLocationAccuracy";

  String trialEntryKey = "questTrial";
  String deviceInfoKey = "deviceInfo";
  String activeQuestIdKey = "questId";
  String activeQuestCategoryKey = "questCategory";
}
