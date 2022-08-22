// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_admin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserAdmin _$UserAdminFromJson(Map<String, dynamic> json) {
  return _UserAdmin.fromJson(json);
}

/// @nodoc
mixin _$UserAdmin {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  UserRole? get role => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAdminCopyWith<UserAdmin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAdminCopyWith<$Res> {
  factory $UserAdminCopyWith(UserAdmin value, $Res Function(UserAdmin) then) =
      _$UserAdminCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String? name,
      String? email,
      String? password,
      UserRole? role});
}

/// @nodoc
class _$UserAdminCopyWithImpl<$Res> implements $UserAdminCopyWith<$Res> {
  _$UserAdminCopyWithImpl(this._value, this._then);

  final UserAdmin _value;
  // ignore: unused_field
  final $Res Function(UserAdmin) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? role = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole?,
    ));
  }
}

/// @nodoc
abstract class _$$_UserAdminCopyWith<$Res> implements $UserAdminCopyWith<$Res> {
  factory _$$_UserAdminCopyWith(
          _$_UserAdmin value, $Res Function(_$_UserAdmin) then) =
      __$$_UserAdminCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String? name,
      String? email,
      String? password,
      UserRole? role});
}

/// @nodoc
class __$$_UserAdminCopyWithImpl<$Res> extends _$UserAdminCopyWithImpl<$Res>
    implements _$$_UserAdminCopyWith<$Res> {
  __$$_UserAdminCopyWithImpl(
      _$_UserAdmin _value, $Res Function(_$_UserAdmin) _then)
      : super(_value, (v) => _then(v as _$_UserAdmin));

  @override
  _$_UserAdmin get _value => super._value as _$_UserAdmin;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? role = freezed,
  }) {
    return _then(_$_UserAdmin(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserAdmin implements _UserAdmin {
  _$_UserAdmin(
      {required this.id, this.name, this.email, this.password, this.role});

  factory _$_UserAdmin.fromJson(Map<String, dynamic> json) =>
      _$$_UserAdminFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? password;
  @override
  final UserRole? role;

  @override
  String toString() {
    return 'UserAdmin(id: $id, name: $name, email: $email, password: $password, role: $role)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserAdmin &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.password, password) &&
            const DeepCollectionEquality().equals(other.role, role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(password),
      const DeepCollectionEquality().hash(role));

  @JsonKey(ignore: true)
  @override
  _$$_UserAdminCopyWith<_$_UserAdmin> get copyWith =>
      __$$_UserAdminCopyWithImpl<_$_UserAdmin>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserAdminToJson(
      this,
    );
  }
}

abstract class _UserAdmin implements UserAdmin {
  factory _UserAdmin(
      {required final String id,
      final String? name,
      final String? email,
      final String? password,
      final UserRole? role}) = _$_UserAdmin;

  factory _UserAdmin.fromJson(Map<String, dynamic> json) =
      _$_UserAdmin.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get email;
  @override
  String? get password;
  @override
  UserRole? get role;
  @override
  @JsonKey(ignore: true)
  _$$_UserAdminCopyWith<_$_UserAdmin> get copyWith =>
      throw _privateConstructorUsedError;
}
