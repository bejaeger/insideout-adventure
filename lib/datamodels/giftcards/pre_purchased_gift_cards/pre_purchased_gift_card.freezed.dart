// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      {required String categoryId,
      required String id,
      required String giftCardCode,
      required String categoryName}) {
    return _PrePurchasedGiftCard(
      categoryId: categoryId,
      id: id,
      giftCardCode: giftCardCode,
      categoryName: categoryName,
    );
  }

  PrePurchasedGiftCard fromJson(Map<String, Object?> json) {
    return PrePurchasedGiftCard.fromJson(json);
  }
}

/// @nodoc
const $PrePurchasedGiftCard = _$PrePurchasedGiftCardTearOff();

/// @nodoc
mixin _$PrePurchasedGiftCard {
/*    required String code,*/
  String get categoryId =>
      throw _privateConstructorUsedError; // required double amount,
//String? imageUrl,
  String get id => throw _privateConstructorUsedError;
  String get giftCardCode => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;

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
  $Res call(
      {String categoryId, String id, String giftCardCode, String categoryName});
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
    Object? categoryId = freezed,
    Object? id = freezed,
    Object? giftCardCode = freezed,
    Object? categoryName = freezed,
  }) {
    return _then(_value.copyWith(
      categoryId: categoryId == freezed
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      giftCardCode: giftCardCode == freezed
          ? _value.giftCardCode
          : giftCardCode // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call(
      {String categoryId, String id, String giftCardCode, String categoryName});
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
    Object? categoryId = freezed,
    Object? id = freezed,
    Object? giftCardCode = freezed,
    Object? categoryName = freezed,
  }) {
    return _then(_PrePurchasedGiftCard(
      categoryId: categoryId == freezed
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      giftCardCode: giftCardCode == freezed
          ? _value.giftCardCode
          : giftCardCode // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PrePurchasedGiftCard implements _PrePurchasedGiftCard {
  _$_PrePurchasedGiftCard(
      {required this.categoryId,
      required this.id,
      required this.giftCardCode,
      required this.categoryName});

  factory _$_PrePurchasedGiftCard.fromJson(Map<String, dynamic> json) =>
      _$$_PrePurchasedGiftCardFromJson(json);

  @override /*    required String code,*/
  final String categoryId;
  @override // required double amount,
//String? imageUrl,
  final String id;
  @override
  final String giftCardCode;
  @override
  final String categoryName;

  @override
  String toString() {
    return 'PrePurchasedGiftCard(categoryId: $categoryId, id: $id, giftCardCode: $giftCardCode, categoryName: $categoryName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PrePurchasedGiftCard &&
            const DeepCollectionEquality()
                .equals(other.categoryId, categoryId) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.giftCardCode, giftCardCode) &&
            const DeepCollectionEquality()
                .equals(other.categoryName, categoryName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(categoryId),
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(giftCardCode),
      const DeepCollectionEquality().hash(categoryName));

  @JsonKey(ignore: true)
  @override
  _$PrePurchasedGiftCardCopyWith<_PrePurchasedGiftCard> get copyWith =>
      __$PrePurchasedGiftCardCopyWithImpl<_PrePurchasedGiftCard>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PrePurchasedGiftCardToJson(this);
  }
}

abstract class _PrePurchasedGiftCard implements PrePurchasedGiftCard {
  factory _PrePurchasedGiftCard(
      {required String categoryId,
      required String id,
      required String giftCardCode,
      required String categoryName}) = _$_PrePurchasedGiftCard;

  factory _PrePurchasedGiftCard.fromJson(Map<String, dynamic> json) =
      _$_PrePurchasedGiftCard.fromJson;

  @override /*    required String code,*/
  String get categoryId;
  @override // required double amount,
//String? imageUrl,
  String get id;
  @override
  String get giftCardCode;
  @override
  String get categoryName;
  @override
  @JsonKey(ignore: true)
  _$PrePurchasedGiftCardCopyWith<_PrePurchasedGiftCard> get copyWith =>
      throw _privateConstructorUsedError;
}
