// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'giftcards.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Giftcards _$GiftcardsFromJson(Map<String, dynamic> json) {
  return _Giftcards.fromJson(json);
}

/// @nodoc
class _$GiftcardsTearOff {
  const _$GiftcardsTearOff();

  _Giftcards call(
      {String? categoryId,
      double? amount,
      String? imageUrl,
      String? categoryName}) {
    return _Giftcards(
      categoryId: categoryId,
      amount: amount,
      imageUrl: imageUrl,
      categoryName: categoryName,
    );
  }

  Giftcards fromJson(Map<String, Object> json) {
    return Giftcards.fromJson(json);
  }
}

/// @nodoc
const $Giftcards = _$GiftcardsTearOff();

/// @nodoc
mixin _$Giftcards {
  String? get categoryId => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GiftcardsCopyWith<Giftcards> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftcardsCopyWith<$Res> {
  factory $GiftcardsCopyWith(Giftcards value, $Res Function(Giftcards) then) =
      _$GiftcardsCopyWithImpl<$Res>;
  $Res call(
      {String? categoryId,
      double? amount,
      String? imageUrl,
      String? categoryName});
}

/// @nodoc
class _$GiftcardsCopyWithImpl<$Res> implements $GiftcardsCopyWith<$Res> {
  _$GiftcardsCopyWithImpl(this._value, this._then);

  final Giftcards _value;
  // ignore: unused_field
  final $Res Function(Giftcards) _then;

  @override
  $Res call({
    Object? categoryId = freezed,
    Object? amount = freezed,
    Object? imageUrl = freezed,
    Object? categoryName = freezed,
  }) {
    return _then(_value.copyWith(
      categoryId: categoryId == freezed
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$GiftcardsCopyWith<$Res> implements $GiftcardsCopyWith<$Res> {
  factory _$GiftcardsCopyWith(
          _Giftcards value, $Res Function(_Giftcards) then) =
      __$GiftcardsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? categoryId,
      double? amount,
      String? imageUrl,
      String? categoryName});
}

/// @nodoc
class __$GiftcardsCopyWithImpl<$Res> extends _$GiftcardsCopyWithImpl<$Res>
    implements _$GiftcardsCopyWith<$Res> {
  __$GiftcardsCopyWithImpl(_Giftcards _value, $Res Function(_Giftcards) _then)
      : super(_value, (v) => _then(v as _Giftcards));

  @override
  _Giftcards get _value => super._value as _Giftcards;

  @override
  $Res call({
    Object? categoryId = freezed,
    Object? amount = freezed,
    Object? imageUrl = freezed,
    Object? categoryName = freezed,
  }) {
    return _then(_Giftcards(
      categoryId: categoryId == freezed
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Giftcards implements _Giftcards {
  _$_Giftcards(
      {this.categoryId, this.amount, this.imageUrl, this.categoryName});

  factory _$_Giftcards.fromJson(Map<String, dynamic> json) =>
      _$_$_GiftcardsFromJson(json);

  @override
  final String? categoryId;
  @override
  final double? amount;
  @override
  final String? imageUrl;
  @override
  final String? categoryName;

  @override
  String toString() {
    return 'Giftcards(categoryId: $categoryId, amount: $amount, imageUrl: $imageUrl, categoryName: $categoryName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Giftcards &&
            (identical(other.categoryId, categoryId) ||
                const DeepCollectionEquality()
                    .equals(other.categoryId, categoryId)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.categoryName, categoryName) ||
                const DeepCollectionEquality()
                    .equals(other.categoryName, categoryName)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(categoryId) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(categoryName);

  @JsonKey(ignore: true)
  @override
  _$GiftcardsCopyWith<_Giftcards> get copyWith =>
      __$GiftcardsCopyWithImpl<_Giftcards>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GiftcardsToJson(this);
  }
}

abstract class _Giftcards implements Giftcards {
  factory _Giftcards(
      {String? categoryId,
      double? amount,
      String? imageUrl,
      String? categoryName}) = _$_Giftcards;

  factory _Giftcards.fromJson(Map<String, dynamic> json) =
      _$_Giftcards.fromJson;

  @override
  String? get categoryId => throw _privateConstructorUsedError;
  @override
  double? get amount => throw _privateConstructorUsedError;
  @override
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  String? get categoryName => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GiftcardsCopyWith<_Giftcards> get copyWith =>
      throw _privateConstructorUsedError;
}
