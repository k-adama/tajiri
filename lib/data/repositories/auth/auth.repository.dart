import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/services/api_result.service.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/network_exceptions.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/login.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/login_response.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';

class AuthRepository{
  HttpService server = HttpService();

  Future<ApiResultService<LoginResponseEntity>> login({
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
      return ApiResultService.success(
        data: LoginResponseEntity.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> login failure: $e');
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<UserEntity>> getProfileDetails() async {
    try {
      final client = server.client(requireAuth: true);
      final response = await client.get(
        '/users/me/',
      );
      debugPrint(response.data.toString());
      return ApiResultService.success(
        data: UserEntity.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get user details failure: $e');
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<LoginResponseEntity>> demoSend({
    required String phone,
    required String name,
  }) async {
    try {
      final client =
          server.client(requireAuth: false, requireRestaurantId: false);
      final response = await client.post(
        '/auth/demo/',
        data: {"name": name, "phone": phone},
      );
      return ApiResultService.success(
        data: LoginResponseEntity.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> login failure: $e');
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

}