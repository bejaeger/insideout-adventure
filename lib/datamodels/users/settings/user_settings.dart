import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
class UserSettings with _$UserSettings {
  factory UserSettings({

    // this is mostly used together with a check of appConfigProvide.isARAvailable!
    @Default(true) bool isUsingAR,

    // Switch to make completed quests visible/invisible
    // (only done for search quests at the moment
    // as hike quests can ALWAYS be redone))
    @Default(true) bool isShowingCompletedQuests,
    @Default(true) bool isShowAvatarAndMapEffects,
    @Default(false) bool ownPhone, // child using his/her own phone
    @Default(false) bool isAcceptScreenTimeFirst,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
