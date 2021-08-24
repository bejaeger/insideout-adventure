// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'active_quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActiveQuest _$ActiveQuestFromJson(Map<String, dynamic> json) {
  return _ActiveQuest.fromJson(json);
}

/// @nodoc
class _$ActiveQuestTearOff {
  const _$ActiveQuestTearOff();

  _ActiveQuest call(
      {required String id,
      required Quest quest,
      required List<Marker> markersCollected,
      required QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      int? timeElapsed,
      dynamic createdAt = ""}) {
    return _ActiveQuest(
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

  ActiveQuest fromJson(Map<String, Object> json) {
    return ActiveQuest.fromJson(json);
  }
}

/// @nodoc
const $ActiveQuest = _$ActiveQuestTearOff();

/// @nodoc
mixin _$ActiveQuest {
  String get id => throw _privateConstructorUsedError;
  Quest get quest => throw _privateConstructorUsedError;
  List<Marker> get markersCollected => throw _privateConstructorUsedError;
  QuestStatus get status => throw _privateConstructorUsedError;
  List<String>? get uids => throw _privateConstructorUsedError;
  String? get afkCreditsEarned => throw _privateConstructorUsedError;
  int? get timeElapsed => throw _privateConstructorUsedError; // in seconds!
  dynamic get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActiveQuestCopyWith<ActiveQuest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveQuestCopyWith<$Res> {
  factory $ActiveQuestCopyWith(
          ActiveQuest value, $Res Function(ActiveQuest) then) =
      _$ActiveQuestCopyWithImpl<$Res>;
  $Res call(
      {String id,
      Quest quest,
      List<Marker> markersCollected,
      QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      int? timeElapsed,
      dynamic createdAt});

  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class _$ActiveQuestCopyWithImpl<$Res> implements $ActiveQuestCopyWith<$Res> {
  _$ActiveQuestCopyWithImpl(this._value, this._then);

  final ActiveQuest _value;
  // ignore: unused_field
  final $Res Function(ActiveQuest) _then;

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
              as String,
      quest: quest == freezed
          ? _value.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      markersCollected: markersCollected == freezed
          ? _value.markersCollected
          : markersCollected // ignore: cast_nullable_to_non_nullable
              as List<Marker>,
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
              as int?,
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
abstract class _$ActiveQuestCopyWith<$Res>
    implements $ActiveQuestCopyWith<$Res> {
  factory _$ActiveQuestCopyWith(
          _ActiveQuest value, $Res Function(_ActiveQuest) then) =
      __$ActiveQuestCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      Quest quest,
      List<Marker> markersCollected,
      QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      int? timeElapsed,
      dynamic createdAt});

  @override
  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class __$ActiveQuestCopyWithImpl<$Res> extends _$ActiveQuestCopyWithImpl<$Res>
    implements _$ActiveQuestCopyWith<$Res> {
  __$ActiveQuestCopyWithImpl(
      _ActiveQuest _value, $Res Function(_ActiveQuest) _then)
      : super(_value, (v) => _then(v as _ActiveQuest));

  @override
  _ActiveQuest get _value => super._value as _ActiveQuest;

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
    return _then(_ActiveQuest(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quest: quest == freezed
          ? _value.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      markersCollected: markersCollected == freezed
          ? _value.markersCollected
          : markersCollected // ignore: cast_nullable_to_non_nullable
              as List<Marker>,
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
              as int?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActiveQuest implements _ActiveQuest {
  _$_ActiveQuest(
      {required this.id,
      required this.quest,
      required this.markersCollected,
      required this.status,
      this.uids,
      this.afkCreditsEarned,
      this.timeElapsed,
      this.createdAt = ""});

  factory _$_ActiveQuest.fromJson(Map<String, dynamic> json) =>
      _$_$_ActiveQuestFromJson(json);

  @override
  final String id;
  @override
  final Quest quest;
  @override
  final List<Marker> markersCollected;
  @override
  final QuestStatus status;
  @override
  final List<String>? uids;
  @override
  final String? afkCreditsEarned;
  @override
  final int? timeElapsed;
  @JsonKey(defaultValue: "")
  @override // in seconds!
  final dynamic createdAt;

  @override
  String toString() {
    return 'ActiveQuest(id: $id, quest: $quest, markersCollected: $markersCollected, status: $status, uids: $uids, afkCreditsEarned: $afkCreditsEarned, timeElapsed: $timeElapsed, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ActiveQuest &&
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
  _$ActiveQuestCopyWith<_ActiveQuest> get copyWith =>
      __$ActiveQuestCopyWithImpl<_ActiveQuest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ActiveQuestToJson(this);
  }
}

abstract class _ActiveQuest implements ActiveQuest {
  factory _ActiveQuest(
      {required String id,
      required Quest quest,
      required List<Marker> markersCollected,
      required QuestStatus status,
      List<String>? uids,
      String? afkCreditsEarned,
      int? timeElapsed,
      dynamic createdAt}) = _$_ActiveQuest;

  factory _ActiveQuest.fromJson(Map<String, dynamic> json) =
      _$_ActiveQuest.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  Quest get quest => throw _privateConstructorUsedError;
  @override
  List<Marker> get markersCollected => throw _privateConstructorUsedError;
  @override
  QuestStatus get status => throw _privateConstructorUsedError;
  @override
  List<String>? get uids => throw _privateConstructorUsedError;
  @override
  String? get afkCreditsEarned => throw _privateConstructorUsedError;
  @override
  int? get timeElapsed => throw _privateConstructorUsedError;
  @override // in seconds!
  dynamic get createdAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ActiveQuestCopyWith<_ActiveQuest> get copyWith =>
      throw _privateConstructorUsedError;
}
