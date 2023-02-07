import 'package:insideout_ui/insideout_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'concise_quest_info.freezed.dart';
part 'concise_quest_info.g.dart';

@freezed
class ConciseFinishedQuestInfo with _$ConciseFinishedQuestInfo {
  @JsonSerializable(explicitToJson: true)
  factory ConciseFinishedQuestInfo({
    required String name,
    required QuestType type,
    required num afkCredits,
    required num afkCreditsEarned,
  }) = _ConciseFinishedQuestInfo;

  factory ConciseFinishedQuestInfo.fromJson(Map<String, dynamic> json) =>
      _$ConciseFinishedQuestInfoFromJson(json);
}
