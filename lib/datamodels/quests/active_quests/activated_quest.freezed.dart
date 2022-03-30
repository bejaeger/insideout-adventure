// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      num? afkCreditsEarned,
      required int timeElapsed,
      dynamic createdAt = "",
      double? lastCheckLat,
      double? lastCheckLon,
      double? currentDistanceInMeters,
      double? lastDistanceInMeters}) {
    return _ActivatedQuest(
      id: id,
      quest: quest,
      markersCollected: markersCollected,
      status: status,
      uids: uids,
      afkCreditsEarned: afkCreditsEarned,
      timeElapsed: timeElapsed,
      createdAt: createdAt,
      lastCheckLat: lastCheckLat,
      lastCheckLon: lastCheckLon,
      currentDistanceInMeters: currentDistanceInMeters,
      lastDistanceInMeters: lastDistanceInMeters,
    );
  }

  ActivatedQuest fromJson(Map<String, Object?> json) {
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
  num? get afkCreditsEarned => throw _privateConstructorUsedError;
  int get timeElapsed => throw _privateConstructorUsedError; // in seconds!
  dynamic get createdAt => throw _privateConstructorUsedError;
  double? get lastCheckLat =>
      throw _privateConstructorUsedError; // For VibrationSearch quest
  double? get lastCheckLon =>
      throw _privateConstructorUsedError; // For VibrationSearch quest
  double? get currentDistanceInMeters =>
      throw _privateConstructorUsedError; // For VibrationSearch quest
  double? get lastDistanceInMeters => throw _privateConstructorUsedError;

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
      num? afkCreditsEarned,
      int timeElapsed,
      dynamic createdAt,
      double? lastCheckLat,
      double? lastCheckLon,
      double? currentDistanceInMeters,
      double? lastDistanceInMeters});

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
    Object? lastCheckLat = freezed,
    Object? lastCheckLon = freezed,
    Object? currentDistanceInMeters = freezed,
    Object? lastDistanceInMeters = freezed,
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
              as num?,
      timeElapsed: timeElapsed == freezed
          ? _value.timeElapsed
          : timeElapsed // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      lastCheckLat: lastCheckLat == freezed
          ? _value.lastCheckLat
          : lastCheckLat // ignore: cast_nullable_to_non_nullable
              as double?,
      lastCheckLon: lastCheckLon == freezed
          ? _value.lastCheckLon
          : lastCheckLon // ignore: cast_nullable_to_non_nullable
              as double?,
      currentDistanceInMeters: currentDistanceInMeters == freezed
          ? _value.currentDistanceInMeters
          : currentDistanceInMeters // ignore: cast_nullable_to_non_nullable
              as double?,
      lastDistanceInMeters: lastDistanceInMeters == freezed
          ? _value.lastDistanceInMeters
          : lastDistanceInMeters // ignore: cast_nullable_to_non_nullable
              as double?,
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
      num? afkCreditsEarned,
      int timeElapsed,
      dynamic createdAt,
      double? lastCheckLat,
      double? lastCheckLon,
      double? currentDistanceInMeters,
      double? lastDistanceInMeters});

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
    Object? lastCheckLat = freezed,
    Object? lastCheckLon = freezed,
    Object? currentDistanceInMeters = freezed,
    Object? lastDistanceInMeters = freezed,
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
              as num?,
      timeElapsed: timeElapsed == freezed
          ? _value.timeElapsed
          : timeElapsed // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      lastCheckLat: lastCheckLat == freezed
          ? _value.lastCheckLat
          : lastCheckLat // ignore: cast_nullable_to_non_nullable
              as double?,
      lastCheckLon: lastCheckLon == freezed
          ? _value.lastCheckLon
          : lastCheckLon // ignore: cast_nullable_to_non_nullable
              as double?,
      currentDistanceInMeters: currentDistanceInMeters == freezed
          ? _value.currentDistanceInMeters
          : currentDistanceInMeters // ignore: cast_nullable_to_non_nullable
              as double?,
      lastDistanceInMeters: lastDistanceInMeters == freezed
          ? _value.lastDistanceInMeters
          : lastDistanceInMeters // ignore: cast_nullable_to_non_nullable
              as double?,
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
      this.createdAt = "",
      this.lastCheckLat,
      this.lastCheckLon,
      this.currentDistanceInMeters,
      this.lastDistanceInMeters});

  factory _$_ActivatedQuest.fromJson(Map<String, dynamic> json) =>
      _$$_ActivatedQuestFromJson(json);

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
  final num? afkCreditsEarned;
  @override
  final int timeElapsed;
  @JsonKey()
  @override // in seconds!
  final dynamic createdAt;
  @override
  final double? lastCheckLat;
  @override // For VibrationSearch quest
  final double? lastCheckLon;
  @override // For VibrationSearch quest
  final double? currentDistanceInMeters;
  @override // For VibrationSearch quest
  final double? lastDistanceInMeters;

  @override
  String toString() {
    return 'ActivatedQuest(id: $id, quest: $quest, markersCollected: $markersCollected, status: $status, uids: $uids, afkCreditsEarned: $afkCreditsEarned, timeElapsed: $timeElapsed, createdAt: $createdAt, lastCheckLat: $lastCheckLat, lastCheckLon: $lastCheckLon, currentDistanceInMeters: $currentDistanceInMeters, lastDistanceInMeters: $lastDistanceInMeters)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivatedQuest &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.quest, quest) &&
            const DeepCollectionEquality()
                .equals(other.markersCollected, markersCollected) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.uids, uids) &&
            const DeepCollectionEquality()
                .equals(other.afkCreditsEarned, afkCreditsEarned) &&
            const DeepCollectionEquality()
                .equals(other.timeElapsed, timeElapsed) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.lastCheckLat, lastCheckLat) &&
            const DeepCollectionEquality()
                .equals(other.lastCheckLon, lastCheckLon) &&
            const DeepCollectionEquality().equals(
                other.currentDistanceInMeters, currentDistanceInMeters) &&
            const DeepCollectionEquality()
                .equals(other.lastDistanceInMeters, lastDistanceInMeters));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(quest),
      const DeepCollectionEquality().hash(markersCollected),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(uids),
      const DeepCollectionEquality().hash(afkCreditsEarned),
      const DeepCollectionEquality().hash(timeElapsed),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(lastCheckLat),
      const DeepCollectionEquality().hash(lastCheckLon),
      const DeepCollectionEquality().hash(currentDistanceInMeters),
      const DeepCollectionEquality().hash(lastDistanceInMeters));

  @JsonKey(ignore: true)
  @override
  _$ActivatedQuestCopyWith<_ActivatedQuest> get copyWith =>
      __$ActivatedQuestCopyWithImpl<_ActivatedQuest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivatedQuestToJson(this);
  }
}

