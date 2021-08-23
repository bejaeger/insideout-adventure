// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'public_user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PublicUserInfo _$PublicUserInfoFromJson(Map<String, dynamic> json) {
  return _PublicUserInfo.fromJson(json);
}

/// @nodoc
class _$PublicUserInfoTearOff {
  const _$PublicUserInfoTearOff();

  _PublicUserInfo call(
      {required String uid,
      required String name,
      String? email,
      String? errorMessage}) {
    return _PublicUserInfo(
      uid: uid,
      name: name,
      email: email,
      errorMessage: errorMessage,
    );
  }

  PublicUserInfo fromJson(Map<String, Object> json) {
    return PublicUserInfo.fromJson(json);
  }
}

/// @nodoc
const $PublicUserInfo = _$PublicUserInfoTearOff();

/// @nodoc
mixin _$PublicUserInfo {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PublicUserInfoCopyWith<PublicUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicUserInfoCopyWith<$Res> {
  factory $PublicUserInfoCopyWith(
          PublicUserInfo value, $Res Function(PublicUserInfo) then) =
      _$PublicUserInfoCopyWithImpl<$Res>;
  $Res call({String uid, String name, String? email, String? errorMessage});
}

/// @nodoc
class _$PublicUserInfoCopyWithImpl<$Res>
    implements $PublicUserInfoCopyWith<$Res> {
  _$PublicUserInfoCopyWithImpl(this._value, this._then);

  final PublicUserInfo _value;
  // ignore: unused_field
  final $Res Function(PublicUserInfo) _then;

  @override
  $Res call({
    Object? uid = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: errorMessage == freezed
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$PublicUserInfoCopyWith<$Res>
    implements $PublicUserInfoCopyWith<$Res> {
  factory _$PublicUserInfoCopyWith(
          _PublicUserInfo value, $Res Function(_PublicUserInfo) then) =
      __$PublicUserInfoCopyWithImpl<$Res>;
  @override
  $Res call({String uid, String name, String? email, String? errorMessage});
}

/// @nodoc
class __$PublicUserInfoCopyWithImpl<$Res>
    extends _$PublicUserInfoCopyWithImpl<$Res>
    implements _$PublicUserInfoCopyWith<$Res> {
  __$PublicUserInfoCopyWithImpl(
      _PublicUserInfo _value, $Res Function(_PublicUserInfo) _then)
      : super(_value, (v) => _then(v as _PublicUserInfo));

  @override
  _PublicUserInfo get _value => super._value as _PublicUserInfo;

  @override
  $Res call({
    Object? uid = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_PublicUserInfo(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: errorMessage == freezed
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PublicUserInfo implements _PublicUserInfo {
  _$_PublicUserInfo(
      {required this.uid, required this.name, this.email, this.errorMessage});

  factory _$_PublicUserInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_PublicUserInfoFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'PublicUserInfo(uid: $uid, name: $name, email: $email, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PublicUserInfo &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.errorMessage, errorMessage) ||
                const DeepCollectionEquality()
                    .equals(other.errorMessage, errorMessage)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(errorMessage);

  @JsonKey(ignore: true)
  @override
  _$PublicUserInfoCopyWith<_PublicUserInfo> get copyWith =>
      __$PublicUserInfoCopyWithImpl<_PublicUserInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PublicUserInfoToJson(this);
  }
}

abstract class _PublicUserInfo implements PublicUserInfo {
  factory _PublicUserInfo(
      {required String uid,
      required String name,
      String? email,
      String? errorMessage}) = _$_PublicUserInfo;

  factory _PublicUserInfo.fromJson(Map<String, dynamic> json) =
      _$_PublicUserInfo.fromJson;

  @override
  String get uid => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get email => throw _privateConstructorUsedError;
  @override
  String? get errorMessage => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PublicUserInfoCopyWith<_PublicUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
