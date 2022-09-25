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
    num? afkCreditsUsed,
    required ScreenTimeSessionStatus status,
    required double afkCredits,
  }) = _ScreenTimeSession;

  factory ScreenTimeSession.fromJson(Map<String, dynamic> json) =>
      _$ScreenTimeSessionFromJson(json);
}

Map<String, String?> getStringMapFromSession(
    {required ScreenTimeSession session}) {
  return {
    "sessionId": session.sessionId,
    "uid": session.uid,
    "userName": session.userName,
    "createdByUid": session.createdByUid,
    "startedAt": "",
    "endedAt": "",
    "minutes": session.minutes.toStringAsFixed(0),
    "status": session.status.toString().split('.').last,
    "afkCredits": session.afkCredits.toStringAsFixed(0),
  };
}

ScreenTimeSession getSessionFromStringMap(
    {required Map<String, String?> payload}) {
  return ScreenTimeSession.fromJson(
    {
      "sessionId": payload["sessionId"],
      "uid": payload["uid"],
      "userName": payload["userName"],
      "createdByUid": payload["createdByUid"],
      "startedAt": "",
      "endedAt": "",
      "minutes": int.parse(payload["minutes"]!),
      "afkCredits": int.parse(payload["afkCredits"]!),
      "status": payload["status"], // ! change that manually here
    },
  );
}
