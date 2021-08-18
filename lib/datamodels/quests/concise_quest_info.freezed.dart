// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'concise_quest_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConciseQuestInfo _$ConciseQuestInfoFromJson(Map<String, dynamic> json) {
  return _ConciseQuestInfo.fromJson(json);
}

/// @nodoc
class _$ConciseQuestInfoTearOff {
  const _$ConciseQuestInfoTearOff();

  _ConciseQuestInfo call(
      {required String name,
      required QuestType type,
      required num afkCredits,
      required num afkCreditsEarned}) {
    return _ConciseQuestInfo(
      name: name,
      type: type,
      afkCredits: afkCredits,
      afkCreditsEarned: afkCreditsEarned,
    );
  }

  ConciseQuestInfo fromJson(Map<String, Object> json) {
    return ConciseQuestInfo.fromJson(json);
  }
}

/// @nodoc
const $ConciseQuestInfo = _$ConciseQuestInfoTearOff();

/// @nodoc
mixin _$ConciseQuestInfo {
  String get name => throw _privateConstructorUsedError;
  QuestType get type => throw _privateConstructorUsedError;
  num get afkCredits => throw _privateConstructorUsedError;
  num get afkCreditsEarned => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConciseQuestInfoCopyWith<ConciseQuestInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConciseQuestInfoCopyWith<$Res> {
  factory $ConciseQuestInfoCopyWith(
          ConciseQuestInfo value, $Res Function(ConciseQuestInfo) then) =
      _$ConciseQuestInfoCopyWithImpl<$Res>;
  $Res call(
      {String name, QuestType type, num afkCredits, num afkCreditsEarned});
}

/// @nodoc
class _$ConciseQuestInfoCopyWithImpl<$Res>
    implements $ConciseQuestInfoCopyWith<$Res> {
  _$ConciseQuestInfoCopyWithImpl(this._value, this._then);

  final ConciseQuestInfo _value;
  // ignore: unused_field
  final $Res Function(ConciseQuestInfo) _then;

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
abstract class _$ConciseQuestInfoCopyWith<$Res>
    implements $ConciseQuestInfoCopyWith<$Res> {
  factory _$ConciseQuestInfoCopyWith(
          _ConciseQuestInfo value, $Res Function(_ConciseQuestInfo) then) =
      __$ConciseQuestInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name, QuestType type, num afkCredits, num afkCreditsEarned});
}

/// @nodoc
class __$ConciseQuestInfoCopyWithImpl<$Res>
    extends _$ConciseQuestInfoCopyWithImpl<$Res>
    implements _$ConciseQuestInfoCopyWith<$Res> {
  __$ConciseQuestInfoCopyWithImpl(
      _ConciseQuestInfo _value, $Res Function(_ConciseQuestInfo) _then)
      : super(_value, (v) => _then(v as _ConciseQuestInfo));

  @override
  _ConciseQuestInfo get _value => super._value as _ConciseQuestInfo;

  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? afkCredits = freezed,
    Object? afkCreditsEarned = freezed,
  }) {
    return _then(_ConciseQuestInfo(
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
class _$_ConciseQuestInfo implements _ConciseQuestInfo {
  _$_ConciseQuestInfo(
      {required this.name,
      required this.type,
      required this.afkCredits,
      required this.afkCreditsEarned});

  factory _$_ConciseQuestInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_ConciseQuestInfoFromJson(json);

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
    return 'ConciseQuestInfo(name: $name, type: $type, afkCredits: $afkCredits, afkCreditsEarned: $afkCreditsEarned)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConciseQuestInfo &&
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
  _$ConciseQuestInfoCopyWith<_ConciseQuestInfo> get copyWith =>
      __$ConciseQuestInfoCopyWithImpl<_ConciseQuestInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConciseQuestInfoToJson(this);
  }
}

abstract class _ConciseQuestInfo implements ConciseQuestInfo {
  factory _ConciseQuestInfo(
      {required String name,
      required QuestType type,
      required num afkCredits,
      required num afkCreditsEarned}) = _$_ConciseQuestInfo;

  factory _ConciseQuestInfo.fromJson(Map<String, dynamic> json) =
      _$_ConciseQuestInfo.fromJson;

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
  _$ConciseQuestInfoCopyWith<_ConciseQuestInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
