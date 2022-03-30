// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'money_transfer_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MoneyTransferStatusModelTearOff {
  const _$MoneyTransferStatusModelTearOff();

  _MoneyTransferStatusModel call(
      {required Future<TransferDialogStatus> futureStatus,
      required TransferType type}) {
    return _MoneyTransferStatusModel(
      futureStatus: futureStatus,
      type: type,
    );
  }
}

/// @nodoc
const $MoneyTransferStatusModel = _$MoneyTransferStatusModelTearOff();

/// @nodoc
mixin _$MoneyTransferStatusModel {
  Future<TransferDialogStatus> get futureStatus =>
      throw _privateConstructorUsedError;
  TransferType get type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoneyTransferStatusModelCopyWith<MoneyTransferStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneyTransferStatusModelCopyWith<$Res> {
  factory $MoneyTransferStatusModelCopyWith(MoneyTransferStatusModel value,
          $Res Function(MoneyTransferStatusModel) then) =
      _$MoneyTransferStatusModelCopyWithImpl<$Res>;
  $Res call({Future<TransferDialogStatus> futureStatus, TransferType type});
}

/// @nodoc
class _$MoneyTransferStatusModelCopyWithImpl<$Res>
    implements $MoneyTransferStatusModelCopyWith<$Res> {
  _$MoneyTransferStatusModelCopyWithImpl(this._value, this._then);

  final MoneyTransferStatusModel _value;
  // ignore: unused_field
  final $Res Function(MoneyTransferStatusModel) _then;

  @override
  $Res call({
    Object? futureStatus = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      futureStatus: futureStatus == freezed
          ? _value.futureStatus
          : futureStatus // ignore: cast_nullable_to_non_nullable
              as Future<TransferDialogStatus>,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransferType,
    ));
  }
}

/// @nodoc
abstract class _$MoneyTransferStatusModelCopyWith<$Res>
    implements $MoneyTransferStatusModelCopyWith<$Res> {
  factory _$MoneyTransferStatusModelCopyWith(_MoneyTransferStatusModel value,
          $Res Function(_MoneyTransferStatusModel) then) =
      __$MoneyTransferStatusModelCopyWithImpl<$Res>;
  @override
  $Res call({Future<TransferDialogStatus> futureStatus, TransferType type});
}

/// @nodoc
class __$MoneyTransferStatusModelCopyWithImpl<$Res>
    extends _$MoneyTransferStatusModelCopyWithImpl<$Res>
    implements _$MoneyTransferStatusModelCopyWith<$Res> {
  __$MoneyTransferStatusModelCopyWithImpl(_MoneyTransferStatusModel _value,
      $Res Function(_MoneyTransferStatusModel) _then)
      : super(_value, (v) => _then(v as _MoneyTransferStatusModel));

  @override
  _MoneyTransferStatusModel get _value =>
      super._value as _MoneyTransferStatusModel;

  @override
  $Res call({
    Object? futureStatus = freezed,
    Object? type = freezed,
  }) {
    return _then(_MoneyTransferStatusModel(
      futureStatus: futureStatus == freezed
          ? _value.futureStatus
          : futureStatus // ignore: cast_nullable_to_non_nullable
              as Future<TransferDialogStatus>,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransferType,
    ));
  }
}

/// @nodoc

class _$_MoneyTransferStatusModel implements _MoneyTransferStatusModel {
  _$_MoneyTransferStatusModel({required this.futureStatus, required this.type});

  @override
  final Future<TransferDialogStatus> futureStatus;
  @override
  final TransferType type;

  @override
  String toString() {
    return 'MoneyTransferStatusModel(futureStatus: $futureStatus, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MoneyTransferStatusModel &&
            const DeepCollectionEquality()
                .equals(other.futureStatus, futureStatus) &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(futureStatus),
      const DeepCollectionEquality().hash(type));

  @JsonKey(ignore: true)
  @override
  _$MoneyTransferStatusModelCopyWith<_MoneyTransferStatusModel> get copyWith =>
      __$MoneyTransferStatusModelCopyWithImpl<_MoneyTransferStatusModel>(
          this, _$identity);
}

abstract class _MoneyTransferStatusModel implements MoneyTransferStatusModel {
  factory _MoneyTransferStatusModel(
      {required Future<TransferDialogStatus> futureStatus,
      required TransferType type}) = _$_MoneyTransferStatusModel;

  @override
  Future<TransferDialogStatus> get futureStatus;
  @override
  TransferType get type;
  @override
  @JsonKey(ignore: true)
  _$MoneyTransferStatusModelCopyWith<_MoneyTransferStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}
