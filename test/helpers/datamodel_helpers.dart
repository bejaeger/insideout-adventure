import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/user_role.dart';

User getTestUserSponsor() {
  return User(
    uid: "testId",
    fullName: "testName",
    email: "test@email.com",
    role: UserRole.sponsor,
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
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
  );
}

Quest getTestQuest() {
  return Quest(
    id: kTestQuestId,
    name: "Grouse Grind",
    description: "Make it up the hill in less than 1 hour",
    afkCredits: 100,
    markers: [
      Marker(id: "MarkerId", qrCodeId: "QRCodeId", lat: 49, lon: -122),
      Marker(id: "MarkerId", qrCodeId: "QRCodeId", lat: 49.5, lon: -122)
    ],
    type: QuestType.Hike,
    startMarker:
        Marker(id: "MarkerId", qrCodeId: "QRCodeId", lat: 49, lon: -122),
    finishMarker:
        Marker(id: "MarkerId", qrCodeId: "QRCodeId", lat: 49.5, lon: -122),
  );
}

ActivatedQuest getTestActivatedQuest() {
  return ActivatedQuest(
    quest: getTestQuest(),
    markersCollected: List.filled(getTestQuest().markers.length, false),
    status: QuestStatus.active,
    timeElapsed: 0,
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

ActivatedQuest getTestFinishedQuest() {
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
