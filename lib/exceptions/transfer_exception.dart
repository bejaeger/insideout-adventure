class MoneyTransferException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  MoneyTransferException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'MoneyTransferException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
