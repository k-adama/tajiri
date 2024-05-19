import 'network_exceptions.service.dart';

class ApiResultService<T> {
  final T? data;
  final NetworkExceptionsService error;
  final int statusCode;

  const ApiResultService.success({required this.data})
      : error = const NetworkExceptionsService(),
        statusCode = 200;

  const ApiResultService.failure(
      {required this.error, required this.statusCode})
      : data = null;

  R when<R>({
    required R Function(T? data) success,
    required R Function(NetworkExceptionsService error, int statusCode) failure,
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
