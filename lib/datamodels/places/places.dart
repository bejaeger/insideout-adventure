import 'package:freezed_annotation/freezed_annotation.dart';

part 'places.freezed.dart';
part 'places.g.dart';

@freezed
class Places with _$Places {
  factory Places({
    required String id,
    String? name,
    double? lat,
    double? lon,
    String? image,
  }) = _Places;
  factory Places.fromJson(Map<String, dynamic> json) => _$PlacesFromJson(json);
}
