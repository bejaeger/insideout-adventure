import 'package:afkcredits/enums/quest_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'completed_quest.freezed.dart';
part 'completed_quest.g.dart';

@freezed
class CompletedQuest with _$CompletedQuest {
  @JsonSerializable(explicitToJson: true)
  factory CompletedQuest({
    String? id,
    String? questId,
    //required Quest quest,
    required int? numberMarkersCollected,
    required QuestStatus status,
    num? afkCreditsEarned,
    String? timeElapsed, // in seconds!
    // @Default("") dynamic createdAt,
  }) = _CompletedQuest;

  factory CompletedQuest.fromJson(Map<String, dynamic> json) =>
      _$CompletedQuestFromJson(json);
}
