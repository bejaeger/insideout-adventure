enum AuthExceptions {
  invalidEmail('Invalid email'),
  emailRequired('Email is required'),
  invalidName('Invalid name'),
  emptyName('Name cannot not be empty'),
  emalAlreadyInUse('Email already in use'),
  weakPassword('Password too weak.  It should be at least 6 characters '),
  wrongPassword('Wrong password'),
  emptyPassword('Empty password'),
  timeRequired('No time set'),
  timeNotPosInt('Time needs to be a positive number');

  const AuthExceptions(this.message);
  final String message;
}

enum StatusCode {
  badRequest(401, 'Bad request'),
  unauthorized(401, 'Unauthorized'),
  forbidden(403, 'Forbidden'),
  notFound(404, 'Not found'),
  internalServerError(500, 'Internal server error'),
  notImplemented(501, 'Not implemented');

  const StatusCode(this.code, this.description);
  final int code;
  final String description;

  @override
  String toString() => 'StatusCode($code, $description)';
}
