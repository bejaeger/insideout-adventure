// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsor_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SponsorReference _$$_SponsorReferenceFromJson(Map<String, dynamic> json) =>
    _$_SponsorReference(
      uid: json['uid'] as String,
      authMethod: $enumDecodeNullable(
          _$AuthenticationMethodEnumMap, json['authMethod']),
      deviceId: json['deviceId'] as String?,
      withPasscode: json['withPasscode'] as bool,
    );

Map<String, dynamic> _$$_SponsorReferenceToJson(_$_SponsorReference instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'authMethod': _$AuthenticationMethodEnumMap[instance.authMethod],
      'deviceId': instance.deviceId,
      'withPasscode': instance.withPasscode,
    };

const _$AuthenticationMethodEnumMap = {
  AuthenticationMethod.email: 'email',
  AuthenticationMethod.google: 'google',
  AuthenticationMethod.facebook: 'facebook',
  AuthenticationMethod.apple: 'apple',
  AuthenticationMethod.dummy: 'dummy',
  AuthenticationMethod.EmailOrSponsorCreatedExplorer:
      'EmailOrSponsorCreatedExplorer',
};
