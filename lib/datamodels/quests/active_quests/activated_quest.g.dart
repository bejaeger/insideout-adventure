// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activated_quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActivatedQuest _$$_ActivatedQuestFromJson(Map<String, dynamic> json) =>
    _$_ActivatedQuest(
      id: json['id'] as String?,
      quest: Quest.fromJson(json['quest'] as Map<String, dynamic>),
      markersCollected: (json['markersCollected'] as List<dynamic>)
          .map((e) => e as bool)
          .toList(),
      status: $enumDecode(_$QuestStatusEnumMap, json['status']),
      uids: (json['uids'] as List<dynamic>?)?.map((e) => e as String).toList(),
      afkCreditsEarned: json['afkCreditsEarned'] as num?,
      timeElapsed: json['timeElapsed'] as int,
      createdAt: json['createdAt'] ?? "",
      lastCheckLat: (json['lastCheckLat'] as num?)?.toDouble(),
      lastCheckLon: (json['lastCheckLon'] as num?)?.toDouble(),
      currentDistanceInMeters:
          (json['currentDistanceInMeters'] as num?)?.toDouble(),
      lastDistanceInMeters: (json['lastDistanceInMeters'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$_ActivatedQuestToJson(_$_ActivatedQuest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quest': instance.quest.toJson(),
      'markersCollected': instance.markersCollected,
      'status': _$QuestStatusEnumMap[instance.status],
      'uids': instance.uids,
      'afkCreditsEarned': instance.afkCreditsEarned,
      'timeElapsed': instance.timeElapsed,
      'createdAt': instance.createdAt,
      'lastCheckLat': instance.lastCheckLat,
      'lastCheckLon': instance.lastCheckLon,
      'currentDistanceInMeters': instance.currentDistanceInMeters,
      'lastDistanceInMeters': instance.lastDistanceInMeters,
    };

const _$QuestStatusEnumMap = {
  QuestStatus.active: 'active',
  QuestStatus.cancelled: 'cancelled',
  QuestStatus.success: 'success',
  QuestStatus.incomplete: 'incomplete',
  QuestStatus.internalFailure: 'internalFailure',
  QuestStatus.failed: 'failed',
};
