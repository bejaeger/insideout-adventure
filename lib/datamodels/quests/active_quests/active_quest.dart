import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_quest.freezed.dart';
part 'active_quest.g.dart';

@freezed
class ActiveQuest with _$ActiveQuest {
  @JsonSerializable(explicitToJson: true)
  factory ActiveQuest({
    String? id,
    required Quest quest,
    required List<bool> markersCollected,
    required QuestStatus status,
    List<String>? uids,
    String? afkCreditsEarned,
    required int timeElapsed, // in seconds!
    @Default("") dynamic createdAt,
  }) = _ActiveQuest;

  factory ActiveQuest.fromJson(Map<String, dynamic> json) =>
      _$ActiveQuestFromJson(json);
}
