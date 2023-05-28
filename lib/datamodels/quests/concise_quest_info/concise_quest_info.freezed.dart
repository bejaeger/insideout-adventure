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
  num get credits => throw _privateConstructorUsedError;
  num get creditsEarned => throw _privateConstructorUsedError;

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
  $Res call({String name, QuestType type, num credits, num creditsEarned});
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
    Object? credits = freezed,
    Object? creditsEarned = freezed,
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
      credits: credits == freezed
          ? _value.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as num,
      creditsEarned: creditsEarned == freezed
          ? _value.creditsEarned
          : creditsEarned // ignore: cast_nullable_to_non_nullable
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
  $Res call({String name, QuestType type, num credits, num creditsEarned});
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
    Object? credits = freezed,
    Object? creditsEarned = freezed,
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
      credits: credits == freezed
          ? _value.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as num,
      creditsEarned: creditsEarned == freezed
          ? _value.creditsEarned
          : creditsEarned // ignore: cast_nullable_to_non_nullable
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
      required this.credits,
      required this.creditsEarned});

  factory _$_ConciseFinishedQuestInfo.fromJson(Map<String, dynamic> json) =>
      _$$_ConciseFinishedQuestInfoFromJson(json);

  @override
  final String name;
  @override
  final QuestType type;
  @override
  final num credits;
  @override
  final num creditsEarned;

  @override
  String toString() {
    return 'ConciseFinishedQuestInfo(name: $name, type: $type, credits: $credits, creditsEarned: $creditsEarned)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConciseFinishedQuestInfo &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.credits, credits) &&
            const DeepCollectionEquality()
                .equals(other.creditsEarned, creditsEarned));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(credits),
      const DeepCollectionEquality().hash(creditsEarned));

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
      required final num credits,
      required final num creditsEarned}) = _$_ConciseFinishedQuestInfo;

  factory _ConciseFinishedQuestInfo.fromJson(Map<String, dynamic> json) =
      _$_ConciseFinishedQuestInfo.fromJson;

  @override
  String get name;
  @override
  QuestType get type;
  @override
  num get credits;
  @override
  num get creditsEarned;
  @override
  @JsonKey(ignore: true)
  _$$_ConciseFinishedQuestInfoCopyWith<_$_ConciseFinishedQuestInfo>
      get copyWith => throw _privateConstructorUsedError;
}
