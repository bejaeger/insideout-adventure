import 'package:afkcredits/datamodels/quests/marker_note/marker_note.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

@freezed
class Quest with _$Quest {
  @JsonSerializable(explicitToJson: true)
  factory Quest({
    required String id,
    required String name,
    required String description,
    required QuestType type,
    AFKMarker? startMarker,
    AFKMarker? finishMarker,
    required List<AFKMarker> markers,
    List<MarkerNote>? markerNotes, 
    required num afkCredits,
    String? networkImagePath,
    List<num>? afkCreditsPerMarker,
    num? bonusAfkCreditsOnSuccess,
    double? distanceFromUser,
    double? distanceToTravelInMeter, // for distance estimate
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
