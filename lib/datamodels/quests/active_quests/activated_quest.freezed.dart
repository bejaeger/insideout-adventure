// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'activated_quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActivatedQuest _$ActivatedQuestFromJson(Map<String, dynamic> json) {
  return _ActivatedQuest.fromJson(json);
}

/// @nodoc
class _$ActivatedQuestTearOff {
  const _$ActivatedQuestTearOff();

  _ActivatedQuest call(
      {String? id,
      required Quest quest,
      required List<bool> markersCollected,
      required QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      required int timeElapsed,
      dynamic createdAt = ""}) {
    return _ActivatedQuest(
      id: id,
      quest: quest,
      markersCollected: markersCollected,
      status: status,
      uids: uids,
      afkCreditsEarned: afkCreditsEarned,
      timeElapsed: timeElapsed,
      createdAt: createdAt,
    );
  }

  ActivatedQuest fromJson(Map<String, Object> json) {
    return ActivatedQuest.fromJson(json);
  }
}

/// @nodoc
const $ActivatedQuest = _$ActivatedQuestTearOff();

/// @nodoc
mixin _$ActivatedQuest {
  String? get id => throw _privateConstructorUsedError;
  Quest get quest => throw _privateConstructorUsedError;
  List<bool> get markersCollected => throw _privateConstructorUsedError;
  QuestStatus get status => throw _privateConstructorUsedError;
  List<String>? get uids => throw _privateConstructorUsedError;
  String? get afkCreditsEarned => throw _privateConstructorUsedError;
  int get timeElapsed => throw _privateConstructorUsedError; // in seconds!
  dynamic get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivatedQuestCopyWith<ActivatedQuest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivatedQuestCopyWith<$Res> {
  factory $ActivatedQuestCopyWith(
          ActivatedQuest value, $Res Function(ActivatedQuest) then) =
      _$ActivatedQuestCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      Quest quest,
      List<bool> markersCollected,
      QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      int timeElapsed,
      dynamic createdAt});

  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class _$ActivatedQuestCopyWithImpl<$Res>
    implements $ActivatedQuestCopyWith<$Res> {
  _$ActivatedQuestCopyWithImpl(this._value, this._then);

  final ActivatedQuest _value;
  // ignore: unused_field
  final $Res Function(ActivatedQuest) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? quest = freezed,
    Object? markersCollected = freezed,
    Object? status = freezed,
    Object? uids = freezed,
    Object? afkCreditsEarned = freezed,
    Object? timeElapsed = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      quest: quest == freezed
          ? _value.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      markersCollected: markersCollected == freezed
          ? _value.markersCollected
          : markersCollected // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      uids: uids == freezed
          ? _value.uids
          : uids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      afkCreditsEarned: afkCreditsEarned == freezed
          ? _value.afkCreditsEarned
          : afkCreditsEarned // ignore: cast_nullable_to_non_nullable
              as String?,
      timeElapsed: timeElapsed == freezed
          ? _value.timeElapsed
          : timeElapsed // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }

  @override
  $QuestCopyWith<$Res> get quest {
    return $QuestCopyWith<$Res>(_value.quest, (value) {
      return _then(_value.copyWith(quest: value));
    });
  }
}

