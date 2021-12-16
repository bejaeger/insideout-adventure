// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'afk_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AFKMarker _$$_AFKMarkerFromJson(Map<String, dynamic> json) => _$_AFKMarker(
      id: json['id'] as String,
      qrCodeId: json['qrCodeId'] as String,
      nextLocationSolution: json['nextLocationSolution'] as String?,
      nextLocationHint: json['nextLocationHint'] as String?,
      nextLocationPictureHint: json['nextLocationPictureHint'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      markerStatus:
          $enumDecodeNullable(_$MarkerStatusEnumMap, json['markerStatus']) ??
              MarkerStatus.testing,
    );

Map<String, dynamic> _$$_AFKMarkerToJson(_$_AFKMarker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qrCodeId': instance.qrCodeId,
      'nextLocationSolution': instance.nextLocationSolution,
      'nextLocationHint': instance.nextLocationHint,
      'nextLocationPictureHint': instance.nextLocationPictureHint,
      'lat': instance.lat,
      'lon': instance.lon,
      'markerStatus': _$MarkerStatusEnumMap[instance.markerStatus],
    };

const _$MarkerStatusEnumMap = {
  MarkerStatus.testing: 'testing',
  MarkerStatus.placed: 'placed',
};
