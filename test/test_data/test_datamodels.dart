import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:geolocator/geolocator.dart';

import 'test_constants.dart';

User getTestUserSponsor() {
  return User(
    uid: "testId",
    fullName: "testName",
    email: "test@email.com",
    role: UserRole.sponsor,
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
    authMethod: AuthenticationMethod.email
  );
}

User getTestUserExplorer() {
  return User(
    uid: "testId",
    fullName: "testName",
    email: "test@email.com",
    role: UserRole.explorer,
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
        authMethod: AuthenticationMethod.email

  );
}

User getTestUserAdmin() {
  return User(
    uid: "testId",
    fullName: "testName",
    email: "test@email.com",
    role: UserRole.admin,
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
        authMethod: AuthenticationMethod.email

  );
}

Position getTestPosition1() {
  return Position(
      longitude: 49,
      latitude: -122,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 100,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
}

Position getTestPositionAwayFromMarker1() {
  return Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 100,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
}

AFKMarker getTestMarker1() {
  return AFKMarker(
      id: kTestMarker1Id,
      qrCodeId: kTestMarker1QrCodeId,
      lat: kTestMarker1Lat,
      lon: kTestMarker1Lon);
}

AFKMarker getTestMarker2() {
  return AFKMarker(
      id: kTestMarker2Id,
      qrCodeId: kTestMarker2QrCodeId,
      lat: kTestMarker2Lat,
      lon: kTestMarker2Lon);
}

AFKMarker getTestMarker3() {
  return AFKMarker(
      id: "Marker3Id", qrCodeId: "QRCode3Id", lat: 49.2, lon: -122);
}

AFKMarker getTestMarker4() {
  return AFKMarker(
      id: "Marker4Id", qrCodeId: "QRCode4Id", lat: 49.2, lon: -122);
}

AFKMarker getTestMarkerFarAway() {
  return AFKMarker(id: "FarAwayId", qrCodeId: "FarAwayId", lat: 99, lon: 99);
}

Quest getTestQuest() {
  return Quest(
    id: kTestQuestId,
    name: "Grouse Grind",
    description: "Make it up the hill in less than 1 hour",
    afkCredits: 100,
    markers: [
      getTestMarker1(),
      getTestMarker2(),
      getTestMarker3(),
    ],
    type: QuestType.Hike,
    startMarker: getTestMarker1(),
    finishMarker: getTestMarker3(),
  );
}

ActivatedQuest getTestActivatedQuest() {
  return ActivatedQuest(
    quest: getTestQuest(),
    markersCollected: List.filled(getTestQuest().markers.length, false),
    status: QuestStatus.active,
    timeElapsed: 0,
    uids: [kTestUid],
  );
}

ActivatedQuest getTestActivatedAndCompleteQuest() {
  return ActivatedQuest(
    quest: getTestQuest(),
    markersCollected: List.filled(getTestQuest().markers.length, true),
    status: QuestStatus.active,
    timeElapsed: 0,
  );
}

ActivatedQuest getTestActivatedButIncompleteQuest() {
  return ActivatedQuest(
    quest: getTestQuest(),
    markersCollected: List.filled(getTestQuest().markers.length, false),
    status: QuestStatus.active,
    timeElapsed: 0,
  );
}

ActivatedQuest getTestSuccessQuest() {
  return ActivatedQuest(
    quest: getTestQuest(),
    markersCollected: List.filled(getTestQuest().markers.length, true),
    status: QuestStatus.success,
    timeElapsed: 0,
  );
}

ActivatedQuest getTestIncompleteQuest() {
  return ActivatedQuest(
    quest: getTestQuest(),
    markersCollected: List.filled(getTestQuest().markers.length, false),
    status: QuestStatus.incomplete,
    timeElapsed: 0,
  );
}
