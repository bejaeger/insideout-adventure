// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'gift_card_purchase_success_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GiftCardPurchaseSuccessResult _$GiftCardPurchaseSuccessResultFromJson(
    Map<String, dynamic> json) {
  return _GiftCardPurchaseSuccessResult.fromJson(json);
}

/// @nodoc
class _$GiftCardPurchaseSuccessResultTearOff {
  const _$GiftCardPurchaseSuccessResultTearOff();

  _GiftCardPurchaseSuccessResult call(
      {required String transferId, required bool needToProvideGiftCard}) {
    return _GiftCardPurchaseSuccessResult(
      transferId: transferId,
      needToProvideGiftCard: needToProvideGiftCard,
    );
  }

  GiftCardPurchaseSuccessResult fromJson(Map<String, Object> json) {
    return GiftCardPurchaseSuccessResult.fromJson(json);
  }
}

/// @nodoc
const $GiftCardPurchaseSuccessResult = _$GiftCardPurchaseSuccessResultTearOff();

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
abstract class _$GiftCardPurchaseSuccessResultCopyWith<$Res>
    implements $GiftCardPurchaseSuccessResultCopyWith<$Res> {
  factory _$GiftCardPurchaseSuccessResultCopyWith(
          _GiftCardPurchaseSuccessResult value,
          $Res Function(_GiftCardPurchaseSuccessResult) then) =
      __$GiftCardPurchaseSuccessResultCopyWithImpl<$Res>;
  @override
  $Res call({String transferId, bool needToProvideGiftCard});
}

/// @nodoc
class __$GiftCardPurchaseSuccessResultCopyWithImpl<$Res>
    extends _$GiftCardPurchaseSuccessResultCopyWithImpl<$Res>
    implements _$GiftCardPurchaseSuccessResultCopyWith<$Res> {
  __$GiftCardPurchaseSuccessResultCopyWithImpl(
      _GiftCardPurchaseSuccessResult _value,
      $Res Function(_GiftCardPurchaseSuccessResult) _then)
      : super(_value, (v) => _then(v as _GiftCardPurchaseSuccessResult));

  @override
  _GiftCardPurchaseSuccessResult get _value =>
      super._value as _GiftCardPurchaseSuccessResult;

  @override
  $Res call({
    Object? transferId = freezed,
    Object? needToProvideGiftCard = freezed,
  }) {
    return _then(_GiftCardPurchaseSuccessResult(
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
      _$_$_GiftCardPurchaseSuccessResultFromJson(json);

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
        (other is _GiftCardPurchaseSuccessResult &&
            (identical(other.transferId, transferId) ||
                const DeepCollectionEquality()
                    .equals(other.transferId, transferId)) &&
            (identical(other.needToProvideGiftCard, needToProvideGiftCard) ||
                const DeepCollectionEquality().equals(
                    other.needToProvideGiftCard, needToProvideGiftCard)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(transferId) ^
      const DeepCollectionEquality().hash(needToProvideGiftCard);

  @JsonKey(ignore: true)
  @override
  _$GiftCardPurchaseSuccessResultCopyWith<_GiftCardPurchaseSuccessResult>
      get copyWith => __$GiftCardPurchaseSuccessResultCopyWithImpl<
          _GiftCardPurchaseSuccessResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GiftCardPurchaseSuccessResultToJson(this);
  }
}

abstract class _GiftCardPurchaseSuccessResult
    implements GiftCardPurchaseSuccessResult {
  factory _GiftCardPurchaseSuccessResult(
      {required String transferId,
      required bool needToProvideGiftCard}) = _$_GiftCardPurchaseSuccessResult;

  factory _GiftCardPurchaseSuccessResult.fromJson(Map<String, dynamic> json) =
      _$_GiftCardPurchaseSuccessResult.fromJson;

  @override
  String get transferId => throw _privateConstructorUsedError;
  @override
  bool get needToProvideGiftCard => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GiftCardPurchaseSuccessResultCopyWith<_GiftCardPurchaseSuccessResult>
      get copyWith => throw _privateConstructorUsedError;
}
