class CloudFunctionsApiException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  CloudFunctionsApiException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'CloudFunctionApiException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}