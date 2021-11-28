// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_fav_places.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserFavPlaces _$$_UserFavPlacesFromJson(Map<String, dynamic> json) =>
    _$_UserFavPlaces(
      id: json['id'] as String,
      name: json['name'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$_UserFavPlacesToJson(_$_UserFavPlaces instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'image': instance.image,
    };
