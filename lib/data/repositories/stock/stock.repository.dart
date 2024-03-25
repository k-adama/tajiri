

import 'dart:convert';

import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/services/api_result.service.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/app/services/network_exceptions.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';

class StockRepository {
  HttpService server = HttpService();

  Future<ApiResultService<dynamic>> updateStockMovement(
      String id, int stock, String type) async {
    try {
      final userEncoding = LocalStorageService.instance.get(UserConstant.keyUser);
      final user = UserEntity.fromJson(jsonDecode(userEncoding!));
      String userId = user?.id ?? "";
      final data = {
        'id': id,
        'quantity': stock,
        'type': type,
        'userId': userId
      };
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        "/products/foods/$id/stock-movement",
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
