// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      guardianIds: (json['guardianIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      wardIds:
          (json['wardIds'] as List<dynamic>).map((e) => e as String).toList(),
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      userSettings: json['userSettings'] == null
          ? null
          : UserSettings.fromJson(json['userSettings'] as Map<String, dynamic>),
      authMethod: $enumDecodeNullable(
          _$AuthenticationMethodEnumMap, json['authMethod']),
      newUser: json['newUser'] as bool? ?? true,
      fullNameSearch: (json['fullNameSearch'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdByUserWithId: json['createdByUserWithId'] as String?,
      password: json['password'] as String?,
      tokens:
          (json['tokens'] as List<dynamic>?)?.map((e) => e as String).toList(),
      deviceId: json['deviceId'] as String?,
      avatarIdx: json['avatarIdx'] as int? ?? 1,
      guardianVerificationStatus: $enumDecodeNullable(
          _$GuardianVerificationStatusEnumMap,
          json['guardianVerificationStatus']),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'email': instance.email,
      'guardianIds': instance.guardianIds,
      'wardIds': instance.wardIds,
      'role': _$UserRoleEnumMap[instance.role]!,
      'userSettings': instance.userSettings?.toJson(),
      'authMethod': _$AuthenticationMethodEnumMap[instance.authMethod],
      'newUser': instance.newUser,
      'fullNameSearch': User._checkIfKeywordsAreSet(instance.fullNameSearch),
      'createdByUserWithId': instance.createdByUserWithId,
      'password': instance.password,
      'tokens': instance.tokens,
      'deviceId': instance.deviceId,
      'avatarIdx': instance.avatarIdx,
      'guardianVerificationStatus': _$GuardianVerificationStatusEnumMap[
          instance.guardianVerificationStatus],
    };

const _$UserRoleEnumMap = {
  UserRole.guardian: 'guardian',
  UserRole.ward: 'ward',
  UserRole.admin: 'admin',
  UserRole.unassigned: 'unassigned',
  UserRole.adminMaster: 'adminMaster',
  UserRole.superUser: 'superUser',
};

const _$AuthenticationMethodEnumMap = {
  AuthenticationMethod.email: 'email',
  AuthenticationMethod.google: 'google',
  AuthenticationMethod.facebook: 'facebook',
  AuthenticationMethod.apple: 'apple',
  AuthenticationMethod.dummy: 'dummy',
  AuthenticationMethod.EmailOrGuardianCreatedWard: 'EmailOrGuardianCreatedWard',
};

const _$GuardianVerificationStatusEnumMap = {
  GuardianVerificationStatus.notInitiated: 'notInitiated',
  GuardianVerificationStatus.pending: 'pending',
  GuardianVerificationStatus.verified: 'verified',
};
