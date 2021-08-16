class MapViewModelException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  MapViewModelException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'FirestoreApiException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
