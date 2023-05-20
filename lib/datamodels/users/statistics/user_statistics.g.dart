// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserStatistics _$$_UserStatisticsFromJson(Map<String, dynamic> json) =>
    _$_UserStatistics(
      creditsBalance: json['creditsBalance'] as num,
      creditsSpent: json['creditsSpent'] as num,
      totalScreenTime: json['totalScreenTime'] as num,
      availableGuardianship: json['availableGuardianship'] as num,
      lifetimeEarnings: json['lifetimeEarnings'] as num,
      numberQuestsCompleted: json['numberQuestsCompleted'] as int,
      numberGiftCardsPurchased: json['numberGiftCardsPurchased'] as int,
      numberScreenTimeHoursPurchased:
          json['numberScreenTimeHoursPurchased'] as num,
      completedQuests: (json['completedQuests'] as List<dynamic>)
          .map((e) =>
              ConciseFinishedQuestInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      completedQuestIds: (json['completedQuestIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$_UserStatisticsToJson(_$_UserStatistics instance) =>
    <String, dynamic>{
      'creditsBalance': instance.creditsBalance,
      'creditsSpent': instance.creditsSpent,
      'totalScreenTime': instance.totalScreenTime,
      'availableGuardianship': instance.availableGuardianship,
      'lifetimeEarnings': instance.lifetimeEarnings,
      'numberQuestsCompleted': instance.numberQuestsCompleted,
      'numberGiftCardsPurchased': instance.numberGiftCardsPurchased,
      'numberScreenTimeHoursPurchased': instance.numberScreenTimeHoursPurchased,
      'completedQuests':
          instance.completedQuests.map((e) => e.toJson()).toList(),
      'completedQuestIds': instance.completedQuestIds,
      'uid': instance.uid,
    };
