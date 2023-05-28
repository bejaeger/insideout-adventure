import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_time_session.freezed.dart';
part 'screen_time_session.g.dart';

@freezed
class ScreenTimeSession with _$ScreenTimeSession {
  factory ScreenTimeSession({
    required String sessionId,
    required String uid,
    required String userName,
    required String createdByUid,
    @Default("") dynamic startedAt,
    @Default("") dynamic endedAt,
    required int minutes,
    int? minutesUsed,
    num? creditsUsed,
    required ScreenTimeSessionStatus status,
    required double credits,
  }) = _ScreenTimeSession;

  factory ScreenTimeSession.fromJson(Map<String, dynamic> json) =>
      _$ScreenTimeSessionFromJson(json);
}

Map<String, String?> getStringMapFromSession(
    {required ScreenTimeSession session}) {
  late String startedAt;
  try {
    startedAt = session.startedAt is DateTime
        ? session.startedAt.toIso8601String()
        : "";
  } catch (e) {
    print(
        "==>> ERROR in getStringMapFromSession(): Could not convert startedAt object, error: $e");
    startedAt = "";
  }
  return {
    "sessionId": session.sessionId,
    "uid": session.uid,
    "userName": session.userName,
    "createdByUid": session.createdByUid,
    "startedAt": startedAt,
    "endedAt": "",
    "minutes": session.minutes.toStringAsFixed(0),
    "status": session.status.toString().split('.').last,
    "credits": session.credits.toStringAsFixed(0),
  };
}

ScreenTimeSession getSessionFromStringMap(
    {required Map<String, String?> payload}) {
  dynamic startedAt;
  try {
    startedAt = DateTime.parse(payload["startedAt"]!);
  } catch (e) {
    print(
        "==>> ERROR in getSessionFromStringMap(): Could not convert startedAt object, error: $e");
    startedAt = "";
  }
  return ScreenTimeSession.fromJson(
    {
      "sessionId": payload["sessionId"],
      "uid": payload["uid"],
      "userName": payload["userName"],
      "createdByUid": payload["createdByUid"],
      "startedAt": startedAt,
      "endedAt": "",
      "minutes": int.parse(payload["minutes"]!),
      "credits": int.parse(payload["credits"]!),
      "status": payload["status"], // ! change that manually here
    },
  );
}
