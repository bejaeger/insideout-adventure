// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserAdmin _$$_UserAdminFromJson(Map<String, dynamic> json) => _$_UserAdmin(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$$_UserAdminToJson(_$_UserAdmin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'role': _$UserRoleEnumMap[instance.role],
    };

const _$UserRoleEnumMap = {
  UserRole.sponsor: 'sponsor',
  UserRole.explorer: 'explorer',
  UserRole.admin: 'admin',
  UserRole.unassigned: 'unassigned',
  UserRole.adminMaster: 'adminMaster',
};
