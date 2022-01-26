import 'dart:math';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/helpers/location_entry.dart';
import 'package:afkcredits/enums/position_retrieval.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:device_info/device_info.dart';
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
// 2. option to upload all locations at the end of the quest if it wasn't already done
// 3. -> Send diagnostics


class QuestTestingService {
  late String trial;
  QuestTestingService() {
    var rng = new Random();
    trial = rng.nextInt(100000).toString();
  }

  final UserService userService = locator<UserService>();

  // TODO: Figure out why quest service can't be added here?
  // Probs because it imports geolocation service which imports quest_service again!
  // final QuestService questService = locator<QuestService>();

  // // final GeolocationService geolocationService = locator<GeolocationService>();
  final NotionClient notion =
      NotionClient(token: 'secret_q0fv8n18xW5l1PS9ipqljUphAXvmvCyXqKfGjcqXvWs');
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final log = getLogger("QuestTestingService");
  List<LocationEntry> allLocations = [];

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

  void setIsRecordingLocationData(bool b) {
    _isRecordingLocationData = b;
  }

  void setIsPermanentAdminMode(bool b) {
    _isPermanentAdminMode = b;
  }

  void setIsPermanentUserMode(bool b) {
    _isPermanentUserMode = b;
  }

  void resetSettings() {
    _isRecordingLocationData = false;
    _isPermanentAdminMode = false;
    _isPermanentUserMode = false;
    allLocations = [];
  }

  // void setNewTrialNumber() {
  // }

  Future maybeRecordData(Position position) async {
    if (isRecordingLocationData) {
      addLocationEntry(
          trigger: LocationRetrievalTrigger.liveQuest, position: position);
    }
  }

  Future addLocationEntry(
      {required LocationRetrievalTrigger trigger,
      required Position position}) async {
    final positionEntry = LocationEntry(
        //activeQuestId: questService.activatedQuest?.id,
        entryNumber: allLocations.length,
        triggeredBy: trigger,
        livePosition: position,
        currentPosition: null,
        lastKnownPosition: null);
    log.v("Adding position entry");

    bool returnValue = true;
    try {
      final result = await pushNotionDatabaseEntry(positionEntry);
      if (result == true) {
        positionEntry.pushedToNotion = true;
        log.i("Pushed entry to notion");
      }
    } catch (e) {
      log.e("Error pushing entry to notion db: $e");
      returnValue = false;
    }
    allLocations.add(positionEntry);
    return returnValue;
  }

  // ------------------------------------------------
  // -------------------------------------------------

  Future pushAllPositionsToNotion() async {
    bool ok = true;
    for (int i = 0; i < allLocations.length; i++) {
      ok = ok & await pushNotionDatabaseEntry(allLocations[i]);
    }
    return ok;
  }

  bool allLocationsPushed() {
    return !allLocations.any((element) => element.pushedToNotion == false);
  }

  Future pushNotionDatabaseEntry(LocationEntry entry) async {
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

    String deviceInfoString = "";
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

    addNotionDatabaseTextProperty(newEntry, deviceInfoKey, deviceInfoString);
    addNotionDatabaseTextProperty(
        newEntry, activeQuestIdKey, entry.activeQuestId);
    // addNotionDatabaseTextProperty(newEntry, trialEntryKey, questService.activatedQuestTrialNumber?.toString() ?? trial);
    addNotionDatabaseTextProperty(newEntry, trialEntryKey, trial);

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

    // Add calculated distance to random location in heidach
    // Map<String, String> distancesToGoal = geolocationService.getDistanceToGoal(
    //     positionEntry: entry, lat: 48.06701330843975, lon: 7.903736956224777);

    // TODO
    // GET SOME DISTANCE HERE
    // Probs good to add this already to location entry
    Map<String, String> distancesToGoal = {
      currentLocationDistanceKey: "-1",
      liveLocationDistanceKey: "-1",
      lastKnownLocationDistanceKey: "-1",
      triggeredByKey: "",
    };

    [
      currentLocationDistanceKey,
      liveLocationDistanceKey,
      lastKnownLocationDistanceKey,
      triggeredByKey
    ].forEach((element) {
      addNotionDatabaseTextProperty(
          newEntry, element, distancesToGoal[element]);
    });
    try {
      final NotionResponse notionResponse = await notion.pages.create(newEntry);
      if (notionResponse.hasError) {
        log.e(
            "Error when pushing data to notion database: ${notionResponse.message}");
        return false;
      } else {
        log.i("Created entry in notion database");
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

  String trialEntryKey = "trial";
  String deviceInfoKey = "deviceInfo";
  String activeQuestIdKey = "activeQuestId";
}
