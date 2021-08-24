// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActiveQuest _$_$_ActiveQuestFromJson(Map<String, dynamic> json) {
  return _$_ActiveQuest(
    id: json['id'] as String?,
    quest: Quest.fromJson(json['quest'] as Map<String, dynamic>),
    markersCollected: (json['markersCollected'] as List<dynamic>)
        .map((e) => e as bool)
        .toList(),
    status: _$enumDecode(_$QuestStatusEnumMap, json['status']),
    uids: (json['uids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    afkCreditsEarned: json['afkCreditsEarned'] as String?,
    timeElapsed: json['timeElapsed'] as int,
    createdAt: json['createdAt'] ?? '',
  );
}

Map<String, dynamic> _$_$_ActiveQuestToJson(_$_ActiveQuest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quest': instance.quest.toJson(),
      'markersCollected': instance.markersCollected,
      'status': _$QuestStatusEnumMap[instance.status],
      'uids': instance.uids,
      'afkCreditsEarned': instance.afkCreditsEarned,
      'timeElapsed': instance.timeElapsed,
      'createdAt': instance.createdAt,
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
  QuestStatus.finished: 'finished',
};
