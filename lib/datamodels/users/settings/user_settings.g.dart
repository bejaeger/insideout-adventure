// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserSettings _$$_UserSettingsFromJson(Map<String, dynamic> json) =>
    _$_UserSettings(
      isUsingAR: json['isUsingAR'] as bool? ?? true,
      isShowingCompletedQuests:
          json['isShowingCompletedQuests'] as bool? ?? false,
      isShowAvatarAndMapEffects:
          json['isShowAvatarAndMapEffects'] as bool? ?? true,
      ownPhone: json['ownPhone'] as bool? ?? false,
      isAcceptScreenTimeFirst:
          json['isAcceptScreenTimeFirst'] as bool? ?? false,
    );

Map<String, dynamic> _$$_UserSettingsToJson(_$_UserSettings instance) =>
    <String, dynamic>{
      'isUsingAR': instance.isUsingAR,
      'isShowingCompletedQuests': instance.isShowingCompletedQuests,
      'isShowAvatarAndMapEffects': instance.isShowAvatarAndMapEffects,
      'ownPhone': instance.ownPhone,
      'isAcceptScreenTimeFirst': instance.isAcceptScreenTimeFirst,
    };
