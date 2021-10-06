// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserStatistics _$_$_UserStatisticsFromJson(Map<String, dynamic> json) {
  return _$_UserStatistics(
    afkCredits: json['afkCredits'] as num,
    availableSponsoring: json['availableSponsoring'] as num,
    lifetimeEarnings: json['lifetimeEarnings'] as num,
    completedQuests: (json['completedQuests'] as List<dynamic>)
        .map((e) => ConciseQuestInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    uid: json['uid'] as String,
  );
}

Map<String, dynamic> _$_$_UserStatisticsToJson(_$_UserStatistics instance) =>
    <String, dynamic>{
      'afkCredits': instance.afkCredits,
      'availableSponsoring': instance.availableSponsoring,
      'lifetimeEarnings': instance.lifetimeEarnings,
      'completedQuests':
          instance.completedQuests.map((e) => e.toJson()).toList(),
      'uid': instance.uid,
    };
