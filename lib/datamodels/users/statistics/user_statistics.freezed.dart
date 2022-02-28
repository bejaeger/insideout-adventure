// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserStatistics _$UserStatisticsFromJson(Map<String, dynamic> json) {
  return _UserStatistics.fromJson(json);
}

/// @nodoc
class _$UserStatisticsTearOff {
  const _$UserStatisticsTearOff();

  _UserStatistics call(
      {required num afkCreditsBalance,
      required num afkCreditsSpent,
      required num availableSponsoring,
      required num lifetimeEarnings,
      required int numberQuestsCompleted,
      required int numberGiftCardsPurchased,
      required num numberScreenTimeHoursPurchased,
      required List<ConciseFinishedQuestInfo> completedQuests,
      required String uid}) {
    return _UserStatistics(
      afkCreditsBalance: afkCreditsBalance,
      afkCreditsSpent: afkCreditsSpent,
      availableSponsoring: availableSponsoring,
      lifetimeEarnings: lifetimeEarnings,
      numberQuestsCompleted: numberQuestsCompleted,
      numberGiftCardsPurchased: numberGiftCardsPurchased,
      numberScreenTimeHoursPurchased: numberScreenTimeHoursPurchased,
      completedQuests: completedQuests,
      uid: uid,
    );
  }

  UserStatistics fromJson(Map<String, Object> json) {
    return UserStatistics.fromJson(json);
  }
}

/// @nodoc
const $UserStatistics = _$UserStatisticsTearOff();

