// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'transfer_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TransferStatusModel {
  Future<TransferDialogStatus> get futureStatus =>
      throw _privateConstructorUsedError;
  TransferType get type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransferStatusModelCopyWith<TransferStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferStatusModelCopyWith<$Res> {
  factory $TransferStatusModelCopyWith(
          TransferStatusModel value, $Res Function(TransferStatusModel) then) =
      _$TransferStatusModelCopyWithImpl<$Res>;
  $Res call({Future<TransferDialogStatus> futureStatus, TransferType type});
}

/// @nodoc
class _$TransferStatusModelCopyWithImpl<$Res>
    implements $TransferStatusModelCopyWith<$Res> {
  _$TransferStatusModelCopyWithImpl(this._value, this._then);

  final TransferStatusModel _value;
  // ignore: unused_field
  final $Res Function(TransferStatusModel) _then;

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
abstract class _$$_TransferStatusModelCopyWith<$Res>
    implements $TransferStatusModelCopyWith<$Res> {
  factory _$$_TransferStatusModelCopyWith(_$_TransferStatusModel value,
          $Res Function(_$_TransferStatusModel) then) =
      __$$_TransferStatusModelCopyWithImpl<$Res>;
  @override
  $Res call({Future<TransferDialogStatus> futureStatus, TransferType type});
}

/// @nodoc
class __$$_TransferStatusModelCopyWithImpl<$Res>
    extends _$TransferStatusModelCopyWithImpl<$Res>
    implements _$$_TransferStatusModelCopyWith<$Res> {
  __$$_TransferStatusModelCopyWithImpl(_$_TransferStatusModel _value,
      $Res Function(_$_TransferStatusModel) _then)
      : super(_value, (v) => _then(v as _$_TransferStatusModel));

  @override
  _$_TransferStatusModel get _value => super._value as _$_TransferStatusModel;

  @override
  $Res call({
    Object? futureStatus = freezed,
    Object? type = freezed,
  }) {
    return _then(_$_TransferStatusModel(
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

class _$_TransferStatusModel implements _TransferStatusModel {
  _$_TransferStatusModel({required this.futureStatus, required this.type});

  @override
  final Future<TransferDialogStatus> futureStatus;
  @override
  final TransferType type;

  @override
  String toString() {
    return 'TransferStatusModel(futureStatus: $futureStatus, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TransferStatusModel &&
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
  _$$_TransferStatusModelCopyWith<_$_TransferStatusModel> get copyWith =>
      __$$_TransferStatusModelCopyWithImpl<_$_TransferStatusModel>(
          this, _$identity);
}

abstract class _TransferStatusModel implements TransferStatusModel {
  factory _TransferStatusModel(
      {required final Future<TransferDialogStatus> futureStatus,
      required final TransferType type}) = _$_TransferStatusModel;

  @override
  Future<TransferDialogStatus> get futureStatus;
  @override
  TransferType get type;
  @override
  @JsonKey(ignore: true)
  _$$_TransferStatusModelCopyWith<_$_TransferStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}
