// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Markers _$MarkersFromJson(Map<String, dynamic> json) {
  return _Markers.fromJson(json);
}

/// @nodoc
class _$MarkersTearOff {
  const _$MarkersTearOff();

  _Markers call(
      {required String id,
      required String qrCodeId,
      String? questId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus = MarkerStatus.testing}) {
    return _Markers(
      id: id,
      qrCodeId: qrCodeId,
      questId: questId,
      lat: lat,
      lon: lon,
      markerStatus: markerStatus,
    );
  }

  Markers fromJson(Map<String, Object> json) {
    return Markers.fromJson(json);
  }
}

/// @nodoc
const $Markers = _$MarkersTearOff();

/// @nodoc
mixin _$Markers {
  String get id => throw _privateConstructorUsedError;
  String get qrCodeId => throw _privateConstructorUsedError;
  String? get questId => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  MarkerStatus get markerStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarkersCopyWith<Markers> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkersCopyWith<$Res> {
  factory $MarkersCopyWith(Markers value, $Res Function(Markers) then) =
      _$MarkersCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String qrCodeId,
      String? questId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus});
}

/// @nodoc
class _$MarkersCopyWithImpl<$Res> implements $MarkersCopyWith<$Res> {
  _$MarkersCopyWithImpl(this._value, this._then);

  final Markers _value;
  // ignore: unused_field
  final $Res Function(Markers) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? qrCodeId = freezed,
    Object? questId = freezed,
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
      questId: questId == freezed
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
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
abstract class _$MarkersCopyWith<$Res> implements $MarkersCopyWith<$Res> {
  factory _$MarkersCopyWith(_Markers value, $Res Function(_Markers) then) =
      __$MarkersCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String qrCodeId,
      String? questId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus});
}

/// @nodoc
class __$MarkersCopyWithImpl<$Res> extends _$MarkersCopyWithImpl<$Res>
    implements _$MarkersCopyWith<$Res> {
  __$MarkersCopyWithImpl(_Markers _value, $Res Function(_Markers) _then)
      : super(_value, (v) => _then(v as _Markers));

  @override
  _Markers get _value => super._value as _Markers;

  @override
  $Res call({
    Object? id = freezed,
    Object? qrCodeId = freezed,
    Object? questId = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? markerStatus = freezed,
  }) {
    return _then(_Markers(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeId: qrCodeId == freezed
          ? _value.qrCodeId
          : qrCodeId // ignore: cast_nullable_to_non_nullable
              as String,
      questId: questId == freezed
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
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
class _$_Markers implements _Markers {
  _$_Markers(
      {required this.id,
      required this.qrCodeId,
      this.questId,
      this.lat,
      this.lon,
      this.markerStatus = MarkerStatus.testing});

  factory _$_Markers.fromJson(Map<String, dynamic> json) =>
      _$_$_MarkersFromJson(json);

  @override
  final String id;
  @override
  final String qrCodeId;
  @override
  final String? questId;
  @override
  final double? lat;
  @override
  final double? lon;
  @JsonKey(defaultValue: MarkerStatus.testing)
  @override
  final MarkerStatus markerStatus;

  @override
  String toString() {
    return 'Markers(id: $id, qrCodeId: $qrCodeId, questId: $questId, lat: $lat, lon: $lon, markerStatus: $markerStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Markers &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.qrCodeId, qrCodeId) ||
                const DeepCollectionEquality()
                    .equals(other.qrCodeId, qrCodeId)) &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality()
                    .equals(other.questId, questId)) &&
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
      const DeepCollectionEquality().hash(questId) ^
      const DeepCollectionEquality().hash(lat) ^
      const DeepCollectionEquality().hash(lon) ^
      const DeepCollectionEquality().hash(markerStatus);

  @JsonKey(ignore: true)
  @override
  _$MarkersCopyWith<_Markers> get copyWith =>
      __$MarkersCopyWithImpl<_Markers>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MarkersToJson(this);
  }
}

abstract class _Markers implements Markers {
  factory _Markers(
      {required String id,
      required String qrCodeId,
      String? questId,
      double? lat,
      double? lon,
      MarkerStatus markerStatus}) = _$_Markers;

  factory _Markers.fromJson(Map<String, dynamic> json) = _$_Markers.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get qrCodeId => throw _privateConstructorUsedError;
  @override
  String? get questId => throw _privateConstructorUsedError;
  @override
  double? get lat => throw _privateConstructorUsedError;
  @override
  double? get lon => throw _privateConstructorUsedError;
  @override
  MarkerStatus get markerStatus => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MarkersCopyWith<_Markers> get copyWith =>
      throw _privateConstructorUsedError;
}
