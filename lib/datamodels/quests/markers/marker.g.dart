// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AFKMarker _$_$_AFKMarkerFromJson(Map<String, dynamic> json) {
  return _$_AFKMarker(
    id: json['id'] as String,
    qrCodeId: json['qrCodeId'] as String,
    lat: (json['lat'] as num?)?.toDouble(),
    lon: (json['lon'] as num?)?.toDouble(),
    markerStatus:
        _$enumDecodeNullable(_$MarkerStatusEnumMap, json['markerStatus']) ??
            MarkerStatus.testing,
  );
}

Map<String, dynamic> _$_$_AFKMarkerToJson(_$_AFKMarker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qrCodeId': instance.qrCodeId,
      'lat': instance.lat,
      'lon': instance.lon,
      'markerStatus': _$MarkerStatusEnumMap[instance.markerStatus],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MarkerStatusEnumMap = {
  MarkerStatus.testing: 'testing',
  MarkerStatus.placed: 'placed',
};
