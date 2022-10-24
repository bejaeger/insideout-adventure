import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'search_quest_location.freezed.dart';
part 'search_quest_location.g.dart';

@freezed
class SearchQuestLocation with _$SearchQuestLocation {
  factory SearchQuestLocation({
    required double currentLat,
    required double currentLon,
    required double currentAccuracy,
    required double distanceToGoal,
    double? previousLat,
    double? previousLon,
    double? previousAccuracy,
    double? distanceToPreviousPosition,
  }) = _SearchQuestLocation;

  factory SearchQuestLocation.fromJson(Map<String, dynamic> json) =>
      _$SearchQuestLocationFromJson(json);
}
