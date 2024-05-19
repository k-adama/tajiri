import 'package:tajiri_pos_mobile/app/services/api_result.service.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/network_exceptions.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/waitress.entity.dart';

class WaitressRepository {
  HttpService server = HttpService();

  Future<ApiResultService<List<WaitressEntity>>> getWaitress() async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/restaurants/waitress/',
      );
      final json = response.data as List<dynamic>;
      final waitressData =
          json.map((item) => WaitressEntity.fromJson(item)).toList();

      return ApiResultService.success(
        data: waitressData,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<WaitressEntity>> createWaitress(dynamic data) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.post(
        '/restaurants/waitress/',
        data: data,
      );

      return ApiResultService.success(
        data: WaitressEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<WaitressEntity>> updateWaitress(
      dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/restaurants/waitress/$id',
        data: data,
      );

      return ApiResultService.success(
        data: WaitressEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<WaitressEntity>> deleteWaitress(String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.delete(
        '/restaurants/waitress/$id',
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
