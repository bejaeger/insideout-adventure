// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'gift_card_purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GiftCardPurchase _$GiftCardPurchaseFromJson(Map<String, dynamic> json) {
  return _GiftCardPurchase.fromJson(json);
}

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
abstract class _$$_GiftCardPurchaseCopyWith<$Res>
    implements $GiftCardPurchaseCopyWith<$Res> {
  factory _$$_GiftCardPurchaseCopyWith(
          _$_GiftCardPurchase value, $Res Function(_$_GiftCardPurchase) then) =
      __$$_GiftCardPurchaseCopyWithImpl<$Res>;
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
class __$$_GiftCardPurchaseCopyWithImpl<$Res>
    extends _$GiftCardPurchaseCopyWithImpl<$Res>
    implements _$$_GiftCardPurchaseCopyWith<$Res> {
  __$$_GiftCardPurchaseCopyWithImpl(
      _$_GiftCardPurchase _value, $Res Function(_$_GiftCardPurchase) _then)
      : super(_value, (v) => _then(v as _$_GiftCardPurchase));

  @override
  _$_GiftCardPurchase get _value => super._value as _$_GiftCardPurchase;

  @override
  $Res call({
    Object? giftCardCategory = freezed,
    Object? uid = freezed,
    Object? code = freezed,
    Object? purchasedAt = freezed,
    Object? transferId = freezed,
    Object? status = freezed,
  }) {
    return _then(_$_GiftCardPurchase(
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
  @override
  @JsonKey()
  final dynamic purchasedAt;
  @override
  @JsonKey()
  final String transferId;
  @override
  @JsonKey()
  final PurchasedGiftCardStatus status;

  @override
  String toString() {
    return 'GiftCardPurchase(giftCardCategory: $giftCardCategory, uid: $uid, code: $code, purchasedAt: $purchasedAt, transferId: $transferId, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GiftCardPurchase &&
            const DeepCollectionEquality()
                .equals(other.giftCardCategory, giftCardCategory) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.code, code) &&
            const DeepCollectionEquality()
                .equals(other.purchasedAt, purchasedAt) &&
            const DeepCollectionEquality()
                .equals(other.transferId, transferId) &&
            const DeepCollectionEquality().equals(other.status, status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(giftCardCategory),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(code),
      const DeepCollectionEquality().hash(purchasedAt),
      const DeepCollectionEquality().hash(transferId),
      const DeepCollectionEquality().hash(status));

  @JsonKey(ignore: true)
  @override
  _$$_GiftCardPurchaseCopyWith<_$_GiftCardPurchase> get copyWith =>
      __$$_GiftCardPurchaseCopyWithImpl<_$_GiftCardPurchase>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GiftCardPurchaseToJson(
      this,
    );
  }
}

abstract class _GiftCardPurchase implements GiftCardPurchase {
  const factory _GiftCardPurchase(
      {required final GiftCardCategory giftCardCategory,
      required final String uid,
      final String? code,
      final dynamic purchasedAt,
      final String transferId,
      final PurchasedGiftCardStatus status}) = _$_GiftCardPurchase;

  factory _GiftCardPurchase.fromJson(Map<String, dynamic> json) =
      _$_GiftCardPurchase.fromJson;

  @override
  GiftCardCategory get giftCardCategory;
  @override
  String get uid;
  @override
  String? get code;
  @override
  dynamic get purchasedAt;
  @override
  String get transferId;
  @override
  PurchasedGiftCardStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$_GiftCardPurchaseCopyWith<_$_GiftCardPurchase> get copyWith =>
      throw _privateConstructorUsedError;
}
