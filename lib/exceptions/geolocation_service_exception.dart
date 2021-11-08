class GeolocationServiceException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  GeolocationServiceException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'GeolocationServiceException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
