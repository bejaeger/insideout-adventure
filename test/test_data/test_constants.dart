/////////////////////////////////////////////////////////
/// For testing
const String kTestUid = "TestId";
const String kTestQuestId = "QuestId";
const String kTestQrCodeId = "QrCodeId";

const String kTestMarker1Id = "Marker1Id";
const String kTestMarker1QrCodeId = "QRCode1Id";
const double kTestMarker1Lat = 49.0;
const double kTestMarker1Lon = -122.0;

const String kTestMarker2Id = "Marker2Id";
const String kTestMarker2QrCodeId = "QRCode2Id";
const double kTestMarker2Lat = 49.1;
const double kTestMarker2Lon = -122.0;

const String kTestMarker1QrCodeString =
    "{\"id\":\"$kTestMarker1Id\",\"qrCodeId\":\"$kTestMarker1QrCodeId\",\"lat\":$kTestMarker1Lat,\"lon\":$kTestMarker1Lon,\"markerStatus\":\"testing\"}";
const String kTestMarker2QrCodeString =
    "{\"id\":\"$kTestMarker2Id\",\"qrCodeId\":\"$kTestMarker2QrCodeId\",\"questId\":null,\"lat\":$kTestMarker2Lat,\"lon\":$kTestMarker2Lon,\"markerStatus\":\"testing\"}";

const String kTestMarkerFarAwayQrCodeString =
    "{\"id\":\"FarAwayId\",\"qrCodeId\":\"FarAwayId\",\"questId\":null,\"lat\":999,\"lon\":999,\"markerStatus\":\"testing\"}";
