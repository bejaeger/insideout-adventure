// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Marker _$MarkerFromJson(Map<String, dynamic> json) {
  return _Marker.fromJson(json);
}

/// @nodoc
class _$MarkerTearOff {
  const _$MarkerTearOff();

  _Marker call(
      {required String id,
      required String qrCodeId,
      required double lat,
      required double lon,
      MarkerStatus markerStatus = MarkerStatus.testing}) {
    return _Marker(
      id: id,
      qrCodeId: qrCodeId,
      lat: lat,
      lon: lon,
      markerStatus: markerStatus,
    );
  }

  Marker fromJson(Map<String, Object> json) {
    return Marker.fromJson(json);
  }
}

/// @nodoc
const $Marker = _$MarkerTearOff();

/// @nodoc
mixin _$Marker {
  String get id => throw _privateConstructorUsedError;
  String get qrCodeId => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lon => throw _privateConstructorUsedError;
  MarkerStatus get markerStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarkerCopyWith<Marker> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkerCopyWith<$Res> {
  factory $MarkerCopyWith(Marker value, $Res Function(Marker) then) =
      _$MarkerCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String qrCodeId,
      double lat,
      double lon,
      MarkerStatus markerStatus});
}

/// @nodoc
class _$MarkerCopyWithImpl<$Res> implements $MarkerCopyWith<$Res> {
  _$MarkerCopyWithImpl(this._value, this._then);

  final Marker _value;
  // ignore: unused_field
  final $Res Function(Marker) _then;

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
              as String,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      markerStatus: markerStatus == freezed
          ? _value.markerStatus
          : markerStatus // ignore: cast_nullable_to_non_nullable
              as MarkerStatus,
    ));
  }
}

/// @nodoc
abstract class _$MarkerCopyWith<$Res> implements $MarkerCopyWith<$Res> {
  factory _$MarkerCopyWith(_Marker value, $Res Function(_Marker) then) =
      __$MarkerCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String qrCodeId,
      double lat,
      double lon,
      MarkerStatus markerStatus});
}

/// @nodoc
class __$MarkerCopyWithImpl<$Res> extends _$MarkerCopyWithImpl<$Res>
    implements _$MarkerCopyWith<$Res> {
  __$MarkerCopyWithImpl(_Marker _value, $Res Function(_Marker) _then)
      : super(_value, (v) => _then(v as _Marker));

  @override
  _Marker get _value => super._value as _Marker;

  @override
  $Res call({
    Object? id = freezed,
    Object? qrCodeId = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? markerStatus = freezed,
  }) {
    return _then(_Marker(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeId: qrCodeId == freezed
          ? _value.qrCodeId
          : qrCodeId // ignore: cast_nullable_to_non_nullable
              as String,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      markerStatus: markerStatus == freezed
          ? _value.markerStatus
          : markerStatus // ignore: cast_nullable_to_non_nullable
              as MarkerStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Marker implements _Marker {
  _$_Marker(
      {required this.id,
      required this.qrCodeId,
      required this.lat,
      required this.lon,
      this.markerStatus = MarkerStatus.testing});

  factory _$_Marker.fromJson(Map<String, dynamic> json) =>
      _$_$_MarkerFromJson(json);

  @override
  final String id;
  @override
  final String qrCodeId;
  @override
  final double lat;
  @override
  final double lon;
  @JsonKey(defaultValue: MarkerStatus.testing)
  @override
  final MarkerStatus markerStatus;

  @override
  String toString() {
    return 'Marker(id: $id, qrCodeId: $qrCodeId, lat: $lat, lon: $lon, markerStatus: $markerStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Marker &&
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
  _$MarkerCopyWith<_Marker> get copyWith =>
      __$MarkerCopyWithImpl<_Marker>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MarkerToJson(this);
  }
}

abstract class _Marker implements Marker {
  factory _Marker(
      {required String id,
      required String qrCodeId,
      required double lat,
      required double lon,
      MarkerStatus markerStatus}) = _$_Marker;

  factory _Marker.fromJson(Map<String, dynamic> json) = _$_Marker.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get qrCodeId => throw _privateConstructorUsedError;
  @override
  double get lat => throw _privateConstructorUsedError;
  @override
  double get lon => throw _privateConstructorUsedError;
  @override
  MarkerStatus get markerStatus => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MarkerCopyWith<_Marker> get copyWith => throw _privateConstructorUsedError;
}
