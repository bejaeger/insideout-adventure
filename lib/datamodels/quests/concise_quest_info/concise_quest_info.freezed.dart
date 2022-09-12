// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'concise_quest_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConciseFinishedQuestInfo _$ConciseFinishedQuestInfoFromJson(
    Map<String, dynamic> json) {
  return _ConciseFinishedQuestInfo.fromJson(json);
}

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
abstract class _$$_ConciseFinishedQuestInfoCopyWith<$Res>
    implements $ConciseFinishedQuestInfoCopyWith<$Res> {
  factory _$$_ConciseFinishedQuestInfoCopyWith(
          _$_ConciseFinishedQuestInfo value,
          $Res Function(_$_ConciseFinishedQuestInfo) then) =
      __$$_ConciseFinishedQuestInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name, QuestType type, num afkCredits, num afkCreditsEarned});
}

/// @nodoc
class __$$_ConciseFinishedQuestInfoCopyWithImpl<$Res>
    extends _$ConciseFinishedQuestInfoCopyWithImpl<$Res>
    implements _$$_ConciseFinishedQuestInfoCopyWith<$Res> {
  __$$_ConciseFinishedQuestInfoCopyWithImpl(_$_ConciseFinishedQuestInfo _value,
      $Res Function(_$_ConciseFinishedQuestInfo) _then)
      : super(_value, (v) => _then(v as _$_ConciseFinishedQuestInfo));

  @override
  _$_ConciseFinishedQuestInfo get _value =>
      super._value as _$_ConciseFinishedQuestInfo;

  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? afkCredits = freezed,
    Object? afkCreditsEarned = freezed,
  }) {
    return _then(_$_ConciseFinishedQuestInfo(
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
      _$$_ConciseFinishedQuestInfoFromJson(json);

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
        (other.runtimeType == runtimeType &&
            other is _$_ConciseFinishedQuestInfo &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.afkCredits, afkCredits) &&
            const DeepCollectionEquality()
                .equals(other.afkCreditsEarned, afkCreditsEarned));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(afkCredits),
      const DeepCollectionEquality().hash(afkCreditsEarned));

  @JsonKey(ignore: true)
  @override
  _$$_ConciseFinishedQuestInfoCopyWith<_$_ConciseFinishedQuestInfo>
      get copyWith => __$$_ConciseFinishedQuestInfoCopyWithImpl<
          _$_ConciseFinishedQuestInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConciseFinishedQuestInfoToJson(
      this,
    );
  }
}

abstract class _ConciseFinishedQuestInfo implements ConciseFinishedQuestInfo {
  factory _ConciseFinishedQuestInfo(
      {required final String name,
      required final QuestType type,
      required final num afkCredits,
      required final num afkCreditsEarned}) = _$_ConciseFinishedQuestInfo;

  factory _ConciseFinishedQuestInfo.fromJson(Map<String, dynamic> json) =
      _$_ConciseFinishedQuestInfo.fromJson;

  @override
  String get name;
  @override
  QuestType get type;
  @override
  num get afkCredits;
  @override
  num get afkCreditsEarned;
  @override
  @JsonKey(ignore: true)
  _$$_ConciseFinishedQuestInfoCopyWith<_$_ConciseFinishedQuestInfo>
      get copyWith => throw _privateConstructorUsedError;
}
