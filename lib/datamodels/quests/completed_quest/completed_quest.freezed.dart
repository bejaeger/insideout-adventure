// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'completed_quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CompletedQuest _$CompletedQuestFromJson(Map<String, dynamic> json) {
  return _CompletedQuest.fromJson(json);
}

/// @nodoc
class _$CompletedQuestTearOff {
  const _$CompletedQuestTearOff();

  _CompletedQuest call(
      {String? id,
      String? questId,
      required int? numberMarkersCollected,
      required QuestStatus status,
      num? afkCreditsEarned,
      String? timeElapsed}) {
    return _CompletedQuest(
      id: id,
      questId: questId,
      numberMarkersCollected: numberMarkersCollected,
      status: status,
      afkCreditsEarned: afkCreditsEarned,
      timeElapsed: timeElapsed,
    );
  }

  CompletedQuest fromJson(Map<String, Object> json) {
    return CompletedQuest.fromJson(json);
  }
}

/// @nodoc
const $CompletedQuest = _$CompletedQuestTearOff();

/// @nodoc
mixin _$CompletedQuest {
  String? get id => throw _privateConstructorUsedError;
  String? get questId =>
      throw _privateConstructorUsedError; //required Quest quest,
  int? get numberMarkersCollected => throw _privateConstructorUsedError;
  QuestStatus get status => throw _privateConstructorUsedError;
  num? get afkCreditsEarned => throw _privateConstructorUsedError;
  String? get timeElapsed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompletedQuestCopyWith<CompletedQuest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletedQuestCopyWith<$Res> {
  factory $CompletedQuestCopyWith(
          CompletedQuest value, $Res Function(CompletedQuest) then) =
      _$CompletedQuestCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String? questId,
      int? numberMarkersCollected,
      QuestStatus status,
      num? afkCreditsEarned,
      String? timeElapsed});
}

/// @nodoc
class _$CompletedQuestCopyWithImpl<$Res>
    implements $CompletedQuestCopyWith<$Res> {
  _$CompletedQuestCopyWithImpl(this._value, this._then);

  final CompletedQuest _value;
  // ignore: unused_field
  final $Res Function(CompletedQuest) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? questId = freezed,
    Object? numberMarkersCollected = freezed,
    Object? status = freezed,
    Object? afkCreditsEarned = freezed,
    Object? timeElapsed = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: questId == freezed
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberMarkersCollected: numberMarkersCollected == freezed
          ? _value.numberMarkersCollected
          : numberMarkersCollected // ignore: cast_nullable_to_non_nullable
              as int?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      afkCreditsEarned: afkCreditsEarned == freezed
          ? _value.afkCreditsEarned
          : afkCreditsEarned // ignore: cast_nullable_to_non_nullable
              as num?,
      timeElapsed: timeElapsed == freezed
          ? _value.timeElapsed
          : timeElapsed // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$CompletedQuestCopyWith<$Res>
    implements $CompletedQuestCopyWith<$Res> {
  factory _$CompletedQuestCopyWith(
          _CompletedQuest value, $Res Function(_CompletedQuest) then) =
      __$CompletedQuestCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String? questId,
      int? numberMarkersCollected,
      QuestStatus status,
      num? afkCreditsEarned,
      String? timeElapsed});
}

/// @nodoc
class __$CompletedQuestCopyWithImpl<$Res>
    extends _$CompletedQuestCopyWithImpl<$Res>
    implements _$CompletedQuestCopyWith<$Res> {
  __$CompletedQuestCopyWithImpl(
      _CompletedQuest _value, $Res Function(_CompletedQuest) _then)
      : super(_value, (v) => _then(v as _CompletedQuest));

  @override
  _CompletedQuest get _value => super._value as _CompletedQuest;

  @override
  $Res call({
    Object? id = freezed,
    Object? questId = freezed,
    Object? numberMarkersCollected = freezed,
    Object? status = freezed,
    Object? afkCreditsEarned = freezed,
    Object? timeElapsed = freezed,
  }) {
    return _then(_CompletedQuest(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: questId == freezed
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberMarkersCollected: numberMarkersCollected == freezed
          ? _value.numberMarkersCollected
          : numberMarkersCollected // ignore: cast_nullable_to_non_nullable
              as int?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      afkCreditsEarned: afkCreditsEarned == freezed
          ? _value.afkCreditsEarned
          : afkCreditsEarned // ignore: cast_nullable_to_non_nullable
              as num?,
      timeElapsed: timeElapsed == freezed
          ? _value.timeElapsed
          : timeElapsed // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_CompletedQuest implements _CompletedQuest {
  _$_CompletedQuest(
      {this.id,
      this.questId,
      required this.numberMarkersCollected,
      required this.status,
      this.afkCreditsEarned,
      this.timeElapsed});

  factory _$_CompletedQuest.fromJson(Map<String, dynamic> json) =>
      _$_$_CompletedQuestFromJson(json);

  @override
  final String? id;
  @override
  final String? questId;
  @override //required Quest quest,
  final int? numberMarkersCollected;
  @override
  final QuestStatus status;
  @override
  final num? afkCreditsEarned;
  @override
  final String? timeElapsed;

  @override
  String toString() {
    return 'CompletedQuest(id: $id, questId: $questId, numberMarkersCollected: $numberMarkersCollected, status: $status, afkCreditsEarned: $afkCreditsEarned, timeElapsed: $timeElapsed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CompletedQuest &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality()
                    .equals(other.questId, questId)) &&
            (identical(other.numberMarkersCollected, numberMarkersCollected) ||
                const DeepCollectionEquality().equals(
                    other.numberMarkersCollected, numberMarkersCollected)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.afkCreditsEarned, afkCreditsEarned) ||
                const DeepCollectionEquality()
                    .equals(other.afkCreditsEarned, afkCreditsEarned)) &&
            (identical(other.timeElapsed, timeElapsed) ||
                const DeepCollectionEquality()
                    .equals(other.timeElapsed, timeElapsed)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(questId) ^
      const DeepCollectionEquality().hash(numberMarkersCollected) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(afkCreditsEarned) ^
      const DeepCollectionEquality().hash(timeElapsed);

  @JsonKey(ignore: true)
  @override
  _$CompletedQuestCopyWith<_CompletedQuest> get copyWith =>
      __$CompletedQuestCopyWithImpl<_CompletedQuest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CompletedQuestToJson(this);
  }
}

abstract class _CompletedQuest implements CompletedQuest {
  factory _CompletedQuest(
      {String? id,
      String? questId,
      required int? numberMarkersCollected,
      required QuestStatus status,
      num? afkCreditsEarned,
      String? timeElapsed}) = _$_CompletedQuest;

  factory _CompletedQuest.fromJson(Map<String, dynamic> json) =
      _$_CompletedQuest.fromJson;

  @override
  String? get id => throw _privateConstructorUsedError;
  @override
  String? get questId => throw _privateConstructorUsedError;
  @override //required Quest quest,
  int? get numberMarkersCollected => throw _privateConstructorUsedError;
  @override
  QuestStatus get status => throw _privateConstructorUsedError;
  @override
  num? get afkCreditsEarned => throw _privateConstructorUsedError;
  @override
  String? get timeElapsed => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CompletedQuestCopyWith<_CompletedQuest> get copyWith =>
      throw _privateConstructorUsedError;
}
