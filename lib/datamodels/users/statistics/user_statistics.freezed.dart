// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserStatistics _$UserStatisticsFromJson(Map<String, dynamic> json) {
  return _UserStatistics.fromJson(json);
}

/// @nodoc
mixin _$UserStatistics {
  num get afkCreditsBalance => throw _privateConstructorUsedError; // in credits
  num get afkCreditsSpent => throw _privateConstructorUsedError; // in credits
  num get totalScreenTime => throw _privateConstructorUsedError; // in minutes
  num get availableSponsoring =>
      throw _privateConstructorUsedError; // in cents!
  num get lifetimeEarnings => throw _privateConstructorUsedError; // in credits
  int get numberQuestsCompleted => throw _privateConstructorUsedError;
  int get numberGiftCardsPurchased => throw _privateConstructorUsedError;
  num get numberScreenTimeHoursPurchased => throw _privateConstructorUsedError;
  List<ConciseFinishedQuestInfo> get completedQuests =>
      throw _privateConstructorUsedError;
  List<String> get completedQuestIds =>
      throw _privateConstructorUsedError; // to safe completed quests
  String get uid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserStatisticsCopyWith<UserStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatisticsCopyWith<$Res> {
  factory $UserStatisticsCopyWith(
          UserStatistics value, $Res Function(UserStatistics) then) =
      _$UserStatisticsCopyWithImpl<$Res>;
  $Res call(
      {num afkCreditsBalance,
      num afkCreditsSpent,
      num totalScreenTime,
      num availableSponsoring,
      num lifetimeEarnings,
      int numberQuestsCompleted,
      int numberGiftCardsPurchased,
      num numberScreenTimeHoursPurchased,
      List<ConciseFinishedQuestInfo> completedQuests,
      List<String> completedQuestIds,
      String uid});
}

/// @nodoc
class _$UserStatisticsCopyWithImpl<$Res>
    implements $UserStatisticsCopyWith<$Res> {
  _$UserStatisticsCopyWithImpl(this._value, this._then);

  final UserStatistics _value;
  // ignore: unused_field
  final $Res Function(UserStatistics) _then;

  @override
  $Res call({
    Object? afkCreditsBalance = freezed,
    Object? afkCreditsSpent = freezed,
    Object? totalScreenTime = freezed,
    Object? availableSponsoring = freezed,
    Object? lifetimeEarnings = freezed,
    Object? numberQuestsCompleted = freezed,
    Object? numberGiftCardsPurchased = freezed,
    Object? numberScreenTimeHoursPurchased = freezed,
    Object? completedQuests = freezed,
    Object? completedQuestIds = freezed,
    Object? uid = freezed,
  }) {
    return _then(_value.copyWith(
      afkCreditsBalance: afkCreditsBalance == freezed
          ? _value.afkCreditsBalance
          : afkCreditsBalance // ignore: cast_nullable_to_non_nullable
              as num,
      afkCreditsSpent: afkCreditsSpent == freezed
          ? _value.afkCreditsSpent
          : afkCreditsSpent // ignore: cast_nullable_to_non_nullable
              as num,
      totalScreenTime: totalScreenTime == freezed
          ? _value.totalScreenTime
          : totalScreenTime // ignore: cast_nullable_to_non_nullable
              as num,
      availableSponsoring: availableSponsoring == freezed
          ? _value.availableSponsoring
          : availableSponsoring // ignore: cast_nullable_to_non_nullable
              as num,
      lifetimeEarnings: lifetimeEarnings == freezed
          ? _value.lifetimeEarnings
          : lifetimeEarnings // ignore: cast_nullable_to_non_nullable
              as num,
      numberQuestsCompleted: numberQuestsCompleted == freezed
          ? _value.numberQuestsCompleted
          : numberQuestsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      numberGiftCardsPurchased: numberGiftCardsPurchased == freezed
          ? _value.numberGiftCardsPurchased
          : numberGiftCardsPurchased // ignore: cast_nullable_to_non_nullable
              as int,
      numberScreenTimeHoursPurchased: numberScreenTimeHoursPurchased == freezed
          ? _value.numberScreenTimeHoursPurchased
          : numberScreenTimeHoursPurchased // ignore: cast_nullable_to_non_nullable
              as num,
      completedQuests: completedQuests == freezed
          ? _value.completedQuests
          : completedQuests // ignore: cast_nullable_to_non_nullable
              as List<ConciseFinishedQuestInfo>,
      completedQuestIds: completedQuestIds == freezed
          ? _value.completedQuestIds
          : completedQuestIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_UserStatisticsCopyWith<$Res>
    implements $UserStatisticsCopyWith<$Res> {
  factory _$$_UserStatisticsCopyWith(
          _$_UserStatistics value, $Res Function(_$_UserStatistics) then) =
      __$$_UserStatisticsCopyWithImpl<$Res>;
  @override
  $Res call(
      {num afkCreditsBalance,
      num afkCreditsSpent,
      num totalScreenTime,
      num availableSponsoring,
      num lifetimeEarnings,
      int numberQuestsCompleted,
      int numberGiftCardsPurchased,
      num numberScreenTimeHoursPurchased,
      List<ConciseFinishedQuestInfo> completedQuests,
      List<String> completedQuestIds,
      String uid});
}

/// @nodoc
class __$$_UserStatisticsCopyWithImpl<$Res>
    extends _$UserStatisticsCopyWithImpl<$Res>
    implements _$$_UserStatisticsCopyWith<$Res> {
  __$$_UserStatisticsCopyWithImpl(
      _$_UserStatistics _value, $Res Function(_$_UserStatistics) _then)
      : super(_value, (v) => _then(v as _$_UserStatistics));

  @override
  _$_UserStatistics get _value => super._value as _$_UserStatistics;

  @override
  $Res call({
    Object? afkCreditsBalance = freezed,
    Object? afkCreditsSpent = freezed,
    Object? totalScreenTime = freezed,
    Object? availableSponsoring = freezed,
    Object? lifetimeEarnings = freezed,
    Object? numberQuestsCompleted = freezed,
    Object? numberGiftCardsPurchased = freezed,
    Object? numberScreenTimeHoursPurchased = freezed,
    Object? completedQuests = freezed,
    Object? completedQuestIds = freezed,
    Object? uid = freezed,
  }) {
    return _then(_$_UserStatistics(
      afkCreditsBalance: afkCreditsBalance == freezed
          ? _value.afkCreditsBalance
          : afkCreditsBalance // ignore: cast_nullable_to_non_nullable
              as num,
      afkCreditsSpent: afkCreditsSpent == freezed
          ? _value.afkCreditsSpent
          : afkCreditsSpent // ignore: cast_nullable_to_non_nullable
              as num,
      totalScreenTime: totalScreenTime == freezed
          ? _value.totalScreenTime
          : totalScreenTime // ignore: cast_nullable_to_non_nullable
              as num,
      availableSponsoring: availableSponsoring == freezed
          ? _value.availableSponsoring
          : availableSponsoring // ignore: cast_nullable_to_non_nullable
              as num,
      lifetimeEarnings: lifetimeEarnings == freezed
          ? _value.lifetimeEarnings
          : lifetimeEarnings // ignore: cast_nullable_to_non_nullable
              as num,
      numberQuestsCompleted: numberQuestsCompleted == freezed
          ? _value.numberQuestsCompleted
          : numberQuestsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      numberGiftCardsPurchased: numberGiftCardsPurchased == freezed
          ? _value.numberGiftCardsPurchased
          : numberGiftCardsPurchased // ignore: cast_nullable_to_non_nullable
              as int,
      numberScreenTimeHoursPurchased: numberScreenTimeHoursPurchased == freezed
          ? _value.numberScreenTimeHoursPurchased
          : numberScreenTimeHoursPurchased // ignore: cast_nullable_to_non_nullable
              as num,
      completedQuests: completedQuests == freezed
          ? _value._completedQuests
          : completedQuests // ignore: cast_nullable_to_non_nullable
              as List<ConciseFinishedQuestInfo>,
      completedQuestIds: completedQuestIds == freezed
          ? _value._completedQuestIds
          : completedQuestIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_UserStatistics implements _UserStatistics {
  _$_UserStatistics(
      {required this.afkCreditsBalance,
      required this.afkCreditsSpent,
      required this.totalScreenTime,
      required this.availableSponsoring,
      required this.lifetimeEarnings,
      required this.numberQuestsCompleted,
      required this.numberGiftCardsPurchased,
      required this.numberScreenTimeHoursPurchased,
      required final List<ConciseFinishedQuestInfo> completedQuests,
      required final List<String> completedQuestIds,
      required this.uid})
      : _completedQuests = completedQuests,
        _completedQuestIds = completedQuestIds;

  factory _$_UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$$_UserStatisticsFromJson(json);

  @override
  final num afkCreditsBalance;
// in credits
  @override
  final num afkCreditsSpent;
// in credits
  @override
  final num totalScreenTime;
// in minutes
  @override
  final num availableSponsoring;
// in cents!
  @override
  final num lifetimeEarnings;
// in credits
  @override
  final int numberQuestsCompleted;
  @override
  final int numberGiftCardsPurchased;
  @override
  final num numberScreenTimeHoursPurchased;
  final List<ConciseFinishedQuestInfo> _completedQuests;
  @override
  List<ConciseFinishedQuestInfo> get completedQuests {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedQuests);
  }

  final List<String> _completedQuestIds;
  @override
  List<String> get completedQuestIds {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedQuestIds);
  }

// to safe completed quests
  @override
  final String uid;

  @override
  String toString() {
    return 'UserStatistics(afkCreditsBalance: $afkCreditsBalance, afkCreditsSpent: $afkCreditsSpent, totalScreenTime: $totalScreenTime, availableSponsoring: $availableSponsoring, lifetimeEarnings: $lifetimeEarnings, numberQuestsCompleted: $numberQuestsCompleted, numberGiftCardsPurchased: $numberGiftCardsPurchased, numberScreenTimeHoursPurchased: $numberScreenTimeHoursPurchased, completedQuests: $completedQuests, completedQuestIds: $completedQuestIds, uid: $uid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserStatistics &&
            const DeepCollectionEquality()
                .equals(other.afkCreditsBalance, afkCreditsBalance) &&
            const DeepCollectionEquality()
                .equals(other.afkCreditsSpent, afkCreditsSpent) &&
            const DeepCollectionEquality()
                .equals(other.totalScreenTime, totalScreenTime) &&
            const DeepCollectionEquality()
                .equals(other.availableSponsoring, availableSponsoring) &&
            const DeepCollectionEquality()
                .equals(other.lifetimeEarnings, lifetimeEarnings) &&
            const DeepCollectionEquality()
                .equals(other.numberQuestsCompleted, numberQuestsCompleted) &&
            const DeepCollectionEquality().equals(
                other.numberGiftCardsPurchased, numberGiftCardsPurchased) &&
            const DeepCollectionEquality().equals(
                other.numberScreenTimeHoursPurchased,
                numberScreenTimeHoursPurchased) &&
            const DeepCollectionEquality()
                .equals(other._completedQuests, _completedQuests) &&
            const DeepCollectionEquality()
                .equals(other._completedQuestIds, _completedQuestIds) &&
            const DeepCollectionEquality().equals(other.uid, uid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(afkCreditsBalance),
      const DeepCollectionEquality().hash(afkCreditsSpent),
      const DeepCollectionEquality().hash(totalScreenTime),
      const DeepCollectionEquality().hash(availableSponsoring),
      const DeepCollectionEquality().hash(lifetimeEarnings),
      const DeepCollectionEquality().hash(numberQuestsCompleted),
      const DeepCollectionEquality().hash(numberGiftCardsPurchased),
      const DeepCollectionEquality().hash(numberScreenTimeHoursPurchased),
      const DeepCollectionEquality().hash(_completedQuests),
      const DeepCollectionEquality().hash(_completedQuestIds),
      const DeepCollectionEquality().hash(uid));

  @JsonKey(ignore: true)
  @override
  _$$_UserStatisticsCopyWith<_$_UserStatistics> get copyWith =>
      __$$_UserStatisticsCopyWithImpl<_$_UserStatistics>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserStatisticsToJson(
      this,
    );
  }
}

abstract class _UserStatistics implements UserStatistics {
  factory _UserStatistics(
      {required final num afkCreditsBalance,
      required final num afkCreditsSpent,
      required final num totalScreenTime,
      required final num availableSponsoring,
      required final num lifetimeEarnings,
      required final int numberQuestsCompleted,
      required final int numberGiftCardsPurchased,
      required final num numberScreenTimeHoursPurchased,
      required final List<ConciseFinishedQuestInfo> completedQuests,
      required final List<String> completedQuestIds,
      required final String uid}) = _$_UserStatistics;

  factory _UserStatistics.fromJson(Map<String, dynamic> json) =
      _$_UserStatistics.fromJson;

  @override
  num get afkCreditsBalance;
  @override // in credits
  num get afkCreditsSpent;
  @override // in credits
  num get totalScreenTime;
  @override // in minutes
  num get availableSponsoring;
  @override // in cents!
  num get lifetimeEarnings;
  @override // in credits
  int get numberQuestsCompleted;
  @override
  int get numberGiftCardsPurchased;
  @override
  num get numberScreenTimeHoursPurchased;
  @override
  List<ConciseFinishedQuestInfo> get completedQuests;
  @override
  List<String> get completedQuestIds;
  @override // to safe completed quests
  String get uid;
  @override
  @JsonKey(ignore: true)
  _$$_UserStatisticsCopyWith<_$_UserStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}
