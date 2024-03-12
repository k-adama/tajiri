import 'package:tajiri_pos_mobile/app/services/api_result.service.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/network_exceptions.service.dart';

class OrdersRepository {
  HttpService server = HttpService();

  @override
  Future<ApiResultService<dynamic>> getOrders(
      String? startDate, String? endDate, String? ownerId) async {
    final queryParameters = {
      'startDate': startDate,
      'endDate': endDate,
      'ownerId': ownerId,
    };
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response =
          await client.get('/orders/', queryParameters: queryParameters);

      return ApiResultService.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  @override
  Future<ApiResultService<dynamic>> getOrdersReports(
      String? startDate, String? endDate, String? ownerId) async {
    final queryParameters = {
      'startDate': startDate,
      'endDate': endDate,
      'ownerId': ownerId,
    };

    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get('/orders/reports/',
          queryParameters: queryParameters);
      return ApiResultService.success(data: response.data);
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<dynamic>> updateOrder(dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/orders/${id}/',
        data: data,
      );

      return ApiResultService.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }
}
