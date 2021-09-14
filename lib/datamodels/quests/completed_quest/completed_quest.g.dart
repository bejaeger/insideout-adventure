// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CompletedQuest _$_$_CompletedQuestFromJson(Map<String, dynamic> json) {
  return _$_CompletedQuest(
    id: json['id'] as String?,
    questId: json['questId'] as String?,
    numberMarkersCollected: json['numberMarkersCollected'] as int?,
    status: _$enumDecode(_$QuestStatusEnumMap, json['status']),
    afkCreditsEarned: json['afkCreditsEarned'] as num?,
    timeElapsed: json['timeElapsed'] as String?,
  );
}

Map<String, dynamic> _$_$_CompletedQuestToJson(_$_CompletedQuest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questId': instance.questId,
      'numberMarkersCollected': instance.numberMarkersCollected,
      'status': _$QuestStatusEnumMap[instance.status],
      'afkCreditsEarned': instance.afkCreditsEarned,
      'timeElapsed': instance.timeElapsed,
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

const _$QuestStatusEnumMap = {
  QuestStatus.active: 'active',
  QuestStatus.cancelled: 'cancelled',
  QuestStatus.success: 'success',
  QuestStatus.incomplete: 'incomplete',
};
