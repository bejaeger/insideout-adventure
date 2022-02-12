// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Achievement _$$_AchievementFromJson(Map<String, dynamic> json) =>
    _$_Achievement(
      id: json['id'] as String,
      credits: json['credits'] as int,
      name: json['name'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$$_AchievementToJson(_$_Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'credits': instance.credits,
      'name': instance.name,
      'completed': instance.completed,
    };
