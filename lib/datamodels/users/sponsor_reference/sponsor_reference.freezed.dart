// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'sponsor_reference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SponsorReference _$SponsorReferenceFromJson(Map<String, dynamic> json) {
  return _SponsorReference.fromJson(json);
}

/// @nodoc
class _$SponsorReferenceTearOff {
  const _$SponsorReferenceTearOff();

  _SponsorReference call(
      {required String uid,
      AuthenticationMethod? authMethod,
      required bool withPasscode}) {
    return _SponsorReference(
      uid: uid,
      authMethod: authMethod,
      withPasscode: withPasscode,
    );
  }

  SponsorReference fromJson(Map<String, Object> json) {
    return SponsorReference.fromJson(json);
  }
}

/// @nodoc
const $SponsorReference = _$SponsorReferenceTearOff();

/// @nodoc
mixin _$SponsorReference {
  String get uid => throw _privateConstructorUsedError;
  AuthenticationMethod? get authMethod => throw _privateConstructorUsedError;
  bool get withPasscode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SponsorReferenceCopyWith<SponsorReference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SponsorReferenceCopyWith<$Res> {
  factory $SponsorReferenceCopyWith(
          SponsorReference value, $Res Function(SponsorReference) then) =
      _$SponsorReferenceCopyWithImpl<$Res>;
  $Res call({String uid, AuthenticationMethod? authMethod, bool withPasscode});
}

/// @nodoc
class _$SponsorReferenceCopyWithImpl<$Res>
    implements $SponsorReferenceCopyWith<$Res> {
  _$SponsorReferenceCopyWithImpl(this._value, this._then);

  final SponsorReference _value;
  // ignore: unused_field
  final $Res Function(SponsorReference) _then;

  @override
  $Res call({
    Object? uid = freezed,
    Object? authMethod = freezed,
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
      withPasscode: withPasscode == freezed
          ? _value.withPasscode
          : withPasscode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$SponsorReferenceCopyWith<$Res>
    implements $SponsorReferenceCopyWith<$Res> {
  factory _$SponsorReferenceCopyWith(
          _SponsorReference value, $Res Function(_SponsorReference) then) =
      __$SponsorReferenceCopyWithImpl<$Res>;
  @override
  $Res call({String uid, AuthenticationMethod? authMethod, bool withPasscode});
}

/// @nodoc
class __$SponsorReferenceCopyWithImpl<$Res>
    extends _$SponsorReferenceCopyWithImpl<$Res>
    implements _$SponsorReferenceCopyWith<$Res> {
  __$SponsorReferenceCopyWithImpl(
      _SponsorReference _value, $Res Function(_SponsorReference) _then)
      : super(_value, (v) => _then(v as _SponsorReference));

  @override
  _SponsorReference get _value => super._value as _SponsorReference;

  @override
  $Res call({
    Object? uid = freezed,
    Object? authMethod = freezed,
    Object? withPasscode = freezed,
  }) {
    return _then(_SponsorReference(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      authMethod: authMethod == freezed
          ? _value.authMethod
          : authMethod // ignore: cast_nullable_to_non_nullable
              as AuthenticationMethod?,
      withPasscode: withPasscode == freezed
          ? _value.withPasscode
          : withPasscode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SponsorReference implements _SponsorReference {
  _$_SponsorReference(
      {required this.uid, this.authMethod, required this.withPasscode});

  factory _$_SponsorReference.fromJson(Map<String, dynamic> json) =>
      _$$_SponsorReferenceFromJson(json);

  @override
  final String uid;
  @override
  final AuthenticationMethod? authMethod;
  @override
  final bool withPasscode;

  @override
  String toString() {
    return 'SponsorReference(uid: $uid, authMethod: $authMethod, withPasscode: $withPasscode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SponsorReference &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.authMethod, authMethod) ||
                const DeepCollectionEquality()
                    .equals(other.authMethod, authMethod)) &&
            (identical(other.withPasscode, withPasscode) ||
                const DeepCollectionEquality()
                    .equals(other.withPasscode, withPasscode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(authMethod) ^
      const DeepCollectionEquality().hash(withPasscode);

  @JsonKey(ignore: true)
  @override
  _$SponsorReferenceCopyWith<_SponsorReference> get copyWith =>
      __$SponsorReferenceCopyWithImpl<_SponsorReference>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SponsorReferenceToJson(this);
  }
}

abstract class _SponsorReference implements SponsorReference {
  factory _SponsorReference(
      {required String uid,
      AuthenticationMethod? authMethod,
      required bool withPasscode}) = _$_SponsorReference;

  factory _SponsorReference.fromJson(Map<String, dynamic> json) =
      _$_SponsorReference.fromJson;

  @override
  String get uid => throw _privateConstructorUsedError;
  @override
  AuthenticationMethod? get authMethod => throw _privateConstructorUsedError;
  @override
  bool get withPasscode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SponsorReferenceCopyWith<_SponsorReference> get copyWith =>
      throw _privateConstructorUsedError;
}
