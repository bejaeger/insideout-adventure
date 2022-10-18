import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
class UserSettings with _$UserSettings {
  factory UserSettings({
    @Default(true) isUsingAR,

    // Switch to make completed quests visible/invisible
    // (only done for search quests at the moment
    // as hike quests can ALWAYS be redone))
    @Default(true) bool isShowingCompletedQuests,
    @Default(true) bool isShowAvatarAndMapEffects,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