abstract class _ActivatedQuest implements ActivatedQuest {
  factory _ActivatedQuest(
      {String? id,
      required Quest quest,
      required List<bool> markersCollected,
      required QuestStatus status,
      List<String>? uids,
      num? afkCreditsEarned,
      required int timeElapsed,
      dynamic createdAt,
      double? lastCheckLat,
      double? lastCheckLon,
      double? currentDistanceInMeters,
      double? lastDistanceInMeters}) = _$_ActivatedQuest;

  factory _ActivatedQuest.fromJson(Map<String, dynamic> json) =
      _$_ActivatedQuest.fromJson;

  @override
  String? get id;
  @override
  Quest get quest;
  @override
  List<bool> get markersCollected;
  @override
  QuestStatus get status;
  @override
  List<String>? get uids;
  @override
  num? get afkCreditsEarned;
  @override
  int get timeElapsed;
  @override // in seconds!
  dynamic get createdAt;
  @override
  double? get lastCheckLat;
  @override // For VibrationSearch quest
  double? get lastCheckLon;
  @override // For VibrationSearch quest
  double? get currentDistanceInMeters;
  @override // For VibrationSearch quest
  double? get lastDistanceInMeters;
  @override
  @JsonKey(ignore: true)
  _$ActivatedQuestCopyWith<_ActivatedQuest> get copyWith =>
      throw _privateConstructorUsedError;
}
