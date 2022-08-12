enum QuestType {
  QRCodeHike,
  GPSAreaHike,
  // Hunt,
  QRCodeHunt, // changes to UI w.r.t. outdoor hunt
  GPSAreaHunt, // changes to UI w.r.t. outdoor hunt
  // QRCodeSearch,
  // QRCodeSearchIndoor, // changes in UI!
  DistanceEstimate,
  TreasureLocationSearch,
}

extension SerializableEnum on Enum {
  String toSimpleString() {
    return toString().split('.').last;
  }
}
