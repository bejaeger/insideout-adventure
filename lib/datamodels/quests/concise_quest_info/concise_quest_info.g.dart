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
      credits: json['credits'] as num,
      creditsEarned: json['creditsEarned'] as num,
    );

Map<String, dynamic> _$$_ConciseFinishedQuestInfoToJson(
        _$_ConciseFinishedQuestInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$QuestTypeEnumMap[instance.type]!,
      'credits': instance.credits,
      'creditsEarned': instance.creditsEarned,
    };

const _$QuestTypeEnumMap = {
  QuestType.QRCodeHike: 'QRCodeHike',
  QuestType.GPSAreaHike: 'GPSAreaHike',
  QuestType.QRCodeHunt: 'QRCodeHunt',
  QuestType.GPSAreaHunt: 'GPSAreaHunt',
  QuestType.DistanceEstimate: 'DistanceEstimate',
  QuestType.TreasureLocationSearch: 'TreasureLocationSearch',
};
