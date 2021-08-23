import 'package:afkcredits/datamodels/quests/concise_quest_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_statistics.freezed.dart';
part 'user_statistics.g.dart';

@freezed
class UserStatistics with _$UserStatistics {
  @JsonSerializable(explicitToJson: true)
  factory UserStatistics({
    required num afkCredits,
    required num availableSponsoring,
    required List<ConciseQuestInfo> completedQuests,
    required String uid,
  }) = _UserStatistics;

  factory UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticsFromJson(json);
}

// Unfortunately json serializable only supports literals as default
// We simply create a top-level function to get an empty a user statistics
// model that is empty. This is used for creating the initial documents in firestore
UserStatistics getEmptyUserStatistics({required String uid}) {
  return UserStatistics(
    afkCredits: 0,
    availableSponsoring: 0,
    uid: uid,
    completedQuests: [],
  );
}
