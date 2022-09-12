// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'afk_marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AFKMarker _$AFKMarkerFromJson(Map<String, dynamic> json) {
  return _AFKMarker.fromJson(json);
}

/// @nodoc
mixin _$AFKMarker {
  String get id => throw _privateConstructorUsedError;
  String? get qrCodeId => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  MarkerStatus get markerStatus => throw _privateConstructorUsedError;
  int get repeatable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AFKMarkerCopyWith<AFKMarker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AFKMarkerCopyWith<$Res> {
  factory $AFKMarkerCopyWith(AFKMarker value, $Res Function(AFKMarker) then) =
      _$AFKMarkerCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String? qrCodeId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus,
      int repeatable});
}

/// @nodoc
class _$AFKMarkerCopyWithImpl<$Res> implements $AFKMarkerCopyWith<$Res> {
  _$AFKMarkerCopyWithImpl(this._value, this._then);

  final AFKMarker _value;
  // ignore: unused_field
  final $Res Function(AFKMarker) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? qrCodeId = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? markerStatus = freezed,
    Object? repeatable = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeId: qrCodeId == freezed
          ? _value.qrCodeId
          : qrCodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      markerStatus: markerStatus == freezed
          ? _value.markerStatus
          : markerStatus // ignore: cast_nullable_to_non_nullable
              as MarkerStatus,
      repeatable: repeatable == freezed
          ? _value.repeatable
          : repeatable // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_AFKMarkerCopyWith<$Res> implements $AFKMarkerCopyWith<$Res> {
  factory _$$_AFKMarkerCopyWith(
          _$_AFKMarker value, $Res Function(_$_AFKMarker) then) =
      __$$_AFKMarkerCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String? qrCodeId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus,
      int repeatable});
}

/// @nodoc
class __$$_AFKMarkerCopyWithImpl<$Res> extends _$AFKMarkerCopyWithImpl<$Res>
    implements _$$_AFKMarkerCopyWith<$Res> {
  __$$_AFKMarkerCopyWithImpl(
      _$_AFKMarker _value, $Res Function(_$_AFKMarker) _then)
      : super(_value, (v) => _then(v as _$_AFKMarker));

  @override
  _$_AFKMarker get _value => super._value as _$_AFKMarker;

  @override
  $Res call({
    Object? id = freezed,
    Object? qrCodeId = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? markerStatus = freezed,
    Object? repeatable = freezed,
  }) {
    return _then(_$_AFKMarker(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeId: qrCodeId == freezed
          ? _value.qrCodeId
          : qrCodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      markerStatus: markerStatus == freezed
          ? _value.markerStatus
          : markerStatus // ignore: cast_nullable_to_non_nullable
              as MarkerStatus,
      repeatable: repeatable == freezed
          ? _value.repeatable
          : repeatable // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AFKMarker implements _AFKMarker {
  _$_AFKMarker(
      {required this.id,
      this.qrCodeId,
      this.lat,
      this.lon,
      this.markerStatus = MarkerStatus.testing,
      this.repeatable = 0});

  factory _$_AFKMarker.fromJson(Map<String, dynamic> json) =>
      _$$_AFKMarkerFromJson(json);

  @override
  final String id;
  @override
  final String? qrCodeId;
  @override
  final double? lat;
  @override
  final double? lon;
  @override
  @JsonKey()
  final MarkerStatus markerStatus;
  @override
  @JsonKey()
  final int repeatable;

  @override
  String toString() {
    return 'AFKMarker(id: $id, qrCodeId: $qrCodeId, lat: $lat, lon: $lon, markerStatus: $markerStatus, repeatable: $repeatable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AFKMarker &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.qrCodeId, qrCodeId) &&
            const DeepCollectionEquality().equals(other.lat, lat) &&
            const DeepCollectionEquality().equals(other.lon, lon) &&
            const DeepCollectionEquality()
                .equals(other.markerStatus, markerStatus) &&
            const DeepCollectionEquality()
                .equals(other.repeatable, repeatable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(qrCodeId),
      const DeepCollectionEquality().hash(lat),
      const DeepCollectionEquality().hash(lon),
      const DeepCollectionEquality().hash(markerStatus),
      const DeepCollectionEquality().hash(repeatable));

  @JsonKey(ignore: true)
  @override
  _$$_AFKMarkerCopyWith<_$_AFKMarker> get copyWith =>
      __$$_AFKMarkerCopyWithImpl<_$_AFKMarker>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AFKMarkerToJson(
      this,
    );
  }
}

abstract class _AFKMarker implements AFKMarker {
  factory _AFKMarker(
      {required final String id,
      final String? qrCodeId,
      final double? lat,
      final double? lon,
      final MarkerStatus markerStatus,
      final int repeatable}) = _$_AFKMarker;

  factory _AFKMarker.fromJson(Map<String, dynamic> json) =
      _$_AFKMarker.fromJson;

  @override
  String get id;
  @override
  String? get qrCodeId;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  MarkerStatus get markerStatus;
  @override
  int get repeatable;
  @override
  @JsonKey(ignore: true)
  _$$_AFKMarkerCopyWith<_$_AFKMarker> get copyWith =>
      throw _privateConstructorUsedError;
}
