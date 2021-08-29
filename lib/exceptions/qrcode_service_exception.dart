class QRCodeServiceException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  QRCodeServiceException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'QRCodeService (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
