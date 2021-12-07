// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concise_quest_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConciseFinishedQuestInfo _$$_ConciseFinishedQuestInfoFromJson(
        Map<String, dynamic> json) =>
    _$_ConciseFinishedQuestInfo(
      name: json['name'] as String,
      type: $enumDecode(_$QuestTypeEnumMap, json['type']),
      afkCredits: json['afkCredits'] as num,
      afkCreditsEarned: json['afkCreditsEarned'] as num,
    );

Map<String, dynamic> _$$_ConciseFinishedQuestInfoToJson(
        _$_ConciseFinishedQuestInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$QuestTypeEnumMap[instance.type],
      'afkCredits': instance.afkCredits,
      'afkCreditsEarned': instance.afkCreditsEarned,
    };

const _$QuestTypeEnumMap = {
  QuestType.Hike: 'Hike',
  QuestType.Hunt: 'Hunt',
  QuestType.Search: 'Search',
  QuestType.DistanceEstimate: 'DistanceEstimate',
  QuestType.VibrationSearch: 'VibrationSearch',
};
