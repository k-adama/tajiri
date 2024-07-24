import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class RestaurantInterceptor extends Interceptor {
  final bool requireRestaurantId;

  RestaurantInterceptor({required this.requireRestaurantId});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (requireRestaurantId) {
      if (requireRestaurantId) {
        final userDecoding = AppHelpersCommon.getUserInLocalStorage();
        final String restaurantId = userDecoding!.restaurantId;
        if (restaurantId.isNotEmpty) {
          options.headers.addAll({'restaurantId': restaurantId});
        }
      }
    }
    handler.next(options);
  }
}
