// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'gift_card_purchase_success_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GiftCardPurchaseSuccessResult _$GiftCardPurchaseSuccessResultFromJson(
    Map<String, dynamic> json) {
  return _GiftCardPurchaseSuccessResult.fromJson(json);
}

/// @nodoc
mixin _$GiftCardPurchaseSuccessResult {
  String get transferId => throw _privateConstructorUsedError;
  bool get needToProvideGiftCard => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GiftCardPurchaseSuccessResultCopyWith<GiftCardPurchaseSuccessResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftCardPurchaseSuccessResultCopyWith<$Res> {
  factory $GiftCardPurchaseSuccessResultCopyWith(
          GiftCardPurchaseSuccessResult value,
          $Res Function(GiftCardPurchaseSuccessResult) then) =
      _$GiftCardPurchaseSuccessResultCopyWithImpl<$Res>;
  $Res call({String transferId, bool needToProvideGiftCard});
}

/// @nodoc
class _$GiftCardPurchaseSuccessResultCopyWithImpl<$Res>
    implements $GiftCardPurchaseSuccessResultCopyWith<$Res> {
  _$GiftCardPurchaseSuccessResultCopyWithImpl(this._value, this._then);

  final GiftCardPurchaseSuccessResult _value;
  // ignore: unused_field
  final $Res Function(GiftCardPurchaseSuccessResult) _then;

  @override
  $Res call({
    Object? transferId = freezed,
    Object? needToProvideGiftCard = freezed,
  }) {
    return _then(_value.copyWith(
      transferId: transferId == freezed
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as String,
      needToProvideGiftCard: needToProvideGiftCard == freezed
          ? _value.needToProvideGiftCard
          : needToProvideGiftCard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_GiftCardPurchaseSuccessResultCopyWith<$Res>
    implements $GiftCardPurchaseSuccessResultCopyWith<$Res> {
  factory _$$_GiftCardPurchaseSuccessResultCopyWith(
          _$_GiftCardPurchaseSuccessResult value,
          $Res Function(_$_GiftCardPurchaseSuccessResult) then) =
      __$$_GiftCardPurchaseSuccessResultCopyWithImpl<$Res>;
  @override
  $Res call({String transferId, bool needToProvideGiftCard});
}

/// @nodoc
class __$$_GiftCardPurchaseSuccessResultCopyWithImpl<$Res>
    extends _$GiftCardPurchaseSuccessResultCopyWithImpl<$Res>
    implements _$$_GiftCardPurchaseSuccessResultCopyWith<$Res> {
  __$$_GiftCardPurchaseSuccessResultCopyWithImpl(
      _$_GiftCardPurchaseSuccessResult _value,
      $Res Function(_$_GiftCardPurchaseSuccessResult) _then)
      : super(_value, (v) => _then(v as _$_GiftCardPurchaseSuccessResult));

  @override
  _$_GiftCardPurchaseSuccessResult get _value =>
      super._value as _$_GiftCardPurchaseSuccessResult;

  @override
  $Res call({
    Object? transferId = freezed,
    Object? needToProvideGiftCard = freezed,
  }) {
    return _then(_$_GiftCardPurchaseSuccessResult(
      transferId: transferId == freezed
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as String,
      needToProvideGiftCard: needToProvideGiftCard == freezed
          ? _value.needToProvideGiftCard
          : needToProvideGiftCard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GiftCardPurchaseSuccessResult
    implements _GiftCardPurchaseSuccessResult {
  _$_GiftCardPurchaseSuccessResult(
      {required this.transferId, required this.needToProvideGiftCard});

  factory _$_GiftCardPurchaseSuccessResult.fromJson(
          Map<String, dynamic> json) =>
      _$$_GiftCardPurchaseSuccessResultFromJson(json);

  @override
  final String transferId;
  @override
  final bool needToProvideGiftCard;

  @override
  String toString() {
    return 'GiftCardPurchaseSuccessResult(transferId: $transferId, needToProvideGiftCard: $needToProvideGiftCard)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GiftCardPurchaseSuccessResult &&
            const DeepCollectionEquality()
                .equals(other.transferId, transferId) &&
            const DeepCollectionEquality()
                .equals(other.needToProvideGiftCard, needToProvideGiftCard));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(transferId),
      const DeepCollectionEquality().hash(needToProvideGiftCard));

  @JsonKey(ignore: true)
  @override
  _$$_GiftCardPurchaseSuccessResultCopyWith<_$_GiftCardPurchaseSuccessResult>
      get copyWith => __$$_GiftCardPurchaseSuccessResultCopyWithImpl<
          _$_GiftCardPurchaseSuccessResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GiftCardPurchaseSuccessResultToJson(
      this,
    );
  }
}

abstract class _GiftCardPurchaseSuccessResult
    implements GiftCardPurchaseSuccessResult {
  factory _GiftCardPurchaseSuccessResult(
          {required final String transferId,
          required final bool needToProvideGiftCard}) =
      _$_GiftCardPurchaseSuccessResult;

  factory _GiftCardPurchaseSuccessResult.fromJson(Map<String, dynamic> json) =
      _$_GiftCardPurchaseSuccessResult.fromJson;

  @override
  String get transferId;
  @override
  bool get needToProvideGiftCard;
  @override
  @JsonKey(ignore: true)
  _$$_GiftCardPurchaseSuccessResultCopyWith<_$_GiftCardPurchaseSuccessResult>
      get copyWith => throw _privateConstructorUsedError;
}
