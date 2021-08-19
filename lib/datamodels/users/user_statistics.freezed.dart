// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

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
      {required num afkCredits,
      required num availableSponsoring,
      required List<ConciseQuestInfo> completedQuests}) {
    return _UserStatistics(
      afkCredits: afkCredits,
      availableSponsoring: availableSponsoring,
      completedQuests: completedQuests,
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
  num get afkCredits => throw _privateConstructorUsedError;
  num get availableSponsoring => throw _privateConstructorUsedError;
  List<ConciseQuestInfo> get completedQuests =>
      throw _privateConstructorUsedError;

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
      {num afkCredits,
      num availableSponsoring,
      List<ConciseQuestInfo> completedQuests});
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
    Object? afkCredits = freezed,
    Object? availableSponsoring = freezed,
    Object? completedQuests = freezed,
  }) {
    return _then(_value.copyWith(
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as num,
      availableSponsoring: availableSponsoring == freezed
          ? _value.availableSponsoring
          : availableSponsoring // ignore: cast_nullable_to_non_nullable
              as num,
      completedQuests: completedQuests == freezed
          ? _value.completedQuests
          : completedQuests // ignore: cast_nullable_to_non_nullable
              as List<ConciseQuestInfo>,
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
      {num afkCredits,
      num availableSponsoring,
      List<ConciseQuestInfo> completedQuests});
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
    Object? afkCredits = freezed,
    Object? availableSponsoring = freezed,
    Object? completedQuests = freezed,
  }) {
    return _then(_UserStatistics(
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as num,
      availableSponsoring: availableSponsoring == freezed
          ? _value.availableSponsoring
          : availableSponsoring // ignore: cast_nullable_to_non_nullable
              as num,
      completedQuests: completedQuests == freezed
          ? _value.completedQuests
          : completedQuests // ignore: cast_nullable_to_non_nullable
              as List<ConciseQuestInfo>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_UserStatistics implements _UserStatistics {
  _$_UserStatistics(
      {required this.afkCredits,
      required this.availableSponsoring,
      required this.completedQuests});

  factory _$_UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$_$_UserStatisticsFromJson(json);

  @override
  final num afkCredits;
  @override
  final num availableSponsoring;
  @override
  final List<ConciseQuestInfo> completedQuests;

  @override
  String toString() {
    return 'UserStatistics(afkCredits: $afkCredits, availableSponsoring: $availableSponsoring, completedQuests: $completedQuests)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserStatistics &&
            (identical(other.afkCredits, afkCredits) ||
                const DeepCollectionEquality()
                    .equals(other.afkCredits, afkCredits)) &&
            (identical(other.availableSponsoring, availableSponsoring) ||
                const DeepCollectionEquality()
                    .equals(other.availableSponsoring, availableSponsoring)) &&
            (identical(other.completedQuests, completedQuests) ||
                const DeepCollectionEquality()
                    .equals(other.completedQuests, completedQuests)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(afkCredits) ^
      const DeepCollectionEquality().hash(availableSponsoring) ^
      const DeepCollectionEquality().hash(completedQuests);

  @JsonKey(ignore: true)
  @override
  _$UserStatisticsCopyWith<_UserStatistics> get copyWith =>
      __$UserStatisticsCopyWithImpl<_UserStatistics>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserStatisticsToJson(this);
  }
}

abstract class _UserStatistics implements UserStatistics {
  factory _UserStatistics(
      {required num afkCredits,
      required num availableSponsoring,
      required List<ConciseQuestInfo> completedQuests}) = _$_UserStatistics;

  factory _UserStatistics.fromJson(Map<String, dynamic> json) =
      _$_UserStatistics.fromJson;

  @override
  num get afkCredits => throw _privateConstructorUsedError;
  @override
  num get availableSponsoring => throw _privateConstructorUsedError;
  @override
  List<ConciseQuestInfo> get completedQuests =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserStatisticsCopyWith<_UserStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}
