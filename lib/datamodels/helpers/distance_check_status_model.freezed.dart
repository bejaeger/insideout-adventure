// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'distance_check_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DistanceCheckStatusModelTearOff {
  const _$DistanceCheckStatusModelTearOff();

  _DistanceCheckStatusModel call(
      {required Future<DistanceCheckStatus> futureStatus,
      required double distanceInMeter}) {
    return _DistanceCheckStatusModel(
      futureStatus: futureStatus,
      distanceInMeter: distanceInMeter,
    );
  }
}

/// @nodoc
const $DistanceCheckStatusModel = _$DistanceCheckStatusModelTearOff();

/// @nodoc
mixin _$DistanceCheckStatusModel {
  Future<DistanceCheckStatus> get futureStatus =>
      throw _privateConstructorUsedError;
  double get distanceInMeter => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DistanceCheckStatusModelCopyWith<DistanceCheckStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistanceCheckStatusModelCopyWith<$Res> {
  factory $DistanceCheckStatusModelCopyWith(DistanceCheckStatusModel value,
          $Res Function(DistanceCheckStatusModel) then) =
      _$DistanceCheckStatusModelCopyWithImpl<$Res>;
  $Res call({Future<DistanceCheckStatus> futureStatus, double distanceInMeter});
}

/// @nodoc
class _$DistanceCheckStatusModelCopyWithImpl<$Res>
    implements $DistanceCheckStatusModelCopyWith<$Res> {
  _$DistanceCheckStatusModelCopyWithImpl(this._value, this._then);

  final DistanceCheckStatusModel _value;
  // ignore: unused_field
  final $Res Function(DistanceCheckStatusModel) _then;

  @override
  $Res call({
    Object? futureStatus = freezed,
    Object? distanceInMeter = freezed,
  }) {
    return _then(_value.copyWith(
      futureStatus: futureStatus == freezed
          ? _value.futureStatus
          : futureStatus // ignore: cast_nullable_to_non_nullable
              as Future<DistanceCheckStatus>,
      distanceInMeter: distanceInMeter == freezed
          ? _value.distanceInMeter
          : distanceInMeter // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$DistanceCheckStatusModelCopyWith<$Res>
    implements $DistanceCheckStatusModelCopyWith<$Res> {
  factory _$DistanceCheckStatusModelCopyWith(_DistanceCheckStatusModel value,
          $Res Function(_DistanceCheckStatusModel) then) =
      __$DistanceCheckStatusModelCopyWithImpl<$Res>;
  @override
  $Res call({Future<DistanceCheckStatus> futureStatus, double distanceInMeter});
}

/// @nodoc
class __$DistanceCheckStatusModelCopyWithImpl<$Res>
    extends _$DistanceCheckStatusModelCopyWithImpl<$Res>
    implements _$DistanceCheckStatusModelCopyWith<$Res> {
  __$DistanceCheckStatusModelCopyWithImpl(_DistanceCheckStatusModel _value,
      $Res Function(_DistanceCheckStatusModel) _then)
      : super(_value, (v) => _then(v as _DistanceCheckStatusModel));

  @override
  _DistanceCheckStatusModel get _value =>
      super._value as _DistanceCheckStatusModel;

  @override
  $Res call({
    Object? futureStatus = freezed,
    Object? distanceInMeter = freezed,
  }) {
    return _then(_DistanceCheckStatusModel(
      futureStatus: futureStatus == freezed
          ? _value.futureStatus
          : futureStatus // ignore: cast_nullable_to_non_nullable
              as Future<DistanceCheckStatus>,
      distanceInMeter: distanceInMeter == freezed
          ? _value.distanceInMeter
          : distanceInMeter // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_DistanceCheckStatusModel implements _DistanceCheckStatusModel {
  _$_DistanceCheckStatusModel(
      {required this.futureStatus, required this.distanceInMeter});

  @override
  final Future<DistanceCheckStatus> futureStatus;
  @override
  final double distanceInMeter;

  @override
  String toString() {
    return 'DistanceCheckStatusModel(futureStatus: $futureStatus, distanceInMeter: $distanceInMeter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DistanceCheckStatusModel &&
            (identical(other.futureStatus, futureStatus) ||
                const DeepCollectionEquality()
                    .equals(other.futureStatus, futureStatus)) &&
            (identical(other.distanceInMeter, distanceInMeter) ||
                const DeepCollectionEquality()
                    .equals(other.distanceInMeter, distanceInMeter)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(futureStatus) ^
      const DeepCollectionEquality().hash(distanceInMeter);

  @JsonKey(ignore: true)
  @override
  _$DistanceCheckStatusModelCopyWith<_DistanceCheckStatusModel> get copyWith =>
      __$DistanceCheckStatusModelCopyWithImpl<_DistanceCheckStatusModel>(
          this, _$identity);
}

abstract class _DistanceCheckStatusModel implements DistanceCheckStatusModel {
  factory _DistanceCheckStatusModel(
      {required Future<DistanceCheckStatus> futureStatus,
      required double distanceInMeter}) = _$_DistanceCheckStatusModel;

  @override
  Future<DistanceCheckStatus> get futureStatus =>
      throw _privateConstructorUsedError;
  @override
  double get distanceInMeter => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$DistanceCheckStatusModelCopyWith<_DistanceCheckStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}
