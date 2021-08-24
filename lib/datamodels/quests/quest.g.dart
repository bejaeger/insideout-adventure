// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Quest _$_$_QuestFromJson(Map<String, dynamic> json) {
  return _$_Quest(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    type: _$enumDecode(_$QuestTypeEnumMap, json['type']),
    startMarker: Marker.fromJson(json['startMarker'] as Map<String, dynamic>),
    finishMarker: Marker.fromJson(json['finishMarker'] as Map<String, dynamic>),
    markers: (json['markers'] as List<dynamic>)
        .map((e) => Marker.fromJson(e as Map<String, dynamic>))
        .toList(),
    afkCredits: json['afkCredits'] as num,
    afkCreditsPerMarker: (json['afkCreditsPerMarker'] as List<dynamic>?)
        ?.map((e) => e as num)
        .toList(),
    bonusAfkCreditsOnSuccess: json['bonusAfkCreditsOnSuccess'] as num?,
  );
}

Map<String, dynamic> _$_$_QuestToJson(_$_Quest instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$QuestTypeEnumMap[instance.type],
      'startMarker': instance.startMarker.toJson(),
      'finishMarker': instance.finishMarker.toJson(),
      'markers': instance.markers.map((e) => e.toJson()).toList(),
      'afkCredits': instance.afkCredits,
      'afkCreditsPerMarker': instance.afkCreditsPerMarker,
      'bonusAfkCreditsOnSuccess': instance.bonusAfkCreditsOnSuccess,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$QuestTypeEnumMap = {
  QuestType.Hike: 'Hike',
  QuestType.Hunt: 'Hunt',
  QuestType.Search: 'Search',
};
