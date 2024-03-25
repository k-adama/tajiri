import 'package:tajiri_pos_mobile/app/services/api_result.service.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/network_exceptions.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/table.entiy.dart';

class TablesRepository {
  HttpService server = HttpService();

  Future<ApiResultService<List<TableEntity>>> getTables() async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/restaurants/tables/',
      );
      final json = response.data as List<dynamic>;
      final tableData = json.map((item) => TableEntity.fromJson(item)).toList();
      return ApiResultService.success(
        data: tableData,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<TableEntity>> createTable(dynamic data) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.post(
        '/restaurants/tables/',
        data: data,
      );

      return ApiResultService.success(
        data: TableEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<TableEntity>> updateTable(
      dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/restaurants/tables/${id}',
        data: data,
      );

      return ApiResultService.success(
        data: TableEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<TableEntity>> deleteTable(String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.delete(
        '/restaurants/tables/$id',
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
