import 'dart:io';

enum ApiErrorType {
  unauthorized(HttpStatus.unauthorized),
  badRequest(HttpStatus.badRequest),
  forbidden(HttpStatus.forbidden),
  notFound(HttpStatus.notFound),
  methodNotAllowed(HttpStatus.methodNotAllowed),
  internalServerError(HttpStatus.internalServerError),
  other(-1);

  final int statusCode;

  const ApiErrorType(this.statusCode);
}