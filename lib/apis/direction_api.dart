import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsAPI {
  final log = getLogger('DirectionsAPI');
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final EnvironmentService _environmentService = locator<EnvironmentService>();

  final Dio _dio;

  DirectionsAPI({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': _environmentService.getValue(GoogleMapsEnvKey),
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
