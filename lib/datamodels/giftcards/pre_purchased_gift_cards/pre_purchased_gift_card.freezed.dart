// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pre_purchased_gift_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PrePurchasedGiftCard _$PrePurchasedGiftCardFromJson(Map<String, dynamic> json) {
  return _PrePurchasedGiftCard.fromJson(json);
}

/// @nodoc
class _$PrePurchasedGiftCardTearOff {
  const _$PrePurchasedGiftCardTearOff();

  _PrePurchasedGiftCard call(
      {required String code,
      required String categoryId,
      required double amount}) {
    return _PrePurchasedGiftCard(
      code: code,
      categoryId: categoryId,
      amount: amount,
    );
  }

  PrePurchasedGiftCard fromJson(Map<String, Object> json) {
    return PrePurchasedGiftCard.fromJson(json);
  }
}

/// @nodoc
const $PrePurchasedGiftCard = _$PrePurchasedGiftCardTearOff();

/// @nodoc
mixin _$PrePurchasedGiftCard {
  String get code => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrePurchasedGiftCardCopyWith<PrePurchasedGiftCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrePurchasedGiftCardCopyWith<$Res> {
  factory $PrePurchasedGiftCardCopyWith(PrePurchasedGiftCard value,
          $Res Function(PrePurchasedGiftCard) then) =
      _$PrePurchasedGiftCardCopyWithImpl<$Res>;
  $Res call({String code, String categoryId, double amount});
}

/// @nodoc
class _$PrePurchasedGiftCardCopyWithImpl<$Res>
    implements $PrePurchasedGiftCardCopyWith<$Res> {
  _$PrePurchasedGiftCardCopyWithImpl(this._value, this._then);

  final PrePurchasedGiftCard _value;
  // ignore: unused_field
  final $Res Function(PrePurchasedGiftCard) _then;

  @override
  $Res call({
    Object? code = freezed,
    Object? categoryId = freezed,
    Object? amount = freezed,
  }) {
    return _then(_value.copyWith(
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: categoryId == freezed
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$PrePurchasedGiftCardCopyWith<$Res>
    implements $PrePurchasedGiftCardCopyWith<$Res> {
  factory _$PrePurchasedGiftCardCopyWith(_PrePurchasedGiftCard value,
          $Res Function(_PrePurchasedGiftCard) then) =
      __$PrePurchasedGiftCardCopyWithImpl<$Res>;
  @override
  $Res call({String code, String categoryId, double amount});
}

/// @nodoc
class __$PrePurchasedGiftCardCopyWithImpl<$Res>
    extends _$PrePurchasedGiftCardCopyWithImpl<$Res>
    implements _$PrePurchasedGiftCardCopyWith<$Res> {
  __$PrePurchasedGiftCardCopyWithImpl(
      _PrePurchasedGiftCard _value, $Res Function(_PrePurchasedGiftCard) _then)
      : super(_value, (v) => _then(v as _PrePurchasedGiftCard));

  @override
  _PrePurchasedGiftCard get _value => super._value as _PrePurchasedGiftCard;

  @override
  $Res call({
    Object? code = freezed,
    Object? categoryId = freezed,
    Object? amount = freezed,
  }) {
    return _then(_PrePurchasedGiftCard(
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: categoryId == freezed
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PrePurchasedGiftCard implements _PrePurchasedGiftCard {
  _$_PrePurchasedGiftCard(
      {required this.code, required this.categoryId, required this.amount});

  factory _$_PrePurchasedGiftCard.fromJson(Map<String, dynamic> json) =>
      _$_$_PrePurchasedGiftCardFromJson(json);

  @override
  final String code;
  @override
  final String categoryId;
  @override
  final double amount;

  @override
  String toString() {
    return 'PrePurchasedGiftCard(code: $code, categoryId: $categoryId, amount: $amount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PrePurchasedGiftCard &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.categoryId, categoryId) ||
                const DeepCollectionEquality()
                    .equals(other.categoryId, categoryId)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(categoryId) ^
      const DeepCollectionEquality().hash(amount);

  @JsonKey(ignore: true)
  @override
  _$PrePurchasedGiftCardCopyWith<_PrePurchasedGiftCard> get copyWith =>
      __$PrePurchasedGiftCardCopyWithImpl<_PrePurchasedGiftCard>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PrePurchasedGiftCardToJson(this);
  }
}

abstract class _PrePurchasedGiftCard implements PrePurchasedGiftCard {
  factory _PrePurchasedGiftCard(
      {required String code,
      required String categoryId,
      required double amount}) = _$_PrePurchasedGiftCard;

  factory _PrePurchasedGiftCard.fromJson(Map<String, dynamic> json) =
      _$_PrePurchasedGiftCard.fromJson;

  @override
  String get code => throw _privateConstructorUsedError;
  @override
  String get categoryId => throw _privateConstructorUsedError;
  @override
  double get amount => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PrePurchasedGiftCardCopyWith<_PrePurchasedGiftCard> get copyWith =>
      throw _privateConstructorUsedError;
}
