import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/services/api_result.service.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/network_exceptions.dart';
import 'package:tajiri_pos_mobile/domain/entities/login.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/login_response.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';

class AuthRepository{
  HttpService server = HttpService();

  Future<ApiResult<LoginResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    final data = LoginEntity(email: email, password: password);
    try {
      final client =
          server.client(requireAuth: false, requireRestaurantId: false);
      final response = await client.post(
        '/auth/login/',
        data: data,
      );
      return ApiResult.success(
        data: LoginResponseEntity.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> login failure: $e');
      return ApiResult.failure(
          error: NetworkExceptions.getDioException(e),
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  Future<ApiResult<UserEntity>> getProfileDetails() async {
    try {
      final client = server.client(requireAuth: true);
      final response = await client.get(
        '/users/me/',
      );
      debugPrint(response.data.toString());
      return ApiResult.success(
        data: UserEntity.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get user details failure: $e');
      return ApiResult.failure(
          error: NetworkExceptions.getDioException(e),
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

}