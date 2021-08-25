import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activated_quest.freezed.dart';
part 'activated_quest.g.dart';

@freezed
class ActivatedQuest with _$ActivatedQuest {
  @JsonSerializable(explicitToJson: true)
  factory ActivatedQuest({
    String? id,
    required Quest quest,
    required List<bool> markersCollected,
    required QuestStatus status,
    List<String>? uids,
    String? afkCreditsEarned,
    required int timeElapsed, // in seconds!
    @Default("") dynamic createdAt,
  }) = _ActivatedQuest;

  factory ActivatedQuest.fromJson(Map<String, dynamic> json) =>
      _$ActivatedQuestFromJson(json);
}
