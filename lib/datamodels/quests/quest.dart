import 'package:afkcredits/datamodels/quests/markers/marker.dart';
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
    required Markers startMarker,
    required Markers finishMarker,
    required List<Markers> markers,
    required num afkCredits,
    List<num>? afkCreditsPerMarker,
    num? bonusAfkCreditsOnSuccess,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
