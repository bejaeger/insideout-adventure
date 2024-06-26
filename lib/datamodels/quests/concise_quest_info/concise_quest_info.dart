import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insideout_ui/insideout_ui.dart';

part 'concise_quest_info.freezed.dart';
part 'concise_quest_info.g.dart';

@freezed
class ConciseFinishedQuestInfo with _$ConciseFinishedQuestInfo {
  @JsonSerializable(explicitToJson: true)
  factory ConciseFinishedQuestInfo({
    required String name,
    required QuestType type,
    required num credits,
    required num creditsEarned,
  }) = _ConciseFinishedQuestInfo;

  factory ConciseFinishedQuestInfo.fromJson(Map<String, dynamic> json) =>
      _$ConciseFinishedQuestInfoFromJson(json);
}
