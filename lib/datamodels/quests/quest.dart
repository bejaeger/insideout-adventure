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
    required AFKMarker startMarker,
    required AFKMarker finishMarker,
    required List<AFKMarker> markers,
    required num afkCredits,
    String? networkImagePath,
    List<num>? afkCreditsPerMarker,
    num? bonusAfkCreditsOnSuccess,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
