// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'afk_marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AFKMarker _$AFKMarkerFromJson(Map<String, dynamic> json) {
  return _AFKMarker.fromJson(json);
}

/// @nodoc
class _$AFKMarkerTearOff {
  const _$AFKMarkerTearOff();

  _AFKMarker call(
      {required String id,
      String? qrCodeId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus = MarkerStatus.testing}) {
    return _AFKMarker(
      id: id,
      qrCodeId: qrCodeId,
      lat: lat,
      lon: lon,
      markerStatus: markerStatus,
    );
  }

  AFKMarker fromJson(Map<String, Object> json) {
    return AFKMarker.fromJson(json);
  }
}

/// @nodoc
const $AFKMarker = _$AFKMarkerTearOff();

/// @nodoc
mixin _$AFKMarker {
  String get id => throw _privateConstructorUsedError;
  String? get qrCodeId => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  MarkerStatus get markerStatus => throw _privateConstructorUsedError;

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
      MarkerStatus markerStatus});
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
    ));
  }
}

/// @nodoc
abstract class _$AFKMarkerCopyWith<$Res> implements $AFKMarkerCopyWith<$Res> {
  factory _$AFKMarkerCopyWith(
          _AFKMarker value, $Res Function(_AFKMarker) then) =
      __$AFKMarkerCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String? qrCodeId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus});
}

/// @nodoc
class __$AFKMarkerCopyWithImpl<$Res> extends _$AFKMarkerCopyWithImpl<$Res>
    implements _$AFKMarkerCopyWith<$Res> {
  __$AFKMarkerCopyWithImpl(_AFKMarker _value, $Res Function(_AFKMarker) _then)
      : super(_value, (v) => _then(v as _AFKMarker));

  @override
  _AFKMarker get _value => super._value as _AFKMarker;

  @override
  $Res call({
    Object? id = freezed,
    Object? qrCodeId = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? markerStatus = freezed,
  }) {
    return _then(_AFKMarker(
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
      this.markerStatus = MarkerStatus.testing});

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
  @JsonKey(defaultValue: MarkerStatus.testing)
  @override
  final MarkerStatus markerStatus;

  @override
  String toString() {
    return 'AFKMarker(id: $id, qrCodeId: $qrCodeId, lat: $lat, lon: $lon, markerStatus: $markerStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AFKMarker &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.qrCodeId, qrCodeId) ||
                const DeepCollectionEquality()
                    .equals(other.qrCodeId, qrCodeId)) &&
            (identical(other.lat, lat) ||
                const DeepCollectionEquality().equals(other.lat, lat)) &&
            (identical(other.lon, lon) ||
                const DeepCollectionEquality().equals(other.lon, lon)) &&
            (identical(other.markerStatus, markerStatus) ||
                const DeepCollectionEquality()
                    .equals(other.markerStatus, markerStatus)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(qrCodeId) ^
      const DeepCollectionEquality().hash(lat) ^
      const DeepCollectionEquality().hash(lon) ^
      const DeepCollectionEquality().hash(markerStatus);

  @JsonKey(ignore: true)
  @override
  _$AFKMarkerCopyWith<_AFKMarker> get copyWith =>
      __$AFKMarkerCopyWithImpl<_AFKMarker>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AFKMarkerToJson(this);
  }
}

abstract class _AFKMarker implements AFKMarker {
  factory _AFKMarker(
      {required String id,
      String? qrCodeId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus}) = _$_AFKMarker;

  factory _AFKMarker.fromJson(Map<String, dynamic> json) =
      _$_AFKMarker.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String? get qrCodeId => throw _privateConstructorUsedError;
  @override
  double? get lat => throw _privateConstructorUsedError;
  @override
  double? get lon => throw _privateConstructorUsedError;
  @override
  MarkerStatus get markerStatus => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AFKMarkerCopyWith<_AFKMarker> get copyWith =>
      throw _privateConstructorUsedError;
}
