// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'concise_quest_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConciseFinishedQuestInfo _$ConciseFinishedQuestInfoFromJson(
    Map<String, dynamic> json) {
  return _ConciseFinishedQuestInfo.fromJson(json);
}

/// @nodoc
class _$ConciseFinishedQuestInfoTearOff {
  const _$ConciseFinishedQuestInfoTearOff();

  _ConciseFinishedQuestInfo call(
      {required String name,
      required QuestType type,
      required num afkCredits,
      required num afkCreditsEarned}) {
    return _ConciseFinishedQuestInfo(
      name: name,
      type: type,
      afkCredits: afkCredits,
      afkCreditsEarned: afkCreditsEarned,
    );
  }

  ConciseFinishedQuestInfo fromJson(Map<String, Object> json) {
    return ConciseFinishedQuestInfo.fromJson(json);
  }
}

/// @nodoc
const $ConciseFinishedQuestInfo = _$ConciseFinishedQuestInfoTearOff();

/// @nodoc
mixin _$ConciseFinishedQuestInfo {
  String get name => throw _privateConstructorUsedError;
  QuestType get type => throw _privateConstructorUsedError;
  num get afkCredits => throw _privateConstructorUsedError;
  num get afkCreditsEarned => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConciseFinishedQuestInfoCopyWith<ConciseFinishedQuestInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConciseFinishedQuestInfoCopyWith<$Res> {
  factory $ConciseFinishedQuestInfoCopyWith(ConciseFinishedQuestInfo value,
          $Res Function(ConciseFinishedQuestInfo) then) =
      _$ConciseFinishedQuestInfoCopyWithImpl<$Res>;
  $Res call(
      {String name, QuestType type, num afkCredits, num afkCreditsEarned});
}

/// @nodoc
class _$ConciseFinishedQuestInfoCopyWithImpl<$Res>
    implements $ConciseFinishedQuestInfoCopyWith<$Res> {
  _$ConciseFinishedQuestInfoCopyWithImpl(this._value, this._then);

  final ConciseFinishedQuestInfo _value;
  // ignore: unused_field
  final $Res Function(ConciseFinishedQuestInfo) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? afkCredits = freezed,
    Object? afkCreditsEarned = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestType,
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as num,
      afkCreditsEarned: afkCreditsEarned == freezed
          ? _value.afkCreditsEarned
          : afkCreditsEarned // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
abstract class _$ConciseFinishedQuestInfoCopyWith<$Res>
    implements $ConciseFinishedQuestInfoCopyWith<$Res> {
  factory _$ConciseFinishedQuestInfoCopyWith(_ConciseFinishedQuestInfo value,
          $Res Function(_ConciseFinishedQuestInfo) then) =
      __$ConciseFinishedQuestInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name, QuestType type, num afkCredits, num afkCreditsEarned});
}

/// @nodoc
class __$ConciseFinishedQuestInfoCopyWithImpl<$Res>
    extends _$ConciseFinishedQuestInfoCopyWithImpl<$Res>
    implements _$ConciseFinishedQuestInfoCopyWith<$Res> {
  __$ConciseFinishedQuestInfoCopyWithImpl(_ConciseFinishedQuestInfo _value,
      $Res Function(_ConciseFinishedQuestInfo) _then)
      : super(_value, (v) => _then(v as _ConciseFinishedQuestInfo));

  @override
  _ConciseFinishedQuestInfo get _value =>
      super._value as _ConciseFinishedQuestInfo;

  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? afkCredits = freezed,
    Object? afkCreditsEarned = freezed,
  }) {
    return _then(_ConciseFinishedQuestInfo(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestType,
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as num,
      afkCreditsEarned: afkCreditsEarned == freezed
          ? _value.afkCreditsEarned
          : afkCreditsEarned // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ConciseFinishedQuestInfo implements _ConciseFinishedQuestInfo {
  _$_ConciseFinishedQuestInfo(
      {required this.name,
      required this.type,
      required this.afkCredits,
      required this.afkCreditsEarned});

  factory _$_ConciseFinishedQuestInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_ConciseFinishedQuestInfoFromJson(json);

  @override
  final String name;
  @override
  final QuestType type;
  @override
  final num afkCredits;
  @override
  final num afkCreditsEarned;

  @override
  String toString() {
    return 'ConciseFinishedQuestInfo(name: $name, type: $type, afkCredits: $afkCredits, afkCreditsEarned: $afkCreditsEarned)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConciseFinishedQuestInfo &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.afkCredits, afkCredits) ||
                const DeepCollectionEquality()
                    .equals(other.afkCredits, afkCredits)) &&
            (identical(other.afkCreditsEarned, afkCreditsEarned) ||
                const DeepCollectionEquality()
                    .equals(other.afkCreditsEarned, afkCreditsEarned)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(afkCredits) ^
      const DeepCollectionEquality().hash(afkCreditsEarned);

  @JsonKey(ignore: true)
  @override
  _$ConciseFinishedQuestInfoCopyWith<_ConciseFinishedQuestInfo> get copyWith =>
      __$ConciseFinishedQuestInfoCopyWithImpl<_ConciseFinishedQuestInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConciseFinishedQuestInfoToJson(this);
  }
}

abstract class _ConciseFinishedQuestInfo implements ConciseFinishedQuestInfo {
  factory _ConciseFinishedQuestInfo(
      {required String name,
      required QuestType type,
      required num afkCredits,
      required num afkCreditsEarned}) = _$_ConciseFinishedQuestInfo;

  factory _ConciseFinishedQuestInfo.fromJson(Map<String, dynamic> json) =
      _$_ConciseFinishedQuestInfo.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  QuestType get type => throw _privateConstructorUsedError;
  @override
  num get afkCredits => throw _privateConstructorUsedError;
  @override
  num get afkCreditsEarned => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConciseFinishedQuestInfoCopyWith<_ConciseFinishedQuestInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
