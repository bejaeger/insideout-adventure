enum QuestType {
  QRCodeHike, // not implemented
  GPSAreaHike, 
  QRCodeHunt, // (not implemented) changes to UI w.r.t. outdoor hunt
  GPSAreaHunt, // (not implemented) changes to UI w.r.t. outdoor hunt
  DistanceEstimate, // not implemented anymore
  TreasureLocationSearch, // (legacy name) called SearchQuest now
}

enum CreateQuestType {
  GPSAreaHike,  
  TreasureLocationSearch,
}

extension SerializableEnum on Enum {
  String toSimpleString() {
    return toString().split('.').last;
  }
}
