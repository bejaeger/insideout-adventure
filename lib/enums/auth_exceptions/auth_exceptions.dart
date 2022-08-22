enum AuthExceptions {
  invalidEmail('Invalid Email'),
  invalidName('Invalid Name'),
  emptyName('Name Should not be Empty'),
  emalAlreadyInUse('Eamil already in use'),
  weakPassword('Password too weak !! it should be at least 6 characters '),
  wrongPassword('Wrong password'),
  emptyPassword('Empty password');

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
