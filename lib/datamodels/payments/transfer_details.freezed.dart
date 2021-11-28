// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'transfer_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TransferDetails _$TransferDetailsFromJson(Map<String, dynamic> json) {
  return _TransferDetails.fromJson(json);
}

/// @nodoc
class _$TransferDetailsTearOff {
  const _$TransferDetailsTearOff();

  _TransferDetails call(
      {required String recipientId,
      required String recipientName,
      required String senderId,
      required String senderName,
      required num amount,
      required String currency,
      required MoneySource sourceType}) {
    return _TransferDetails(
      recipientId: recipientId,
      recipientName: recipientName,
      senderId: senderId,
      senderName: senderName,
      amount: amount,
      currency: currency,
      sourceType: sourceType,
    );
  }

  TransferDetails fromJson(Map<String, Object> json) {
    return TransferDetails.fromJson(json);
  }
}

/// @nodoc
const $TransferDetails = _$TransferDetailsTearOff();

/// @nodoc
mixin _$TransferDetails {
  String get recipientId => throw _privateConstructorUsedError;
  String get recipientName => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  num get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  MoneySource get sourceType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferDetailsCopyWith<TransferDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferDetailsCopyWith<$Res> {
  factory $TransferDetailsCopyWith(
          TransferDetails value, $Res Function(TransferDetails) then) =
      _$TransferDetailsCopyWithImpl<$Res>;
  $Res call(
      {String recipientId,
      String recipientName,
      String senderId,
      String senderName,
      num amount,
      String currency,
      MoneySource sourceType});
}

/// @nodoc
class _$TransferDetailsCopyWithImpl<$Res>
    implements $TransferDetailsCopyWith<$Res> {
  _$TransferDetailsCopyWithImpl(this._value, this._then);

  final TransferDetails _value;
  // ignore: unused_field
  final $Res Function(TransferDetails) _then;

  @override
  $Res call({
    Object? recipientId = freezed,
    Object? recipientName = freezed,
    Object? senderId = freezed,
    Object? senderName = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? sourceType = freezed,
  }) {
    return _then(_value.copyWith(
      recipientId: recipientId == freezed
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientName: recipientName == freezed
          ? _value.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: senderId == freezed
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: senderName == freezed
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      currency: currency == freezed
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      sourceType: sourceType == freezed
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as MoneySource,
    ));
  }
}

/// @nodoc
abstract class _$TransferDetailsCopyWith<$Res>
    implements $TransferDetailsCopyWith<$Res> {
  factory _$TransferDetailsCopyWith(
          _TransferDetails value, $Res Function(_TransferDetails) then) =
      __$TransferDetailsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String recipientId,
      String recipientName,
      String senderId,
      String senderName,
      num amount,
      String currency,
      MoneySource sourceType});
}

/// @nodoc
class __$TransferDetailsCopyWithImpl<$Res>
    extends _$TransferDetailsCopyWithImpl<$Res>
    implements _$TransferDetailsCopyWith<$Res> {
  __$TransferDetailsCopyWithImpl(
      _TransferDetails _value, $Res Function(_TransferDetails) _then)
      : super(_value, (v) => _then(v as _TransferDetails));

  @override
  _TransferDetails get _value => super._value as _TransferDetails;

  @override
  $Res call({
    Object? recipientId = freezed,
    Object? recipientName = freezed,
    Object? senderId = freezed,
    Object? senderName = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? sourceType = freezed,
  }) {
    return _then(_TransferDetails(
      recipientId: recipientId == freezed
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientName: recipientName == freezed
          ? _value.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: senderId == freezed
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: senderName == freezed
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      currency: currency == freezed
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      sourceType: sourceType == freezed
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as MoneySource,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TransferDetails implements _TransferDetails {
  const _$_TransferDetails(
      {required this.recipientId,
      required this.recipientName,
      required this.senderId,
      required this.senderName,
      required this.amount,
      required this.currency,
      required this.sourceType});

  factory _$_TransferDetails.fromJson(Map<String, dynamic> json) =>
      _$$_TransferDetailsFromJson(json);

  @override
  final String recipientId;
  @override
  final String recipientName;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final num amount;
  @override
  final String currency;
  @override
  final MoneySource sourceType;

  @override
  String toString() {
    return 'TransferDetails(recipientId: $recipientId, recipientName: $recipientName, senderId: $senderId, senderName: $senderName, amount: $amount, currency: $currency, sourceType: $sourceType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TransferDetails &&
            (identical(other.recipientId, recipientId) ||
                const DeepCollectionEquality()
                    .equals(other.recipientId, recipientId)) &&
            (identical(other.recipientName, recipientName) ||
                const DeepCollectionEquality()
                    .equals(other.recipientName, recipientName)) &&
            (identical(other.senderId, senderId) ||
                const DeepCollectionEquality()
                    .equals(other.senderId, senderId)) &&
            (identical(other.senderName, senderName) ||
                const DeepCollectionEquality()
                    .equals(other.senderName, senderName)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.currency, currency) ||
                const DeepCollectionEquality()
                    .equals(other.currency, currency)) &&
            (identical(other.sourceType, sourceType) ||
                const DeepCollectionEquality()
                    .equals(other.sourceType, sourceType)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(recipientId) ^
      const DeepCollectionEquality().hash(recipientName) ^
      const DeepCollectionEquality().hash(senderId) ^
      const DeepCollectionEquality().hash(senderName) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(currency) ^
      const DeepCollectionEquality().hash(sourceType);

  @JsonKey(ignore: true)
  @override
  _$TransferDetailsCopyWith<_TransferDetails> get copyWith =>
      __$TransferDetailsCopyWithImpl<_TransferDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TransferDetailsToJson(this);
  }
}

abstract class _TransferDetails implements TransferDetails {
  const factory _TransferDetails(
      {required String recipientId,
      required String recipientName,
      required String senderId,
      required String senderName,
      required num amount,
      required String currency,
      required MoneySource sourceType}) = _$_TransferDetails;

  factory _TransferDetails.fromJson(Map<String, dynamic> json) =
      _$_TransferDetails.fromJson;

  @override
  String get recipientId => throw _privateConstructorUsedError;
  @override
  String get recipientName => throw _privateConstructorUsedError;
  @override
  String get senderId => throw _privateConstructorUsedError;
  @override
  String get senderName => throw _privateConstructorUsedError;
  @override
  num get amount => throw _privateConstructorUsedError;
  @override
  String get currency => throw _privateConstructorUsedError;
  @override
  MoneySource get sourceType => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TransferDetailsCopyWith<_TransferDetails> get copyWith =>
      throw _privateConstructorUsedError;
}
