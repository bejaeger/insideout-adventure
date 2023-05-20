// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'money_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MoneyTransfer _$MoneyTransferFromJson(Map<String, dynamic> json) {
  return _MoneyTransfer.fromJson(json);
}

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
abstract class _$$_MoneyTransferCopyWith<$Res>
    implements $MoneyTransferCopyWith<$Res> {
  factory _$$_MoneyTransferCopyWith(
          _$_MoneyTransfer value, $Res Function(_$_MoneyTransfer) then) =
      __$$_MoneyTransferCopyWithImpl<$Res>;
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
class __$$_MoneyTransferCopyWithImpl<$Res>
    extends _$MoneyTransferCopyWithImpl<$Res>
    implements _$$_MoneyTransferCopyWith<$Res> {
  __$$_MoneyTransferCopyWithImpl(
      _$_MoneyTransfer _value, $Res Function(_$_MoneyTransfer) _then)
      : super(_value, (v) => _then(v as _$_MoneyTransfer));

  @override
  _$_MoneyTransfer get _value => super._value as _$_MoneyTransfer;

  @override
  $Res call({
    Object? transferDetails = freezed,
    Object? createdAt = freezed,
    Object? status = freezed,
    Object? type = freezed,
    Object? transferId = freezed,
  }) {
    return _then(_$_MoneyTransfer(
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
      this.type = TransferType.Guardian2WardCredits,
      @JsonKey(name: "transferId") this.transferId = "placeholder"})
      : super._();

  factory _$_MoneyTransfer.fromJson(Map<String, dynamic> json) =>
      _$$_MoneyTransferFromJson(json);

  @override
  final TransferDetails transferDetails;
  @override
  @JsonKey()
  final dynamic createdAt;
  @override
  @JsonKey()
  final TransferStatus status;
  @override
  @JsonKey()
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
        (other.runtimeType == runtimeType &&
            other is _$_MoneyTransfer &&
            const DeepCollectionEquality()
                .equals(other.transferDetails, transferDetails) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.transferId, transferId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(transferDetails),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(transferId));

  @JsonKey(ignore: true)
  @override
  _$$_MoneyTransferCopyWith<_$_MoneyTransfer> get copyWith =>
      __$$_MoneyTransferCopyWithImpl<_$_MoneyTransfer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MoneyTransferToJson(
      this,
    );
  }
}

abstract class _MoneyTransfer extends MoneyTransfer {
  const factory _MoneyTransfer(
      {required final TransferDetails transferDetails,
      final dynamic createdAt,
      final TransferStatus status,
      final TransferType type,
      @JsonKey(name: "transferId") final String transferId}) = _$_MoneyTransfer;
  const _MoneyTransfer._() : super._();

  factory _MoneyTransfer.fromJson(Map<String, dynamic> json) =
      _$_MoneyTransfer.fromJson;

  @override
  TransferDetails get transferDetails;
  @override
  dynamic get createdAt;
  @override
  TransferStatus get status;
  @override
  TransferType get type;
  @override
  @JsonKey(name: "transferId")
  String get transferId;
  @override
  @JsonKey(ignore: true)
  _$$_MoneyTransferCopyWith<_$_MoneyTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}
