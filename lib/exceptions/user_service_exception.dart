class UserServiceException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  UserServiceException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'UserDataServiceException (in-house exception): $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
