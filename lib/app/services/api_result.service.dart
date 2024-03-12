import 'network_exceptions.dart';

class ApiResult<T> {
  final T? data;
  final NetworkExceptions error;
  final int statusCode;

  const ApiResult.success({required this.data})
      : error = const NetworkExceptions(),
        statusCode = 200;

  const ApiResult.failure({required this.error, required this.statusCode})
      : data = null;

  R when<R>({
    required R Function(T? data) success,
    required R Function(NetworkExceptions error, int statusCode) failure,
  }) {
    if (this.data != null) {
      return success(this.data);
    } else if (this.error != null && this.statusCode != null) {
      return failure(this.error, this.statusCode);
    } else {
      throw Exception('Invalid ApiResult type');
    }
  }
}
