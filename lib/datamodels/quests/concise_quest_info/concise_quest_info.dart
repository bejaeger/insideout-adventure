import 'package:afkcredits/enums/quest_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'concise_quest_info.freezed.dart';
part 'concise_quest_info.g.dart';

@freezed
class ConciseQuestInfo with _$ConciseQuestInfo {
  @JsonSerializable(explicitToJson: true)
  factory ConciseQuestInfo({
    required String name,
    required QuestType type,
    required num afkCredits,
    required num afkCreditsEarned,
  }) = _ConciseQuestInfo;

  factory ConciseQuestInfo.fromJson(Map<String, dynamic> json) =>
      _$ConciseQuestInfoFromJson(json);
}
