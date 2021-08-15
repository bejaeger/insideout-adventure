import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class MapViewModel extends BaseViewModel {
  final CameraPosition position = CameraPosition(
    target: LatLng(41.9028, 12.4964),
    zoom: 12,
  );
}
