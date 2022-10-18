// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserSettings _$$_UserSettingsFromJson(Map<String, dynamic> json) =>
    _$_UserSettings(
      isUsingAR: json['isUsingAR'] ?? true,
      isShowingCompletedQuests:
          json['isShowingCompletedQuests'] as bool? ?? true,
      isShowAvatarAndMapEffects:
          json['isShowAvatarAndMapEffects'] as bool? ?? true,
    );

Map<String, dynamic> _$$_UserSettingsToJson(_$_UserSettings instance) =>
    <String, dynamic>{
      'isUsingAR': instance.isUsingAR,
      'isShowingCompletedQuests': instance.isShowingCompletedQuests,
      'isShowAvatarAndMapEffects': instance.isShowAvatarAndMapEffects,
    };
