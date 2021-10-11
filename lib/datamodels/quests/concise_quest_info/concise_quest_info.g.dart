// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concise_quest_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConciseFinishedQuestInfo _$_$_ConciseFinishedQuestInfoFromJson(
    Map<String, dynamic> json) {
  return _$_ConciseFinishedQuestInfo(
    name: json['name'] as String,
    type: _$enumDecode(_$QuestTypeEnumMap, json['type']),
    afkCredits: json['afkCredits'] as num,
    afkCreditsEarned: json['afkCreditsEarned'] as num,
  );
}

Map<String, dynamic> _$_$_ConciseFinishedQuestInfoToJson(
        _$_ConciseFinishedQuestInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$QuestTypeEnumMap[instance.type],
      'afkCredits': instance.afkCredits,
      'afkCreditsEarned': instance.afkCreditsEarned,
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
