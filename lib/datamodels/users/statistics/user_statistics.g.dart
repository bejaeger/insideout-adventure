// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserStatistics _$$_UserStatisticsFromJson(Map<String, dynamic> json) =>
    _$_UserStatistics(
      afkCreditsBalance: json['afkCreditsBalance'] as num,
      afkCreditsSpent: json['afkCreditsSpent'] as num,
      availableSponsoring: json['availableSponsoring'] as num,
      lifetimeEarnings: json['lifetimeEarnings'] as num,
      numberQuestsCompleted: json['numberQuestsCompleted'] as int,
      numberGiftCardsPurchased: json['numberGiftCardsPurchased'] as int,
      completedQuests: (json['completedQuests'] as List<dynamic>)
          .map((e) =>
              ConciseFinishedQuestInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$_UserStatisticsToJson(_$_UserStatistics instance) =>
    <String, dynamic>{
      'afkCreditsBalance': instance.afkCreditsBalance,
      'afkCreditsSpent': instance.afkCreditsSpent,
      'availableSponsoring': instance.availableSponsoring,
      'lifetimeEarnings': instance.lifetimeEarnings,
      'numberQuestsCompleted': instance.numberQuestsCompleted,
      'numberGiftCardsPurchased': instance.numberGiftCardsPurchased,
      'completedQuests':
          instance.completedQuests.map((e) => e.toJson()).toList(),
      'uid': instance.uid,
    };
