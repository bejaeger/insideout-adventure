import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/last_direction_check.dart';
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
    num? afkCreditsEarned,
    required int timeElapsed, // in seconds!
    @Default("") dynamic createdAt,
    double? lastCheckLat, // For VibrationSearch quest
    double? lastCheckLon, // For VibrationSearch quest
    double? currentDistanceInMeters, // For VibrationSearch quest
    double? lastDistanceInMeters, // For VibrationSearch quest
  }) = _ActivatedQuest;

  factory ActivatedQuest.fromJson(Map<String, dynamic> json) =>
      _$ActivatedQuestFromJson(json);
}
