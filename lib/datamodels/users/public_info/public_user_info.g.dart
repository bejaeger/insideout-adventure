// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PublicUserInfo _$$_PublicUserInfoFromJson(Map<String, dynamic> json) =>
    _$_PublicUserInfo(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      errorMessage: json['errorMessage'] as String?,
      hasGuardian: json['hasGuardian'] as bool?,
    );

Map<String, dynamic> _$$_PublicUserInfoToJson(_$_PublicUserInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'errorMessage': instance.errorMessage,
      'hasGuardian': instance.hasGuardian,
    };
