import 'dart:io';

import 'package:dio/dio.dart';

class RequestCancelled implements NetworkExceptionsService {
  const RequestCancelled();
}

class UnauthorisedRequest implements NetworkExceptionsService {
  const UnauthorisedRequest();
}

class BadRequest implements NetworkExceptionsService {
  const BadRequest();
}

class NotFound implements NetworkExceptionsService {
  final String reason;

  const NotFound(this.reason);
}

class MethodNotAllowed implements NetworkExceptionsService {
  const MethodNotAllowed();
}

class NotAcceptable implements NetworkExceptionsService {
  const NotAcceptable();
}

class UnexpectedError implements NetworkExceptionsService {
  const UnexpectedError();
}

class DefaultError implements NetworkExceptionsService {
  final String error;

  const DefaultError(this.error);
}

class UnableToProcess implements NetworkExceptionsService {
  const UnableToProcess();
}

class NoInternetConnection implements NetworkExceptionsService {
  const NoInternetConnection();
}

class FormatException implements NetworkExceptionsService {
  const FormatException();
}

class ServiceUnavailable implements NetworkExceptionsService {
  const ServiceUnavailable();
}

class NotImplemented implements NetworkExceptionsService {
  const NotImplemented();
}

class InternalServerError implements NetworkExceptionsService {
  const InternalServerError();
}

class Conflict implements NetworkExceptionsService {
  const Conflict();
}

class SendTimeout implements NetworkExceptionsService {
  const SendTimeout();
}

class RequestTimeout implements NetworkExceptionsService {
  const RequestTimeout();
}

class NetworkExceptionsService {
  const NetworkExceptionsService();

  const factory NetworkExceptionsService.requestCancelled() = RequestCancelled;

  const factory NetworkExceptionsService.unauthorisedRequest() = UnauthorisedRequest;

  const factory NetworkExceptionsService.badRequest() = BadRequest;

  const factory NetworkExceptionsService.notFound(String reason) = NotFound;

  const factory NetworkExceptionsService.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptionsService.notAcceptable() = NotAcceptable;

  const factory NetworkExceptionsService.requestTimeout() = RequestTimeout;

  const factory NetworkExceptionsService.sendTimeout() = SendTimeout;

  const factory NetworkExceptionsService.conflict() = Conflict;

  const factory NetworkExceptionsService.internalServerError() = InternalServerError;

  const factory NetworkExceptionsService.notImplemented() = NotImplemented;

  const factory NetworkExceptionsService.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptionsService.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptionsService.formatException() = FormatException;

  const factory NetworkExceptionsService.unableToProcess() = UnableToProcess;

  const factory NetworkExceptionsService.defaultError(String error) = DefaultError;

  const factory NetworkExceptionsService.unexpectedError() = UnexpectedError;

  static NetworkExceptionsService getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptionsService? networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptionsService.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptionsService.requestTimeout();
              break;
            case DioExceptionType.unknown:
              networkExceptions =
                  const NetworkExceptionsService.noInternetConnection();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptionsService.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  networkExceptions = const NetworkExceptionsService.badRequest();
                  break;
                case 401:
                  networkExceptions =
                      const NetworkExceptionsService.unauthorisedRequest();
                  break;
                case 403:
                  networkExceptions =
                      const NetworkExceptionsService.unauthorisedRequest();
                  break;
                case 404:
                  networkExceptions =
                      const NetworkExceptionsService.notFound("Not found");
                  break;
                case 409:
                  networkExceptions = const NetworkExceptionsService.conflict();
                  break;
                case 408:
                  networkExceptions = const NetworkExceptionsService.requestTimeout();
                  break;
                case 500:
                  networkExceptions =
                      const NetworkExceptionsService.internalServerError();
                  break;
                case 503:
                  networkExceptions =
                      const NetworkExceptionsService.serviceUnavailable();
                  break;
                default:
                  var responseCode = error.response!.statusCode;
                  networkExceptions = NetworkExceptionsService.defaultError(
                    "Received invalid status code: $responseCode",
                  );
              }
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptionsService.sendTimeout();
              break;
            default:
              networkExceptions = const NetworkExceptionsService.badRequest();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptionsService.noInternetConnection();
        } else {
          networkExceptions = const NetworkExceptionsService.unexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (_) {
        return const NetworkExceptionsService.formatException();
      } catch (_) {
        return const NetworkExceptionsService.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptionsService.unableToProcess();
      } else {
        return const NetworkExceptionsService.unexpectedError();
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

  static String getErrorMessage(NetworkExceptionsService networkExceptions) {
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
