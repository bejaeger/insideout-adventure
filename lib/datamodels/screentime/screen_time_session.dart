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
