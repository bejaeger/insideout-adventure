// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'screen_time_purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ScreenTimePurchase _$ScreenTimePurchaseFromJson(Map<String, dynamic> json) {
  return _ScreenTimePurchase.fromJson(json);
}

/// @nodoc
class _$ScreenTimePurchaseTearOff {
  const _$ScreenTimePurchaseTearOff();

  _ScreenTimePurchase call(
      {required String purchaseId,
      required String uid,
      dynamic purchasedAt = "",
      dynamic activatedOn = "",
      required num hours,
      required ScreenTimeVoucherStatus status,
      required double amount}) {
    return _ScreenTimePurchase(
      purchaseId: purchaseId,
      uid: uid,
      purchasedAt: purchasedAt,
      activatedOn: activatedOn,
      hours: hours,
      status: status,
      amount: amount,
    );
  }

  ScreenTimePurchase fromJson(Map<String, Object> json) {
    return ScreenTimePurchase.fromJson(json);
  }
}

/// @nodoc
const $ScreenTimePurchase = _$ScreenTimePurchaseTearOff();

/// @nodoc
mixin _$ScreenTimePurchase {
  String get purchaseId => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  dynamic get purchasedAt => throw _privateConstructorUsedError;
  dynamic get activatedOn => throw _privateConstructorUsedError;
  num get hours => throw _privateConstructorUsedError;
  ScreenTimeVoucherStatus get status => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScreenTimePurchaseCopyWith<ScreenTimePurchase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenTimePurchaseCopyWith<$Res> {
  factory $ScreenTimePurchaseCopyWith(
          ScreenTimePurchase value, $Res Function(ScreenTimePurchase) then) =
      _$ScreenTimePurchaseCopyWithImpl<$Res>;
  $Res call(
      {String purchaseId,
      String uid,
      dynamic purchasedAt,
      dynamic activatedOn,
      num hours,
      ScreenTimeVoucherStatus status,
      double amount});
}

/// @nodoc
class _$ScreenTimePurchaseCopyWithImpl<$Res>
    implements $ScreenTimePurchaseCopyWith<$Res> {
  _$ScreenTimePurchaseCopyWithImpl(this._value, this._then);

  final ScreenTimePurchase _value;
  // ignore: unused_field
  final $Res Function(ScreenTimePurchase) _then;

  @override
  $Res call({
    Object? purchaseId = freezed,
    Object? uid = freezed,
    Object? purchasedAt = freezed,
    Object? activatedOn = freezed,
    Object? hours = freezed,
    Object? status = freezed,
    Object? amount = freezed,
  }) {
    return _then(_value.copyWith(
      purchaseId: purchaseId == freezed
          ? _value.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      purchasedAt: purchasedAt == freezed
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      activatedOn: activatedOn == freezed
          ? _value.activatedOn
          : activatedOn // ignore: cast_nullable_to_non_nullable
              as dynamic,
      hours: hours == freezed
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as num,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScreenTimeVoucherStatus,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$ScreenTimePurchaseCopyWith<$Res>
    implements $ScreenTimePurchaseCopyWith<$Res> {
  factory _$ScreenTimePurchaseCopyWith(
          _ScreenTimePurchase value, $Res Function(_ScreenTimePurchase) then) =
      __$ScreenTimePurchaseCopyWithImpl<$Res>;
  @override
  $Res call(
      {String purchaseId,
      String uid,
      dynamic purchasedAt,
      dynamic activatedOn,
      num hours,
      ScreenTimeVoucherStatus status,
      double amount});
}

/// @nodoc
class __$ScreenTimePurchaseCopyWithImpl<$Res>
    extends _$ScreenTimePurchaseCopyWithImpl<$Res>
    implements _$ScreenTimePurchaseCopyWith<$Res> {
  __$ScreenTimePurchaseCopyWithImpl(
      _ScreenTimePurchase _value, $Res Function(_ScreenTimePurchase) _then)
      : super(_value, (v) => _then(v as _ScreenTimePurchase));

  @override
  _ScreenTimePurchase get _value => super._value as _ScreenTimePurchase;

  @override
  $Res call({
    Object? purchaseId = freezed,
    Object? uid = freezed,
    Object? purchasedAt = freezed,
    Object? activatedOn = freezed,
    Object? hours = freezed,
    Object? status = freezed,
    Object? amount = freezed,
  }) {
    return _then(_ScreenTimePurchase(
      purchaseId: purchaseId == freezed
          ? _value.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      purchasedAt: purchasedAt == freezed
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      activatedOn: activatedOn == freezed
          ? _value.activatedOn
          : activatedOn // ignore: cast_nullable_to_non_nullable
              as dynamic,
      hours: hours == freezed
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as num,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScreenTimeVoucherStatus,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ScreenTimePurchase implements _ScreenTimePurchase {
  _$_ScreenTimePurchase(
      {required this.purchaseId,
      required this.uid,
      this.purchasedAt = "",
      this.activatedOn = "",
      required this.hours,
      required this.status,
      required this.amount});

  factory _$_ScreenTimePurchase.fromJson(Map<String, dynamic> json) =>
      _$$_ScreenTimePurchaseFromJson(json);

  @override
  final String purchaseId;
  @override
  final String uid;
  @JsonKey(defaultValue: "")
  @override
  final dynamic purchasedAt;
  @JsonKey(defaultValue: "")
  @override
  final dynamic activatedOn;
  @override
  final num hours;
  @override
  final ScreenTimeVoucherStatus status;
  @override
  final double amount;

  @override
  String toString() {
    return 'ScreenTimePurchase(purchaseId: $purchaseId, uid: $uid, purchasedAt: $purchasedAt, activatedOn: $activatedOn, hours: $hours, status: $status, amount: $amount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ScreenTimePurchase &&
            (identical(other.purchaseId, purchaseId) ||
                const DeepCollectionEquality()
                    .equals(other.purchaseId, purchaseId)) &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.purchasedAt, purchasedAt) ||
                const DeepCollectionEquality()
                    .equals(other.purchasedAt, purchasedAt)) &&
            (identical(other.activatedOn, activatedOn) ||
                const DeepCollectionEquality()
                    .equals(other.activatedOn, activatedOn)) &&
            (identical(other.hours, hours) ||
                const DeepCollectionEquality().equals(other.hours, hours)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(purchaseId) ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(purchasedAt) ^
      const DeepCollectionEquality().hash(activatedOn) ^
      const DeepCollectionEquality().hash(hours) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(amount);

  @JsonKey(ignore: true)
  @override
  _$ScreenTimePurchaseCopyWith<_ScreenTimePurchase> get copyWith =>
      __$ScreenTimePurchaseCopyWithImpl<_ScreenTimePurchase>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ScreenTimePurchaseToJson(this);
  }
}

abstract class _ScreenTimePurchase implements ScreenTimePurchase {
  factory _ScreenTimePurchase(
      {required String purchaseId,
      required String uid,
      dynamic purchasedAt,
      dynamic activatedOn,
      required num hours,
      required ScreenTimeVoucherStatus status,
      required double amount}) = _$_ScreenTimePurchase;

  factory _ScreenTimePurchase.fromJson(Map<String, dynamic> json) =
      _$_ScreenTimePurchase.fromJson;

  @override
  String get purchaseId => throw _privateConstructorUsedError;
  @override
  String get uid => throw _privateConstructorUsedError;
  @override
  dynamic get purchasedAt => throw _privateConstructorUsedError;
  @override
  dynamic get activatedOn => throw _privateConstructorUsedError;
  @override
  num get hours => throw _privateConstructorUsedError;
  @override
  ScreenTimeVoucherStatus get status => throw _privateConstructorUsedError;
  @override
  double get amount => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ScreenTimePurchaseCopyWith<_ScreenTimePurchase> get copyWith =>
      throw _privateConstructorUsedError;
}
