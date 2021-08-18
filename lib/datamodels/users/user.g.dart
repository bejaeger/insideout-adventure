// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    uid: json['uid'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    role: _$enumDecode(_$UserRoleEnumMap, json['role']),
    sponsorIds:
        (json['sponsorIds'] as List<dynamic>).map((e) => e as String).toList(),
    explorerIds:
        (json['explorerIds'] as List<dynamic>).map((e) => e as String).toList(),
    newUser: json['newUser'] as bool? ?? false,
    fullNameSearch: (json['fullNameSearch'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role],
      'sponsorIds': instance.sponsorIds,
      'explorerIds': instance.explorerIds,
      'newUser': instance.newUser,
      'fullNameSearch': User._checkIfKeywordsAreSet(instance.fullNameSearch),
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
};
