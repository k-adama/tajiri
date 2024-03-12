import 'dart:io';

import 'package:dio/dio.dart';

class RequestCancelled implements NetworkExceptions {
  const RequestCancelled();
}

class UnauthorisedRequest implements NetworkExceptions {
  const UnauthorisedRequest();
}

class BadRequest implements NetworkExceptions {
  const BadRequest();
}

class NotFound implements NetworkExceptions {
  final String reason;

  const NotFound(this.reason);
}

class MethodNotAllowed implements NetworkExceptions {
  const MethodNotAllowed();
}

class NotAcceptable implements NetworkExceptions {
  const NotAcceptable();
}

class UnexpectedError implements NetworkExceptions {
  const UnexpectedError();
}

class DefaultError implements NetworkExceptions {
  final String error;

  const DefaultError(this.error);
}

class UnableToProcess implements NetworkExceptions {
  const UnableToProcess();
}

class NoInternetConnection implements NetworkExceptions {
  const NoInternetConnection();
}

class FormatException implements NetworkExceptions {
  const FormatException();
}

class ServiceUnavailable implements NetworkExceptions {
  const ServiceUnavailable();
}

class NotImplemented implements NetworkExceptions {
  const NotImplemented();
}

class InternalServerError implements NetworkExceptions {
  const InternalServerError();
}

class Conflict implements NetworkExceptions {
  const Conflict();
}

class SendTimeout implements NetworkExceptions {
  const SendTimeout();
}

class RequestTimeout implements NetworkExceptions {
  const RequestTimeout();
}

class NetworkExceptions {
  const NetworkExceptions();

  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorisedRequest() = UnauthorisedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions? networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  networkExceptions = const NetworkExceptions.badRequest();
                  break;
                case 401:
                  networkExceptions =
                      const NetworkExceptions.unauthorisedRequest();
                  break;
                case 403:
                  networkExceptions =
                      const NetworkExceptions.unauthorisedRequest();
                  break;
                case 404:
                  networkExceptions =
                      const NetworkExceptions.notFound("Not found");
                  break;
                case 409:
                  networkExceptions = const NetworkExceptions.conflict();
                  break;
                case 408:
                  networkExceptions = const NetworkExceptions.requestTimeout();
                  break;
                case 500:
                  networkExceptions =
                      const NetworkExceptions.internalServerError();
                  break;
                case 503:
                  networkExceptions =
                      const NetworkExceptions.serviceUnavailable();
                  break;
                default:
                  var responseCode = error.response!.statusCode;
                  networkExceptions = NetworkExceptions.defaultError(
                    "Received invalid status code: $responseCode",
                  );
              }
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            default:
              networkExceptions = const NetworkExceptions.badRequest();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (_) {
        return const NetworkExceptions.formatException();
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static int getDioStatus(error) {
    if (error is Exception) {
      try {
        int? status;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              status = 500;
              break;
            case DioExceptionType.connectionTimeout:
              status = 500;
              break;
            case DioExceptionType.unknown:
              status = 500;
              break;
            case DioExceptionType.receiveTimeout:
              status = 500;
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  status = 400;
                  break;
                case 401:
                  status = 401;
                  break;
                case 403:
                  status = 403;
                  break;
                case 404:
                  status = 404;
                  break;
                case 409:
                  status = 409;
                  break;
                case 422:
                  status = 422;
                  break;
                case 408:
                  status = 408;
                  break;
                case 500:
                  status = 500;
                  break;
                case 503:
                  status = 503;
                  break;
                default:
                  status = 500;
              }
              break;
            case DioExceptionType.sendTimeout:
              status = 500;
              break;
            case DioExceptionType.badCertificate:
              status = 500;
              break;
            default:
              status = 500;
              break;
          }

        } else if (error is SocketException) {
          status = 500;
        } else {
          status = 500;
        }
        return status;
      } on FormatException catch (_) {
        return 500;
      } catch (_) {
        return 500;
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return 500;
      } else {
        return 500;
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";
    if (networkExceptions is RequestCancelled) {
      errorMessage = "Request Cancelled";
    } else if (networkExceptions is UnauthorisedRequest) {
      errorMessage = "Unauthorised request";
    } else if (networkExceptions is BadRequest) {
      errorMessage = "Bad request";
    } else if (networkExceptions is NotFound) {
      errorMessage = networkExceptions.reason;
    } else if (networkExceptions is MethodNotAllowed) {
      errorMessage = "Method Allowed";
    } else if (networkExceptions is NotAcceptable) {
      errorMessage = "Not acceptable";
    } else if (networkExceptions is RequestTimeout) {
      errorMessage = "Connection request timeout";
    } else if (networkExceptions is SendTimeout) {
      errorMessage = "Send timeout in connection with API server";
    } else if (networkExceptions is Conflict) {
      errorMessage = "Error due to a conflict";
    } else if (networkExceptions is InternalServerError) {
      errorMessage = "Internal Server Error";
    } else if (networkExceptions is NotImplemented) {
      errorMessage = "Not Implemented";
    } else if (networkExceptions is ServiceUnavailable) {
      errorMessage = "Service unavailable";
    } else if (networkExceptions is NoInternetConnection) {
      errorMessage = "No internet connection";
    } else if (networkExceptions is FormatException) {
      errorMessage = "Unexpected error occurred";
    } else if (networkExceptions is UnableToProcess) {
      errorMessage = "Unable to process the data";
    } else if (networkExceptions is DefaultError) {
      errorMessage = networkExceptions.error;
    } else if (networkExceptions is UnexpectedError) {
      errorMessage = "Unexpected error occurred";
    }
    return errorMessage;
  }
}
