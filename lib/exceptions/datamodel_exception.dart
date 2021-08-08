class DataModelException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  DataModelException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'DataModelException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
