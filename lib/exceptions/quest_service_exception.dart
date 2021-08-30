class QuestServiceException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  QuestServiceException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'QuestServiceException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
