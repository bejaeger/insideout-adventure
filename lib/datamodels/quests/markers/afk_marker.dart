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
    @Default(MarkerStatus.testing) MarkerStatus markerStatus,
    @Default(0) int repeatable,
  }) = _AFKMarker;

  factory AFKMarker.fromJson(Map<String, dynamic> json) =>
      _$AFKMarkerFromJson(json);
}

/* class AfkMarkersPositions {
  String? documentId;
  GeoFirePoint? point;
  // GeoPoint? point;

  AfkMarkersPositions({required this.documentId, required this.point});

  AfkMarkersPositions.fromJson(Map<String, dynamic> json) {
    try {
      documentId = json['documentId'];
      point = json['point']!['geopoint'];
      //point = json['point'];

    } catch (e) {
      e.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['documentId'] = this.documentId;
    data['point'] = this.point!.data;
    return data;
  }
} */
