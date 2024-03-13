import 'package:dio/dio.dart';
import 'package:tajiri_pos_mobile/app/config/env/environment.env.dart';
import 'package:tajiri_pos_mobile/app/interceptors/restaurant.interceptor.dart';
import 'package:tajiri_pos_mobile/app/interceptors/token.interceptor.dart';

class HttpService {
  Dio client({
    bool requireAuth = false,
    bool requireRestaurantId = false,
  }) {
    final options = BaseOptions(
      baseUrl: Environment.backendPoint,
      connectTimeout: 60 * 1000,
      receiveTimeout: 60 * 1000,
      sendTimeout: 60 * 1000,
      headers: {
        'Accept':
            'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
        'Content-type': 'application/json',
      },
    );

    final dio = Dio(options);

    dio.interceptors.add(TokenInterceptor(requireAuth: requireAuth));
    dio.interceptors.add(
      RestaurantInterceptor(requireRestaurantId: requireRestaurantId),
    );
    // dio.interceptors.add(RefreshTokenInterceptor(dio));
    dio.interceptors.add(
      LogInterceptor(
        responseHeader: false,
        requestHeader: true,
        responseBody: true,
        requestBody: true,
      ),
    );

    return dio;
  }
}
