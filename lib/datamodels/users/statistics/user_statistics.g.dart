// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserStatistics _$$_UserStatisticsFromJson(Map<String, dynamic> json) =>
    _$_UserStatistics(
      afkCreditsBalance: json['afkCreditsBalance'] as num,
      afkCreditsSpent: json['afkCreditsSpent'] as num,
      totalScreenTime: json['totalScreenTime'] as num,
      availableSponsoring: json['availableSponsoring'] as num,
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
      'afkCreditsBalance': instance.afkCreditsBalance,
      'afkCreditsSpent': instance.afkCreditsSpent,
      'totalScreenTime': instance.totalScreenTime,
      'availableSponsoring': instance.availableSponsoring,
      'lifetimeEarnings': instance.lifetimeEarnings,
      'numberQuestsCompleted': instance.numberQuestsCompleted,
      'numberGiftCardsPurchased': instance.numberGiftCardsPurchased,
      'numberScreenTimeHoursPurchased': instance.numberScreenTimeHoursPurchased,
      'completedQuests':
          instance.completedQuests.map((e) => e.toJson()).toList(),
      'completedQuestIds': instance.completedQuestIds,
      'uid': instance.uid,
    };
