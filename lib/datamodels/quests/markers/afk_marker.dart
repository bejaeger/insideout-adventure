import 'package:afkcredits/enums/marker_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'afk_marker.freezed.dart';
part 'afk_marker.g.dart';

@freezed
class AFKMarker with _$AFKMarker {
  factory AFKMarker({
    required String id,
    String? qrCodeId,
    double? lat,
    double? lon,
    @Default(MarkerStatus.testing) MarkerStatus markerStatus, /* legacy */
    @Default(0) int repeatable,
  }) = _AFKMarker;

  factory AFKMarker.fromJson(Map<String, dynamic> json) =>
      _$AFKMarkerFromJson(json);
}
