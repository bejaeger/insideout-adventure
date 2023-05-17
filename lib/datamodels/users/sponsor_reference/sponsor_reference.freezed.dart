// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'guardian_reference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GuardianReference _$GuardianReferenceFromJson(Map<String, dynamic> json) {
  return _GuardianReference.fromJson(json);
}

/// @nodoc
mixin _$GuardianReference {
  String get uid => throw _privateConstructorUsedError;
  AuthenticationMethod? get authMethod => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  bool get withPasscode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GuardianReferenceCopyWith<GuardianReference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuardianReferenceCopyWith<$Res> {
  factory $GuardianReferenceCopyWith(
          GuardianReference value, $Res Function(GuardianReference) then) =
      _$GuardianReferenceCopyWithImpl<$Res>;
  $Res call(
      {String uid,
      AuthenticationMethod? authMethod,
      String? deviceId,
      bool withPasscode});
}

/// @nodoc
class _$GuardianReferenceCopyWithImpl<$Res>
    implements $GuardianReferenceCopyWith<$Res> {
  _$GuardianReferenceCopyWithImpl(this._value, this._then);

  final GuardianReference _value;
  // ignore: unused_field
  final $Res Function(GuardianReference) _then;

  @override
  $Res call({
    Object? uid = freezed,
    Object? authMethod = freezed,
    Object? deviceId = freezed,
    Object? withPasscode = freezed,
  }) {
    return _then(_value.copyWith(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      authMethod: authMethod == freezed
          ? _value.authMethod
          : authMethod // ignore: cast_nullable_to_non_nullable
              as AuthenticationMethod?,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      withPasscode: withPasscode == freezed
          ? _value.withPasscode
          : withPasscode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_GuardianReferenceCopyWith<$Res>
    implements $GuardianReferenceCopyWith<$Res> {
  factory _$$_GuardianReferenceCopyWith(_$_GuardianReference value,
          $Res Function(_$_GuardianReference) then) =
      __$$_GuardianReferenceCopyWithImpl<$Res>;
  @override
  $Res call(
      {String uid,
      AuthenticationMethod? authMethod,
      String? deviceId,
      bool withPasscode});
}

/// @nodoc
class __$$_GuardianReferenceCopyWithImpl<$Res>
    extends _$GuardianReferenceCopyWithImpl<$Res>
    implements _$$_GuardianReferenceCopyWith<$Res> {
  __$$_GuardianReferenceCopyWithImpl(
      _$_GuardianReference _value, $Res Function(_$_GuardianReference) _then)
      : super(_value, (v) => _then(v as _$_GuardianReference));

  @override
  _$_GuardianReference get _value => super._value as _$_GuardianReference;

  @override
  $Res call({
    Object? uid = freezed,
    Object? authMethod = freezed,
    Object? deviceId = freezed,
    Object? withPasscode = freezed,
  }) {
    return _then(_$_GuardianReference(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      authMethod: authMethod == freezed
          ? _value.authMethod
          : authMethod // ignore: cast_nullable_to_non_nullable
              as AuthenticationMethod?,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      withPasscode: withPasscode == freezed
          ? _value.withPasscode
          : withPasscode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GuardianReference implements _GuardianReference {
  _$_GuardianReference(
      {required this.uid,
      this.authMethod,
      this.deviceId,
      required this.withPasscode});

  factory _$_GuardianReference.fromJson(Map<String, dynamic> json) =>
      _$$_GuardianReferenceFromJson(json);

  @override
  final String uid;
  @override
  final AuthenticationMethod? authMethod;
  @override
  final String? deviceId;
  @override
  final bool withPasscode;

  @override
  String toString() {
    return 'GuardianReference(uid: $uid, authMethod: $authMethod, deviceId: $deviceId, withPasscode: $withPasscode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuardianReference &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality()
                .equals(other.authMethod, authMethod) &&
            const DeepCollectionEquality().equals(other.deviceId, deviceId) &&
            const DeepCollectionEquality()
                .equals(other.withPasscode, withPasscode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(authMethod),
      const DeepCollectionEquality().hash(deviceId),
      const DeepCollectionEquality().hash(withPasscode));

  @JsonKey(ignore: true)
  @override
  _$$_GuardianReferenceCopyWith<_$_GuardianReference> get copyWith =>
      __$$_GuardianReferenceCopyWithImpl<_$_GuardianReference>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GuardianReferenceToJson(
      this,
    );
  }
}

abstract class _GuardianReference implements GuardianReference {
  factory _GuardianReference(
      {required final String uid,
      final AuthenticationMethod? authMethod,
      final String? deviceId,
      required final bool withPasscode}) = _$_GuardianReference;

  factory _GuardianReference.fromJson(Map<String, dynamic> json) =
      _$_GuardianReference.fromJson;

  @override
  String get uid;
  @override
  AuthenticationMethod? get authMethod;
  @override
  String? get deviceId;
  @override
  bool get withPasscode;
  @override
  @JsonKey(ignore: true)
  _$$_GuardianReferenceCopyWith<_$_GuardianReference> get copyWith =>
      throw _privateConstructorUsedError;
}
