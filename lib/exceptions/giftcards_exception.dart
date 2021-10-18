class GiftCardsException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  GiftCardsException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'FirestoreApiException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
