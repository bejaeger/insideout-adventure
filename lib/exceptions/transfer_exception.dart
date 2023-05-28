class TransferException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  TransferException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'TransferException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
