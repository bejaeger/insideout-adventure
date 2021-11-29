// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Quest _$$_QuestFromJson(Map<String, dynamic> json) => _$_Quest(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$QuestTypeEnumMap, json['type']),
      startMarker:
          AFKMarker.fromJson(json['startMarker'] as Map<String, dynamic>),
      finishMarker:
          AFKMarker.fromJson(json['finishMarker'] as Map<String, dynamic>),
      markers: (json['markers'] as List<dynamic>)
          .map((e) => AFKMarker.fromJson(e as Map<String, dynamic>))
          .toList(),
      afkCredits: json['afkCredits'] as num,
      networkImagePath: json['networkImagePath'] as String?,
      afkCreditsPerMarker: (json['afkCreditsPerMarker'] as List<dynamic>?)
          ?.map((e) => e as num)
          .toList(),
      bonusAfkCreditsOnSuccess: json['bonusAfkCreditsOnSuccess'] as num?,
    );

Map<String, dynamic> _$$_QuestToJson(_$_Quest instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$QuestTypeEnumMap[instance.type],
      'startMarker': instance.startMarker.toJson(),
      'finishMarker': instance.finishMarker.toJson(),
      'markers': instance.markers.map((e) => e.toJson()).toList(),
      'afkCredits': instance.afkCredits,
      'networkImagePath': instance.networkImagePath,
      'afkCreditsPerMarker': instance.afkCreditsPerMarker,
      'bonusAfkCreditsOnSuccess': instance.bonusAfkCreditsOnSuccess,
    };

const _$QuestTypeEnumMap = {
  QuestType.Hike: 'Hike',
  QuestType.Hunt: 'Hunt',
  QuestType.Search: 'Search',
};
