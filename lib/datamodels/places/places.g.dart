// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Places _$_$_PlacesFromJson(Map<String, dynamic> json) {
  return _$_Places(
    id: json['id'] as String,
    name: json['name'] as String?,
    lat: (json['lat'] as num?)?.toDouble(),
    lon: (json['lon'] as num?)?.toDouble(),
    image: json['image'] as String?,
    questId: json['questId'] as String?,
  );
}

Map<String, dynamic> _$_$_PlacesToJson(_$_Places instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'image': instance.image,
      'questId': instance.questId,
    };