/// @nodoc
abstract class _$ActivatedQuestCopyWith<$Res>
    implements $ActivatedQuestCopyWith<$Res> {
  factory _$ActivatedQuestCopyWith(
          _ActivatedQuest value, $Res Function(_ActivatedQuest) then) =
      __$ActivatedQuestCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      Quest quest,
      List<bool> markersCollected,
      QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      int timeElapsed,
      dynamic createdAt});

  @override
  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class __$ActivatedQuestCopyWithImpl<$Res>
    extends _$ActivatedQuestCopyWithImpl<$Res>
    implements _$ActivatedQuestCopyWith<$Res> {
  __$ActivatedQuestCopyWithImpl(
      _ActivatedQuest _value, $Res Function(_ActivatedQuest) _then)
      : super(_value, (v) => _then(v as _ActivatedQuest));

  @override
  _ActivatedQuest get _value => super._value as _ActivatedQuest;

  @override
  $Res call({
    Object? id = freezed,
    Object? quest = freezed,
    Object? markersCollected = freezed,
    Object? status = freezed,
    Object? uids = freezed,
    Object? afkCreditsEarned = freezed,
    Object? timeElapsed = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_ActivatedQuest(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      quest: quest == freezed
          ? _value.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      markersCollected: markersCollected == freezed
          ? _value.markersCollected
          : markersCollected // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      uids: uids == freezed
          ? _value.uids
          : uids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      afkCreditsEarned: afkCreditsEarned == freezed
          ? _value.afkCreditsEarned
          : afkCreditsEarned // ignore: cast_nullable_to_non_nullable
              as String?,
      timeElapsed: timeElapsed == freezed
          ? _value.timeElapsed
          : timeElapsed // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ActivatedQuest implements _ActivatedQuest {
  _$_ActivatedQuest(
      {this.id,
      required this.quest,
      required this.markersCollected,
      required this.status,
      this.uids,
      this.afkCreditsEarned,
      required this.timeElapsed,
      this.createdAt = ""});

  factory _$_ActivatedQuest.fromJson(Map<String, dynamic> json) =>
      _$_$_ActivatedQuestFromJson(json);

  @override
  final String? id;
  @override
  final Quest quest;
  @override
  final List<bool> markersCollected;
  @override
  final QuestStatus status;
  @override
  final List<String>? uids;
  @override
  final String? afkCreditsEarned;
  @override
  final int timeElapsed;
  @JsonKey(defaultValue: "")
  @override // in seconds!
  final dynamic createdAt;

  @override
  String toString() {
    return 'ActivatedQuest(id: $id, quest: $quest, markersCollected: $markersCollected, status: $status, uids: $uids, afkCreditsEarned: $afkCreditsEarned, timeElapsed: $timeElapsed, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ActivatedQuest &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.quest, quest) ||
                const DeepCollectionEquality().equals(other.quest, quest)) &&
            (identical(other.markersCollected, markersCollected) ||
                const DeepCollectionEquality()
                    .equals(other.markersCollected, markersCollected)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.uids, uids) ||
                const DeepCollectionEquality().equals(other.uids, uids)) &&
            (identical(other.afkCreditsEarned, afkCreditsEarned) ||
                const DeepCollectionEquality()
                    .equals(other.afkCreditsEarned, afkCreditsEarned)) &&
            (identical(other.timeElapsed, timeElapsed) ||
                const DeepCollectionEquality()
                    .equals(other.timeElapsed, timeElapsed)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(quest) ^
      const DeepCollectionEquality().hash(markersCollected) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(uids) ^
      const DeepCollectionEquality().hash(afkCreditsEarned) ^
      const DeepCollectionEquality().hash(timeElapsed) ^
      const DeepCollectionEquality().hash(createdAt);

  @JsonKey(ignore: true)
  @override
  _$ActivatedQuestCopyWith<_ActivatedQuest> get copyWith =>
      __$ActivatedQuestCopyWithImpl<_ActivatedQuest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ActivatedQuestToJson(this);
  }
}

abstract class _ActivatedQuest implements ActivatedQuest {
  factory _ActivatedQuest(
      {String? id,
      required Quest quest,
      required List<bool> markersCollected,
      required QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      required int timeElapsed,
      dynamic createdAt}) = _$_ActivatedQuest;

  factory _ActivatedQuest.fromJson(Map<String, dynamic> json) =
      _$_ActivatedQuest.fromJson;

  @override
  String? get id => throw _privateConstructorUsedError;
  @override
  Quest get quest => throw _privateConstructorUsedError;
  @override
  List<bool> get markersCollected => throw _privateConstructorUsedError;
  @override
  QuestStatus get status => throw _privateConstructorUsedError;
  @override
  List<String>? get uids => throw _privateConstructorUsedError;
  @override
  String? get afkCreditsEarned => throw _privateConstructorUsedError;
  @override
  int get timeElapsed => throw _privateConstructorUsedError;
  @override // in seconds!
  dynamic get createdAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ActivatedQuestCopyWith<_ActivatedQuest> get copyWith =>
      throw _privateConstructorUsedError;
}
