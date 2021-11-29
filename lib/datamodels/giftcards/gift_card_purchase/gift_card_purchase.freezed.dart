// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'gift_card_purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GiftCardPurchase _$GiftCardPurchaseFromJson(Map<String, dynamic> json) {
  return _GiftCardPurchase.fromJson(json);
}

/// @nodoc
class _$GiftCardPurchaseTearOff {
  const _$GiftCardPurchaseTearOff();

  _GiftCardPurchase call(
      {required GiftCardCategory giftCardCategory,
      required String uid,
      String? code,
      dynamic purchasedAt = "",
      String transferId = "placeholder",
      PurchasedGiftCardStatus status = PurchasedGiftCardStatus.initialized}) {
    return _GiftCardPurchase(
      giftCardCategory: giftCardCategory,
      uid: uid,
      code: code,
      purchasedAt: purchasedAt,
      transferId: transferId,
      status: status,
    );
  }

  GiftCardPurchase fromJson(Map<String, Object> json) {
    return GiftCardPurchase.fromJson(json);
  }
}

/// @nodoc
const $GiftCardPurchase = _$GiftCardPurchaseTearOff();

/// @nodoc
mixin _$GiftCardPurchase {
  GiftCardCategory get giftCardCategory => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  dynamic get purchasedAt => throw _privateConstructorUsedError;
  String get transferId => throw _privateConstructorUsedError;
  PurchasedGiftCardStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GiftCardPurchaseCopyWith<GiftCardPurchase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftCardPurchaseCopyWith<$Res> {
  factory $GiftCardPurchaseCopyWith(
          GiftCardPurchase value, $Res Function(GiftCardPurchase) then) =
      _$GiftCardPurchaseCopyWithImpl<$Res>;
  $Res call(
      {GiftCardCategory giftCardCategory,
      String uid,
      String? code,
      dynamic purchasedAt,
      String transferId,
      PurchasedGiftCardStatus status});

  $GiftCardCategoryCopyWith<$Res> get giftCardCategory;
}

/// @nodoc
class _$GiftCardPurchaseCopyWithImpl<$Res>
    implements $GiftCardPurchaseCopyWith<$Res> {
  _$GiftCardPurchaseCopyWithImpl(this._value, this._then);

  final GiftCardPurchase _value;
  // ignore: unused_field
  final $Res Function(GiftCardPurchase) _then;

  @override
  $Res call({
    Object? giftCardCategory = freezed,
    Object? uid = freezed,
    Object? code = freezed,
    Object? purchasedAt = freezed,
    Object? transferId = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      giftCardCategory: giftCardCategory == freezed
          ? _value.giftCardCategory
          : giftCardCategory // ignore: cast_nullable_to_non_nullable
              as GiftCardCategory,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasedAt: purchasedAt == freezed
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      transferId: transferId == freezed
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PurchasedGiftCardStatus,
    ));
  }

  @override
  $GiftCardCategoryCopyWith<$Res> get giftCardCategory {
    return $GiftCardCategoryCopyWith<$Res>(_value.giftCardCategory, (value) {
      return _then(_value.copyWith(giftCardCategory: value));
    });
  }
}

/// @nodoc
abstract class _$GiftCardPurchaseCopyWith<$Res>
    implements $GiftCardPurchaseCopyWith<$Res> {
  factory _$GiftCardPurchaseCopyWith(
          _GiftCardPurchase value, $Res Function(_GiftCardPurchase) then) =
      __$GiftCardPurchaseCopyWithImpl<$Res>;
  @override
  $Res call(
      {GiftCardCategory giftCardCategory,
      String uid,
      String? code,
      dynamic purchasedAt,
      String transferId,
      PurchasedGiftCardStatus status});

  @override
  $GiftCardCategoryCopyWith<$Res> get giftCardCategory;
}

