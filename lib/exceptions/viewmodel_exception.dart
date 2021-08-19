class ViewModelException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  ViewModelException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'ViewModelException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
