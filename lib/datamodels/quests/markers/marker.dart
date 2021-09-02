import 'package:afkcredits/enums/marker_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marker.freezed.dart';
part 'marker.g.dart';

@freezed
class Markers with _$Markers {
  factory Markers({
    required String id,
    required String qrCodeId,
    String? questId,
    double? lat,
    double? lon,
    @Default(MarkerStatus.testing) MarkerStatus markerStatus,
  }) = _Markers;

  factory Markers.fromJson(Map<String, dynamic> json) =>
      _$MarkersFromJson(json);
}