/// @nodoc
class __$GiftCardPurchaseCopyWithImpl<$Res>
    extends _$GiftCardPurchaseCopyWithImpl<$Res>
    implements _$GiftCardPurchaseCopyWith<$Res> {
  __$GiftCardPurchaseCopyWithImpl(
      _GiftCardPurchase _value, $Res Function(_GiftCardPurchase) _then)
      : super(_value, (v) => _then(v as _GiftCardPurchase));

  @override
  _GiftCardPurchase get _value => super._value as _GiftCardPurchase;

  @override
  $Res call({
    Object? giftCardCategory = freezed,
    Object? uid = freezed,
    Object? code = freezed,
    Object? purchasedAt = freezed,
    Object? transferId = freezed,
    Object? status = freezed,
  }) {
    return _then(_GiftCardPurchase(
      giftCardCategory: giftCardCategory == freezed
          ? _value.giftCardCategory
          : giftCardCategory // ignore: cast_nullable_to_non_nullable
              as GiftCardCategory,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasedAt: purchasedAt == freezed
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      transferId: transferId == freezed
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PurchasedGiftCardStatus,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_GiftCardPurchase implements _GiftCardPurchase {
  const _$_GiftCardPurchase(
      {required this.giftCardCategory,
      required this.uid,
      this.code,
      this.purchasedAt = "",
      this.transferId = "placeholder",
      this.status = PurchasedGiftCardStatus.initialized});

  factory _$_GiftCardPurchase.fromJson(Map<String, dynamic> json) =>
      _$$_GiftCardPurchaseFromJson(json);

  @override
  final GiftCardCategory giftCardCategory;
  @override
  final String uid;
  @override
  final String? code;
  @JsonKey(defaultValue: "")
  @override
  final dynamic purchasedAt;
  @JsonKey(defaultValue: "placeholder")
  @override
  final String transferId;
  @JsonKey(defaultValue: PurchasedGiftCardStatus.initialized)
  @override
  final PurchasedGiftCardStatus status;

  @override
  String toString() {
    return 'GiftCardPurchase(giftCardCategory: $giftCardCategory, uid: $uid, code: $code, purchasedAt: $purchasedAt, transferId: $transferId, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GiftCardPurchase &&
            (identical(other.giftCardCategory, giftCardCategory) ||
                const DeepCollectionEquality()
                    .equals(other.giftCardCategory, giftCardCategory)) &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.purchasedAt, purchasedAt) ||
                const DeepCollectionEquality()
                    .equals(other.purchasedAt, purchasedAt)) &&
            (identical(other.transferId, transferId) ||
                const DeepCollectionEquality()
                    .equals(other.transferId, transferId)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(giftCardCategory) ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(purchasedAt) ^
      const DeepCollectionEquality().hash(transferId) ^
      const DeepCollectionEquality().hash(status);

  @JsonKey(ignore: true)
  @override
  _$GiftCardPurchaseCopyWith<_GiftCardPurchase> get copyWith =>
      __$GiftCardPurchaseCopyWithImpl<_GiftCardPurchase>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GiftCardPurchaseToJson(this);
  }
}

abstract class _GiftCardPurchase implements GiftCardPurchase {
  const factory _GiftCardPurchase(
      {required GiftCardCategory giftCardCategory,
      required String uid,
      String? code,
      dynamic purchasedAt,
      String transferId,
      PurchasedGiftCardStatus status}) = _$_GiftCardPurchase;

  factory _GiftCardPurchase.fromJson(Map<String, dynamic> json) =
      _$_GiftCardPurchase.fromJson;

  @override
  GiftCardCategory get giftCardCategory => throw _privateConstructorUsedError;
  @override
  String get uid => throw _privateConstructorUsedError;
  @override
  String? get code => throw _privateConstructorUsedError;
  @override
  dynamic get purchasedAt => throw _privateConstructorUsedError;
  @override
  String get transferId => throw _privateConstructorUsedError;
  @override
  PurchasedGiftCardStatus get status => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GiftCardPurchaseCopyWith<_GiftCardPurchase> get copyWith =>
      throw _privateConstructorUsedError;
}
