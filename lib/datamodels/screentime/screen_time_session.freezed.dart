// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'screen_time_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ScreenTimeSession _$ScreenTimeSessionFromJson(Map<String, dynamic> json) {
  return _ScreenTimeSession.fromJson(json);
}

/// @nodoc
class _$ScreenTimeSessionTearOff {
  const _$ScreenTimeSessionTearOff();

  _ScreenTimeSession call(
      {required String sessionId,
      required String uid,
      dynamic startedAt = "",
      dynamic endedAt = "",
      required int minutes,
      int? minutesUsed,
      num? afkCreditsUsed,
      required ScreenTimeSessionStatus status,
      required double afkCredits}) {
    return _ScreenTimeSession(
      sessionId: sessionId,
      uid: uid,
      startedAt: startedAt,
      endedAt: endedAt,
      minutes: minutes,
      minutesUsed: minutesUsed,
      afkCreditsUsed: afkCreditsUsed,
      status: status,
      afkCredits: afkCredits,
    );
  }

  ScreenTimeSession fromJson(Map<String, Object?> json) {
    return ScreenTimeSession.fromJson(json);
  }
}

/// @nodoc
const $ScreenTimeSession = _$ScreenTimeSessionTearOff();

/// @nodoc
mixin _$ScreenTimeSession {
  String get sessionId => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  dynamic get startedAt => throw _privateConstructorUsedError;
  dynamic get endedAt => throw _privateConstructorUsedError;
  int get minutes => throw _privateConstructorUsedError;
  int? get minutesUsed => throw _privateConstructorUsedError;
  num? get afkCreditsUsed => throw _privateConstructorUsedError;
  ScreenTimeSessionStatus get status => throw _privateConstructorUsedError;
  double get afkCredits => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScreenTimeSessionCopyWith<ScreenTimeSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenTimeSessionCopyWith<$Res> {
  factory $ScreenTimeSessionCopyWith(
          ScreenTimeSession value, $Res Function(ScreenTimeSession) then) =
      _$ScreenTimeSessionCopyWithImpl<$Res>;
  $Res call(
      {String sessionId,
      String uid,
      dynamic startedAt,
      dynamic endedAt,
      int minutes,
      int? minutesUsed,
      num? afkCreditsUsed,
      ScreenTimeSessionStatus status,
      double afkCredits});
}

/// @nodoc
class _$ScreenTimeSessionCopyWithImpl<$Res>
    implements $ScreenTimeSessionCopyWith<$Res> {
  _$ScreenTimeSessionCopyWithImpl(this._value, this._then);

  final ScreenTimeSession _value;
  // ignore: unused_field
  final $Res Function(ScreenTimeSession) _then;

  @override
  $Res call({
    Object? sessionId = freezed,
    Object? uid = freezed,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
    Object? minutes = freezed,
    Object? minutesUsed = freezed,
    Object? afkCreditsUsed = freezed,
    Object? status = freezed,
    Object? afkCredits = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: sessionId == freezed
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: startedAt == freezed
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      endedAt: endedAt == freezed
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      minutes: minutes == freezed
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
      minutesUsed: minutesUsed == freezed
          ? _value.minutesUsed
          : minutesUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      afkCreditsUsed: afkCreditsUsed == freezed
          ? _value.afkCreditsUsed
          : afkCreditsUsed // ignore: cast_nullable_to_non_nullable
              as num?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScreenTimeSessionStatus,
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$ScreenTimeSessionCopyWith<$Res>
    implements $ScreenTimeSessionCopyWith<$Res> {
  factory _$ScreenTimeSessionCopyWith(
          _ScreenTimeSession value, $Res Function(_ScreenTimeSession) then) =
      __$ScreenTimeSessionCopyWithImpl<$Res>;
  @override
  $Res call(
      {String sessionId,
      String uid,
      dynamic startedAt,
      dynamic endedAt,
      int minutes,
      int? minutesUsed,
      num? afkCreditsUsed,
      ScreenTimeSessionStatus status,
      double afkCredits});
}

/// @nodoc
class __$ScreenTimeSessionCopyWithImpl<$Res>
    extends _$ScreenTimeSessionCopyWithImpl<$Res>
    implements _$ScreenTimeSessionCopyWith<$Res> {
  __$ScreenTimeSessionCopyWithImpl(
      _ScreenTimeSession _value, $Res Function(_ScreenTimeSession) _then)
      : super(_value, (v) => _then(v as _ScreenTimeSession));

  @override
  _ScreenTimeSession get _value => super._value as _ScreenTimeSession;

  @override
  $Res call({
    Object? sessionId = freezed,
    Object? uid = freezed,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
    Object? minutes = freezed,
    Object? minutesUsed = freezed,
    Object? afkCreditsUsed = freezed,
    Object? status = freezed,
    Object? afkCredits = freezed,
  }) {
    return _then(_ScreenTimeSession(
      sessionId: sessionId == freezed
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: startedAt == freezed
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      endedAt: endedAt == freezed
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      minutes: minutes == freezed
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
      minutesUsed: minutesUsed == freezed
          ? _value.minutesUsed
          : minutesUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      afkCreditsUsed: afkCreditsUsed == freezed
          ? _value.afkCreditsUsed
          : afkCreditsUsed // ignore: cast_nullable_to_non_nullable
              as num?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScreenTimeSessionStatus,
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ScreenTimeSession implements _ScreenTimeSession {
  _$_ScreenTimeSession(
      {required this.sessionId,
      required this.uid,
      this.startedAt = "",
      this.endedAt = "",
      required this.minutes,
      this.minutesUsed,
      this.afkCreditsUsed,
      required this.status,
      required this.afkCredits});

  factory _$_ScreenTimeSession.fromJson(Map<String, dynamic> json) =>
      _$$_ScreenTimeSessionFromJson(json);

  @override
  final String sessionId;
  @override
  final String uid;
  @JsonKey()
  @override
  final dynamic startedAt;
  @JsonKey()
  @override
  final dynamic endedAt;
  @override
  final int minutes;
  @override
  final int? minutesUsed;
  @override
  final num? afkCreditsUsed;
  @override
  final ScreenTimeSessionStatus status;
  @override
  final double afkCredits;

  @override
  String toString() {
    return 'ScreenTimeSession(sessionId: $sessionId, uid: $uid, startedAt: $startedAt, endedAt: $endedAt, minutes: $minutes, minutesUsed: $minutesUsed, afkCreditsUsed: $afkCreditsUsed, status: $status, afkCredits: $afkCredits)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScreenTimeSession &&
            const DeepCollectionEquality().equals(other.sessionId, sessionId) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.startedAt, startedAt) &&
            const DeepCollectionEquality().equals(other.endedAt, endedAt) &&
            const DeepCollectionEquality().equals(other.minutes, minutes) &&
            const DeepCollectionEquality()
                .equals(other.minutesUsed, minutesUsed) &&
            const DeepCollectionEquality()
                .equals(other.afkCreditsUsed, afkCreditsUsed) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality()
                .equals(other.afkCredits, afkCredits));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(sessionId),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(startedAt),
      const DeepCollectionEquality().hash(endedAt),
      const DeepCollectionEquality().hash(minutes),
      const DeepCollectionEquality().hash(minutesUsed),
      const DeepCollectionEquality().hash(afkCreditsUsed),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(afkCredits));

  @JsonKey(ignore: true)
  @override
  _$ScreenTimeSessionCopyWith<_ScreenTimeSession> get copyWith =>
      __$ScreenTimeSessionCopyWithImpl<_ScreenTimeSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ScreenTimeSessionToJson(this);
  }
}

abstract class _ScreenTimeSession implements ScreenTimeSession {
  factory _ScreenTimeSession(
      {required String sessionId,
      required String uid,
      dynamic startedAt,
      dynamic endedAt,
      required int minutes,
      int? minutesUsed,
      num? afkCreditsUsed,
      required ScreenTimeSessionStatus status,
      required double afkCredits}) = _$_ScreenTimeSession;

  factory _ScreenTimeSession.fromJson(Map<String, dynamic> json) =
      _$_ScreenTimeSession.fromJson;

  @override
  String get sessionId;
  @override
  String get uid;
  @override
  dynamic get startedAt;
  @override
  dynamic get endedAt;
  @override
  int get minutes;
  @override
  int? get minutesUsed;
  @override
  num? get afkCreditsUsed;
  @override
  ScreenTimeSessionStatus get status;
  @override
  double get afkCredits;
  @override
  @JsonKey(ignore: true)
  _$ScreenTimeSessionCopyWith<_ScreenTimeSession> get copyWith =>
      throw _privateConstructorUsedError;
}