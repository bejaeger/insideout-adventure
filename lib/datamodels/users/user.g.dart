// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    uid: json['uid'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String?,
    sponsorIds:
        (json['sponsorIds'] as List<dynamic>).map((e) => e as String).toList(),
    explorerIds:
        (json['explorerIds'] as List<dynamic>).map((e) => e as String).toList(),
    role: _$enumDecode(_$UserRoleEnumMap, json['role']),
    newUser: json['newUser'] as bool? ?? false,
    fullNameSearch: (json['fullNameSearch'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    createdByUserWithId: json['createdByUserWithId'] as String?,
    password: json['password'] as String?,
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'email': instance.email,
      'sponsorIds': instance.sponsorIds,
      'explorerIds': instance.explorerIds,
      'role': _$UserRoleEnumMap[instance.role],
      'newUser': instance.newUser,
      'fullNameSearch': User._checkIfKeywordsAreSet(instance.fullNameSearch),
      'createdByUserWithId': instance.createdByUserWithId,
      'password': instance.password,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$UserRoleEnumMap = {
  UserRole.sponsor: 'sponsor',
  UserRole.explorer: 'explorer',
  UserRole.admin: 'admin',
  UserRole.unassigned: 'unassigned',
};
