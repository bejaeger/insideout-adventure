// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'public_user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PublicUserInfo _$PublicUserInfoFromJson(Map<String, dynamic> json) {
  return _PublicUserInfo.fromJson(json);
}

/// @nodoc
mixin _$PublicUserInfo {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool? get isSponsored => throw _privateConstructorUsedError;

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
  $Res call(
      {String uid,
      String name,
      String? email,
      String? errorMessage,
      bool? isSponsored});
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
    Object? isSponsored = freezed,
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
      isSponsored: isSponsored == freezed
          ? _value.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
abstract class _$$_PublicUserInfoCopyWith<$Res>
    implements $PublicUserInfoCopyWith<$Res> {
  factory _$$_PublicUserInfoCopyWith(
          _$_PublicUserInfo value, $Res Function(_$_PublicUserInfo) then) =
      __$$_PublicUserInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String uid,
      String name,
      String? email,
      String? errorMessage,
      bool? isSponsored});
}

/// @nodoc
class __$$_PublicUserInfoCopyWithImpl<$Res>
    extends _$PublicUserInfoCopyWithImpl<$Res>
    implements _$$_PublicUserInfoCopyWith<$Res> {
  __$$_PublicUserInfoCopyWithImpl(
      _$_PublicUserInfo _value, $Res Function(_$_PublicUserInfo) _then)
      : super(_value, (v) => _then(v as _$_PublicUserInfo));

  @override
  _$_PublicUserInfo get _value => super._value as _$_PublicUserInfo;

  @override
  $Res call({
    Object? uid = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? errorMessage = freezed,
    Object? isSponsored = freezed,
  }) {
    return _then(_$_PublicUserInfo(
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
      isSponsored: isSponsored == freezed
          ? _value.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PublicUserInfo implements _PublicUserInfo {
  _$_PublicUserInfo(
      {required this.uid,
      required this.name,
      this.email,
      this.errorMessage,
      this.isSponsored});

  factory _$_PublicUserInfo.fromJson(Map<String, dynamic> json) =>
      _$$_PublicUserInfoFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? errorMessage;
  @override
  final bool? isSponsored;

  @override
  String toString() {
    return 'PublicUserInfo(uid: $uid, name: $name, email: $email, errorMessage: $errorMessage, isSponsored: $isSponsored)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PublicUserInfo &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality()
                .equals(other.errorMessage, errorMessage) &&
            const DeepCollectionEquality()
                .equals(other.isSponsored, isSponsored));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(errorMessage),
      const DeepCollectionEquality().hash(isSponsored));

  @JsonKey(ignore: true)
  @override
  _$$_PublicUserInfoCopyWith<_$_PublicUserInfo> get copyWith =>
      __$$_PublicUserInfoCopyWithImpl<_$_PublicUserInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PublicUserInfoToJson(
      this,
    );
  }
}

abstract class _PublicUserInfo implements PublicUserInfo {
  factory _PublicUserInfo(
      {required final String uid,
      required final String name,
      final String? email,
      final String? errorMessage,
      final bool? isSponsored}) = _$_PublicUserInfo;

  factory _PublicUserInfo.fromJson(Map<String, dynamic> json) =
      _$_PublicUserInfo.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get errorMessage;
  @override
  bool? get isSponsored;
  @override
  @JsonKey(ignore: true)
  _$$_PublicUserInfoCopyWith<_$_PublicUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
