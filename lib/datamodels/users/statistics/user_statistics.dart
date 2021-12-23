import 'package:afkcredits/datamodels/quests/concise_quest_info/concise_quest_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_statistics.freezed.dart';
part 'user_statistics.g.dart';

@freezed
class UserStatistics with _$UserStatistics {
  @JsonSerializable(explicitToJson: true)
  factory UserStatistics({
    required num afkCreditsBalance, // in credits
    required num afkCreditsSpent, // in credits
    required num availableSponsoring, // in cents!
    required num lifetimeEarnings, // in credits
    required int numberQuestsCompleted,
    required int numberGiftCardsPurchased,
    required List<ConciseFinishedQuestInfo> completedQuests,
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
    afkCreditsBalance: 0,
    availableSponsoring: 0,
    numberQuestsCompleted: 0,
    numberGiftCardsPurchased: 0,
    afkCreditsSpent: 0,
    lifetimeEarnings: 0,
    uid: uid,
    completedQuests: [],
  );
}
