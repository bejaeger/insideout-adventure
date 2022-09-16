// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_time_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ScreenTimeSession _$$_ScreenTimeSessionFromJson(Map<String, dynamic> json) =>
    _$_ScreenTimeSession(
      sessionId: json['sessionId'] as String,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      startedAt: json['startedAt'] ?? "",
      endedAt: json['endedAt'] ?? "",
      minutes: json['minutes'] as int,
      minutesUsed: json['minutesUsed'] as int?,
      afkCreditsUsed: json['afkCreditsUsed'] as num?,
      status: $enumDecode(_$ScreenTimeSessionStatusEnumMap, json['status']),
      afkCredits: (json['afkCredits'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ScreenTimeSessionToJson(
        _$_ScreenTimeSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'uid': instance.uid,
      'userName': instance.userName,
      'startedAt': instance.startedAt,
      'endedAt': instance.endedAt,
      'minutes': instance.minutes,
      'minutesUsed': instance.minutesUsed,
      'afkCreditsUsed': instance.afkCreditsUsed,
      'status': _$ScreenTimeSessionStatusEnumMap[instance.status]!,
      'afkCredits': instance.afkCredits,
    };

const _$ScreenTimeSessionStatusEnumMap = {
  ScreenTimeSessionStatus.notStarted: 'notStarted',
  ScreenTimeSessionStatus.active: 'active',
  ScreenTimeSessionStatus.cancelled: 'cancelled',
  ScreenTimeSessionStatus.completed: 'completed',
};
