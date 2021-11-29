// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      sponsorIds: (json['sponsorIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      explorerIds: (json['explorerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      authMethod:
          $enumDecode(_$AuthenticationMethodEnumMap, json['authMethod']),
      newUser: json['newUser'] as bool? ?? false,
      fullNameSearch: (json['fullNameSearch'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdByUserWithId: json['createdByUserWithId'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'email': instance.email,
      'sponsorIds': instance.sponsorIds,
      'explorerIds': instance.explorerIds,
      'role': _$UserRoleEnumMap[instance.role],
      'authMethod': _$AuthenticationMethodEnumMap[instance.authMethod],
      'newUser': instance.newUser,
      'fullNameSearch': User._checkIfKeywordsAreSet(instance.fullNameSearch),
      'createdByUserWithId': instance.createdByUserWithId,
      'password': instance.password,
    };

const _$UserRoleEnumMap = {
  UserRole.sponsor: 'sponsor',
  UserRole.explorer: 'explorer',
  UserRole.admin: 'admin',
  UserRole.unassigned: 'unassigned',
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
