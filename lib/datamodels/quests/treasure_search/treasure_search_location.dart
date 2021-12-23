import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'treasure_search_location.freezed.dart';
part 'treasure_search_location.g.dart';

@freezed
class TreasureSearchLocation with _$TreasureSearchLocation {
  factory TreasureSearchLocation({
    required double currentLat,
    required double currentLon,
    required double currentAccuracy,
    required double distanceToGoal,
    double? previousLat,
    double? previousLon,
    double? previousAccuracy,
    double? distanceToPreviousPosition,
  }) = _TreasureSearchLocation;

  factory TreasureSearchLocation.fromJson(Map<String, dynamic> json) =>
      _$TreasureSearchLocationFromJson(json);
}
