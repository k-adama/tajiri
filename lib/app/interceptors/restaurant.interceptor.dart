import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:Tajiri/app/config/constants/user.constant.dart';
import 'package:Tajiri/app/services/local_storage.service.dart';
import 'package:Tajiri/domain/entities/user.entity.dart';

class RestaurantInterceptor extends Interceptor {
  final bool requireRestaurantId;

  RestaurantInterceptor({required this.requireRestaurantId});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (requireRestaurantId) {
      final String userEncoding = LocalStorageService.instance.get(UserConstant.keyUser) ?? "";
      final UserEntity userDecoding = jsonDecode(userEncoding);
      final String restaurantId = userDecoding.restaurantUser![0].restaurantId ?? "";
      if (restaurantId.isNotEmpty) {
        options.headers.addAll({'restaurantId': restaurantId});
      }
    }
    handler.next(options);
  }
}