/// @nodoc
mixin _$UserStatistics {
  num get afkCreditsBalance => throw _privateConstructorUsedError; // in credits
  num get afkCreditsSpent => throw _privateConstructorUsedError; // in credits
  num get availableSponsoring =>
      throw _privateConstructorUsedError; // in cents!
  num get lifetimeEarnings => throw _privateConstructorUsedError; // in credits
  int get numberQuestsCompleted => throw _privateConstructorUsedError;
  int get numberGiftCardsPurchased => throw _privateConstructorUsedError;
  num get numberScreenTimeHoursPurchased => throw _privateConstructorUsedError;
  List<ConciseFinishedQuestInfo> get completedQuests =>
      throw _privateConstructorUsedError;
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
      num availableSponsoring,
      num lifetimeEarnings,
      int numberQuestsCompleted,
      int numberGiftCardsPurchased,
      num numberScreenTimeHoursPurchased,
      List<ConciseFinishedQuestInfo> completedQuests,
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
    Object? availableSponsoring = freezed,
    Object? lifetimeEarnings = freezed,
    Object? numberQuestsCompleted = freezed,
    Object? numberGiftCardsPurchased = freezed,
    Object? numberScreenTimeHoursPurchased = freezed,
    Object? completedQuests = freezed,
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
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$UserStatisticsCopyWith<$Res>
    implements $UserStatisticsCopyWith<$Res> {
  factory _$UserStatisticsCopyWith(
          _UserStatistics value, $Res Function(_UserStatistics) then) =
      __$UserStatisticsCopyWithImpl<$Res>;
  @override
  $Res call(
      {num afkCreditsBalance,
      num afkCreditsSpent,
      num availableSponsoring,
      num lifetimeEarnings,
      int numberQuestsCompleted,
      int numberGiftCardsPurchased,
      num numberScreenTimeHoursPurchased,
      List<ConciseFinishedQuestInfo> completedQuests,
      String uid});
}

/// @nodoc
class __$UserStatisticsCopyWithImpl<$Res>
    extends _$UserStatisticsCopyWithImpl<$Res>
    implements _$UserStatisticsCopyWith<$Res> {
  __$UserStatisticsCopyWithImpl(
      _UserStatistics _value, $Res Function(_UserStatistics) _then)
      : super(_value, (v) => _then(v as _UserStatistics));

  @override
  _UserStatistics get _value => super._value as _UserStatistics;

  @override
  $Res call({
    Object? afkCreditsBalance = freezed,
    Object? afkCreditsSpent = freezed,
    Object? availableSponsoring = freezed,
    Object? lifetimeEarnings = freezed,
    Object? numberQuestsCompleted = freezed,
    Object? numberGiftCardsPurchased = freezed,
    Object? numberScreenTimeHoursPurchased = freezed,
    Object? completedQuests = freezed,
    Object? uid = freezed,
  }) {
    return _then(_UserStatistics(
      afkCreditsBalance: afkCreditsBalance == freezed
          ? _value.afkCreditsBalance
          : afkCreditsBalance // ignore: cast_nullable_to_non_nullable
              as num,
      afkCreditsSpent: afkCreditsSpent == freezed
          ? _value.afkCreditsSpent
          : afkCreditsSpent // ignore: cast_nullable_to_non_nullable
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
      required this.availableSponsoring,
      required this.lifetimeEarnings,
      required this.numberQuestsCompleted,
      required this.numberGiftCardsPurchased,
      required this.numberScreenTimeHoursPurchased,
      required this.completedQuests,
      required this.uid});

  factory _$_UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$$_UserStatisticsFromJson(json);

  @override
  final num afkCreditsBalance;
  @override // in credits
  final num afkCreditsSpent;
  @override // in credits
  final num availableSponsoring;
  @override // in cents!
  final num lifetimeEarnings;
  @override // in credits
  final int numberQuestsCompleted;
  @override
  final int numberGiftCardsPurchased;
  @override
  final num numberScreenTimeHoursPurchased;
  @override
  final List<ConciseFinishedQuestInfo> completedQuests;
  @override
  final String uid;

  @override
  String toString() {
    return 'UserStatistics(afkCreditsBalance: $afkCreditsBalance, afkCreditsSpent: $afkCreditsSpent, availableSponsoring: $availableSponsoring, lifetimeEarnings: $lifetimeEarnings, numberQuestsCompleted: $numberQuestsCompleted, numberGiftCardsPurchased: $numberGiftCardsPurchased, numberScreenTimeHoursPurchased: $numberScreenTimeHoursPurchased, completedQuests: $completedQuests, uid: $uid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserStatistics &&
            (identical(other.afkCreditsBalance, afkCreditsBalance) ||
                const DeepCollectionEquality()
                    .equals(other.afkCreditsBalance, afkCreditsBalance)) &&
            (identical(other.afkCreditsSpent, afkCreditsSpent) ||
                const DeepCollectionEquality()
                    .equals(other.afkCreditsSpent, afkCreditsSpent)) &&
            (identical(other.availableSponsoring, availableSponsoring) ||
                const DeepCollectionEquality()
                    .equals(other.availableSponsoring, availableSponsoring)) &&
            (identical(other.lifetimeEarnings, lifetimeEarnings) ||
                const DeepCollectionEquality()
                    .equals(other.lifetimeEarnings, lifetimeEarnings)) &&
            (identical(other.numberQuestsCompleted, numberQuestsCompleted) ||
                const DeepCollectionEquality().equals(
                    other.numberQuestsCompleted, numberQuestsCompleted)) &&
            (identical(
                    other.numberGiftCardsPurchased, numberGiftCardsPurchased) ||
                const DeepCollectionEquality().equals(
                    other.numberGiftCardsPurchased,
                    numberGiftCardsPurchased)) &&
            (identical(other.numberScreenTimeHoursPurchased,
                    numberScreenTimeHoursPurchased) ||
                const DeepCollectionEquality().equals(
                    other.numberScreenTimeHoursPurchased,
                    numberScreenTimeHoursPurchased)) &&
            (identical(other.completedQuests, completedQuests) ||
                const DeepCollectionEquality()
                    .equals(other.completedQuests, completedQuests)) &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(afkCreditsBalance) ^
      const DeepCollectionEquality().hash(afkCreditsSpent) ^
      const DeepCollectionEquality().hash(availableSponsoring) ^
      const DeepCollectionEquality().hash(lifetimeEarnings) ^
      const DeepCollectionEquality().hash(numberQuestsCompleted) ^
      const DeepCollectionEquality().hash(numberGiftCardsPurchased) ^
      const DeepCollectionEquality().hash(numberScreenTimeHoursPurchased) ^
      const DeepCollectionEquality().hash(completedQuests) ^
      const DeepCollectionEquality().hash(uid);

  @JsonKey(ignore: true)
  @override
  _$UserStatisticsCopyWith<_UserStatistics> get copyWith =>
      __$UserStatisticsCopyWithImpl<_UserStatistics>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserStatisticsToJson(this);
  }
}

abstract class _UserStatistics implements UserStatistics {
  factory _UserStatistics(
      {required num afkCreditsBalance,
      required num afkCreditsSpent,
      required num availableSponsoring,
      required num lifetimeEarnings,
      required int numberQuestsCompleted,
      required int numberGiftCardsPurchased,
      required num numberScreenTimeHoursPurchased,
      required List<ConciseFinishedQuestInfo> completedQuests,
      required String uid}) = _$_UserStatistics;

  factory _UserStatistics.fromJson(Map<String, dynamic> json) =
      _$_UserStatistics.fromJson;

  @override
  num get afkCreditsBalance => throw _privateConstructorUsedError;
  @override // in credits
  num get afkCreditsSpent => throw _privateConstructorUsedError;
  @override // in credits
  num get availableSponsoring => throw _privateConstructorUsedError;
  @override // in cents!
  num get lifetimeEarnings => throw _privateConstructorUsedError;
  @override // in credits
  int get numberQuestsCompleted => throw _privateConstructorUsedError;
  @override
  int get numberGiftCardsPurchased => throw _privateConstructorUsedError;
  @override
  num get numberScreenTimeHoursPurchased => throw _privateConstructorUsedError;
  @override
  List<ConciseFinishedQuestInfo> get completedQuests =>
      throw _privateConstructorUsedError;
  @override
  String get uid => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserStatisticsCopyWith<_UserStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}
