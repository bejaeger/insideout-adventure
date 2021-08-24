import 'package:afkcredits/enums/marker_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marker.freezed.dart';
part 'marker.g.dart';

@freezed
class Marker with _$Marker {
  factory Marker({
    required String id,
    required String qrCodeId,
    required double lat,
    required double lon,
    @Default(MarkerStatus.testing) MarkerStatus markerStatus,
  }) = _Marker;

  factory Marker.fromJson(Map<String, dynamic> json) => _$MarkerFromJson(json);
}
