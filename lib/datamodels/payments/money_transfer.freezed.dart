// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'money_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MoneyTransfer _$MoneyTransferFromJson(Map<String, dynamic> json) {
  return _MoneyTransfer.fromJson(json);
}

/// @nodoc
class _$MoneyTransferTearOff {
  const _$MoneyTransferTearOff();

  _MoneyTransfer call(
      {required TransferDetails transferDetails,
      dynamic createdAt = "",
      TransferStatus status = TransferStatus.Initialized,
      TransferType type = TransferType.Sponsor2Explorer,
      @JsonKey(name: "transferId") String transferId = "placeholder"}) {
    return _MoneyTransfer(
      transferDetails: transferDetails,
      createdAt: createdAt,
      status: status,
      type: type,
      transferId: transferId,
    );
  }

  MoneyTransfer fromJson(Map<String, Object> json) {
    return MoneyTransfer.fromJson(json);
  }
}

/// @nodoc
const $MoneyTransfer = _$MoneyTransferTearOff();

/// @nodoc
mixin _$MoneyTransfer {
  TransferDetails get transferDetails => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  TransferStatus get status => throw _privateConstructorUsedError;
  TransferType get type => throw _privateConstructorUsedError;
  @JsonKey(name: "transferId")
  String get transferId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoneyTransferCopyWith<MoneyTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneyTransferCopyWith<$Res> {
  factory $MoneyTransferCopyWith(
          MoneyTransfer value, $Res Function(MoneyTransfer) then) =
      _$MoneyTransferCopyWithImpl<$Res>;
  $Res call(
      {TransferDetails transferDetails,
      dynamic createdAt,
      TransferStatus status,
      TransferType type,
      @JsonKey(name: "transferId") String transferId});

  $TransferDetailsCopyWith<$Res> get transferDetails;
}

/// @nodoc
class _$MoneyTransferCopyWithImpl<$Res>
    implements $MoneyTransferCopyWith<$Res> {
  _$MoneyTransferCopyWithImpl(this._value, this._then);

  final MoneyTransfer _value;
  // ignore: unused_field
  final $Res Function(MoneyTransfer) _then;

  @override
  $Res call({
    Object? transferDetails = freezed,
    Object? createdAt = freezed,
    Object? status = freezed,
    Object? type = freezed,
    Object? transferId = freezed,
  }) {
    return _then(_value.copyWith(
      transferDetails: transferDetails == freezed
          ? _value.transferDetails
          : transferDetails // ignore: cast_nullable_to_non_nullable
              as TransferDetails,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransferType,
      transferId: transferId == freezed
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  $TransferDetailsCopyWith<$Res> get transferDetails {
    return $TransferDetailsCopyWith<$Res>(_value.transferDetails, (value) {
      return _then(_value.copyWith(transferDetails: value));
    });
  }
}

/// @nodoc
abstract class _$MoneyTransferCopyWith<$Res>
    implements $MoneyTransferCopyWith<$Res> {
  factory _$MoneyTransferCopyWith(
          _MoneyTransfer value, $Res Function(_MoneyTransfer) then) =
      __$MoneyTransferCopyWithImpl<$Res>;
  @override
  $Res call(
      {TransferDetails transferDetails,
      dynamic createdAt,
      TransferStatus status,
      TransferType type,
      @JsonKey(name: "transferId") String transferId});

  @override
  $TransferDetailsCopyWith<$Res> get transferDetails;
}

/// @nodoc
class __$MoneyTransferCopyWithImpl<$Res>
    extends _$MoneyTransferCopyWithImpl<$Res>
    implements _$MoneyTransferCopyWith<$Res> {
  __$MoneyTransferCopyWithImpl(
      _MoneyTransfer _value, $Res Function(_MoneyTransfer) _then)
      : super(_value, (v) => _then(v as _MoneyTransfer));

  @override
  _MoneyTransfer get _value => super._value as _MoneyTransfer;

  @override
  $Res call({
    Object? transferDetails = freezed,
    Object? createdAt = freezed,
    Object? status = freezed,
    Object? type = freezed,
    Object? transferId = freezed,
  }) {
    return _then(_MoneyTransfer(
      transferDetails: transferDetails == freezed
          ? _value.transferDetails
          : transferDetails // ignore: cast_nullable_to_non_nullable
              as TransferDetails,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransferType,
      transferId: transferId == freezed
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_MoneyTransfer extends _MoneyTransfer {
  const _$_MoneyTransfer(
      {required this.transferDetails,
      this.createdAt = "",
      this.status = TransferStatus.Initialized,
      this.type = TransferType.Sponsor2Explorer,
      @JsonKey(name: "transferId") this.transferId = "placeholder"})
      : super._();

  factory _$_MoneyTransfer.fromJson(Map<String, dynamic> json) =>
      _$_$_MoneyTransferFromJson(json);

  @override
  final TransferDetails transferDetails;
  @JsonKey(defaultValue: "")
  @override
  final dynamic createdAt;
  @JsonKey(defaultValue: TransferStatus.Initialized)
  @override
  final TransferStatus status;
  @JsonKey(defaultValue: TransferType.Sponsor2Explorer)
  @override
  final TransferType type;
  @override
  @JsonKey(name: "transferId")
  final String transferId;

  @override
  String toString() {
    return 'MoneyTransfer(transferDetails: $transferDetails, createdAt: $createdAt, status: $status, type: $type, transferId: $transferId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MoneyTransfer &&
            (identical(other.transferDetails, transferDetails) ||
                const DeepCollectionEquality()
                    .equals(other.transferDetails, transferDetails)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.transferId, transferId) ||
                const DeepCollectionEquality()
                    .equals(other.transferId, transferId)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(transferDetails) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(transferId);

  @JsonKey(ignore: true)
  @override
  _$MoneyTransferCopyWith<_MoneyTransfer> get copyWith =>
      __$MoneyTransferCopyWithImpl<_MoneyTransfer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MoneyTransferToJson(this);
  }
}

abstract class _MoneyTransfer extends MoneyTransfer {
  const factory _MoneyTransfer(
      {required TransferDetails transferDetails,
      dynamic createdAt,
      TransferStatus status,
      TransferType type,
      @JsonKey(name: "transferId") String transferId}) = _$_MoneyTransfer;
  const _MoneyTransfer._() : super._();

  factory _MoneyTransfer.fromJson(Map<String, dynamic> json) =
      _$_MoneyTransfer.fromJson;

  @override
  TransferDetails get transferDetails => throw _privateConstructorUsedError;
  @override
  dynamic get createdAt => throw _privateConstructorUsedError;
  @override
  TransferStatus get status => throw _privateConstructorUsedError;
  @override
  TransferType get type => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: "transferId")
  String get transferId => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MoneyTransferCopyWith<_MoneyTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}
