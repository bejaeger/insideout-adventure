import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_fav_places.freezed.dart';
part 'user_fav_places.g.dart';

@freezed
class UserFavPlaces with _$UserFavPlaces {
  factory UserFavPlaces({
    required String id,
    String? name,
    double? lat,
    double? lon,
    String? image,
  }) = _UserFavPlaces;
  factory UserFavPlaces.fromJson(Map<String, dynamic> json) =>
      _$UserFavPlacesFromJson(json);
}
