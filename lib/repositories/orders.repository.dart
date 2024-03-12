import 'package:tajiri_pos_mobile/app/services/http.service.dart';

class OrdersRepository {
  HttpService server = HttpService();

  // @override
  // Future<ApiResult<dynamic>> getOrders(
  //     String? startDate, String? endDate, String? ownerId) async {
  //   final queryParameters = {
  //     'startDate': startDate,
  //     'endDate': endDate,
  //     'ownerId': ownerId,
  //   };
  //   try {
  //     final client =
  //         server.client(requireAuth: true, requireRestaurantId: true);
  //     final response =
  //         await client.get('/orders/', queryParameters: queryParameters);

  //     return ApiResult.success(
  //       data: response.data,
  //     );
  //   } catch (e) {
  //     return ApiResult.failure(
  //         error: NetworkExceptions.getDioException(e),
  //         statusCode: NetworkExceptions.getDioStatus(e));
  //   }
  // }

  // @override
  // Future<ApiResult<dynamic>> getOrdersReports(
  //     String? startDate, String? endDate, String? ownerId) async {
  //   final queryParameters = {
  //     'startDate': startDate,
  //     'endDate': endDate,
  //     'ownerId': ownerId,
  //   };

  //   try {
  //     final client =
  //         server.client(requireAuth: true, requireRestaurantId: true);
  //     final response = await client.get('/orders/reports/',
  //         queryParameters: queryParameters);
  //     return ApiResult.success(data: response.data);
  //   } catch (e) {
  //     return ApiResult.failure(
  //         error: NetworkExceptions.getDioException(e),
  //         statusCode: NetworkExceptions.getDioStatus(e));
  //   }
  // }

  // Future<ApiResult<dynamic>> updateOrder(dynamic data, String id) async {
  //   try {
  //     final client =
  //         server.client(requireAuth: true, requireRestaurantId: false);
  //     final response = await client.put(
  //       '/orders/${id}/',
  //       data: data,
  //     );

  //     return ApiResult.success(
  //       data: response.data,
  //     );
  //   } catch (e) {
  //     return ApiResult.failure(
  //         error: NetworkExceptions.getDioException(e),
  //         statusCode: NetworkExceptions.getDioStatus(e));
  //   }
  // }
}
