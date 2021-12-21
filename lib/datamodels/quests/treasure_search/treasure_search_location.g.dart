// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treasure_search_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TreasureSearchLocation _$$_TreasureSearchLocationFromJson(
        Map<String, dynamic> json) =>
    _$_TreasureSearchLocation(
      currentLat: (json['currentLat'] as num).toDouble(),
      currentLon: (json['currentLon'] as num).toDouble(),
      currentAccuracy: (json['currentAccuracy'] as num).toDouble(),
      distanceToGoal: (json['distanceToGoal'] as num).toDouble(),
      previousLat: (json['previousLat'] as num?)?.toDouble(),
      previousLon: (json['previousLon'] as num?)?.toDouble(),
      previousAccuracy: (json['previousAccuracy'] as num?)?.toDouble(),
      distanceToPreviousPosition:
          (json['distanceToPreviousPosition'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$_TreasureSearchLocationToJson(
        _$_TreasureSearchLocation instance) =>
    <String, dynamic>{
      'currentLat': instance.currentLat,
      'currentLon': instance.currentLon,
      'currentAccuracy': instance.currentAccuracy,
      'distanceToGoal': instance.distanceToGoal,
      'previousLat': instance.previousLat,
      'previousLon': instance.previousLon,
      'previousAccuracy': instance.previousAccuracy,
      'distanceToPreviousPosition': instance.distanceToPreviousPosition,
    };
