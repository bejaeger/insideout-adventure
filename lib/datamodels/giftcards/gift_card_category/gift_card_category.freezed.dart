// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'gift_card_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GiftCardCategory _$GiftCardCategoryFromJson(Map<String, dynamic> json) {
  return _GiftCardCategory.fromJson(json);
}

/// @nodoc
class _$GiftCardCategoryTearOff {
  const _$GiftCardCategoryTearOff();

  _GiftCardCategory call(
      {required String categoryId,
      required double amount,
      String? imageUrl,
      required String categoryName}) {
    return _GiftCardCategory(
      categoryId: categoryId,
      amount: amount,
      imageUrl: imageUrl,
      categoryName: categoryName,
    );
  }

  GiftCardCategory fromJson(Map<String, Object> json) {
    return GiftCardCategory.fromJson(json);
  }
}

/// @nodoc
const $GiftCardCategory = _$GiftCardCategoryTearOff();

/// @nodoc
mixin _$GiftCardCategory {
  String get categoryId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GiftCardCategoryCopyWith<GiftCardCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftCardCategoryCopyWith<$Res> {
  factory $GiftCardCategoryCopyWith(
          GiftCardCategory value, $Res Function(GiftCardCategory) then) =
      _$GiftCardCategoryCopyWithImpl<$Res>;
  $Res call(
      {String categoryId,
      double amount,
      String? imageUrl,
      String categoryName});
}

/// @nodoc
class _$GiftCardCategoryCopyWithImpl<$Res>
    implements $GiftCardCategoryCopyWith<$Res> {
  _$GiftCardCategoryCopyWithImpl(this._value, this._then);

  final GiftCardCategory _value;
  // ignore: unused_field
  final $Res Function(GiftCardCategory) _then;

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
              as String,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$GiftCardCategoryCopyWith<$Res>
    implements $GiftCardCategoryCopyWith<$Res> {
  factory _$GiftCardCategoryCopyWith(
          _GiftCardCategory value, $Res Function(_GiftCardCategory) then) =
      __$GiftCardCategoryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String categoryId,
      double amount,
      String? imageUrl,
      String categoryName});
}

/// @nodoc
class __$GiftCardCategoryCopyWithImpl<$Res>
    extends _$GiftCardCategoryCopyWithImpl<$Res>
    implements _$GiftCardCategoryCopyWith<$Res> {
  __$GiftCardCategoryCopyWithImpl(
      _GiftCardCategory _value, $Res Function(_GiftCardCategory) _then)
      : super(_value, (v) => _then(v as _GiftCardCategory));

  @override
  _GiftCardCategory get _value => super._value as _GiftCardCategory;

  @override
  $Res call({
    Object? categoryId = freezed,
    Object? amount = freezed,
    Object? imageUrl = freezed,
    Object? categoryName = freezed,
  }) {
    return _then(_GiftCardCategory(
      categoryId: categoryId == freezed
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GiftCardCategory implements _GiftCardCategory {
  _$_GiftCardCategory(
      {required this.categoryId,
      required this.amount,
      this.imageUrl,
      required this.categoryName});

  factory _$_GiftCardCategory.fromJson(Map<String, dynamic> json) =>
      _$$_GiftCardCategoryFromJson(json);

  @override
  final String categoryId;
  @override
  final double amount;
  @override
  final String? imageUrl;
  @override
  final String categoryName;

  @override
  String toString() {
    return 'GiftCardCategory(categoryId: $categoryId, amount: $amount, imageUrl: $imageUrl, categoryName: $categoryName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GiftCardCategory &&
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
  _$GiftCardCategoryCopyWith<_GiftCardCategory> get copyWith =>
      __$GiftCardCategoryCopyWithImpl<_GiftCardCategory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GiftCardCategoryToJson(this);
  }
}

abstract class _GiftCardCategory implements GiftCardCategory {
  factory _GiftCardCategory(
      {required String categoryId,
      required double amount,
      String? imageUrl,
      required String categoryName}) = _$_GiftCardCategory;

  factory _GiftCardCategory.fromJson(Map<String, dynamic> json) =
      _$_GiftCardCategory.fromJson;

  @override
  String get categoryId => throw _privateConstructorUsedError;
  @override
  double get amount => throw _privateConstructorUsedError;
  @override
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  String get categoryName => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GiftCardCategoryCopyWith<_GiftCardCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
