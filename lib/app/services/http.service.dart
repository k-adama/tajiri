import 'package:Tajiri/app/config/env/environment.env.dart';
import 'package:Tajiri/app/interceptors/restaurant.interceptor.dart';
import 'package:Tajiri/app/interceptors/token.interceptor.dart';
import 'package:dio/dio.dart';


class HttpService {
  Dio client({
    bool requireAuth = false,
    bool requireRestaurantId = false,
  }) {
    final options = BaseOptions(
      baseUrl:  Environment.backendPoint,
      connectTimeout: const Duration(milliseconds: 60 * 1000),
      receiveTimeout:const  Duration(milliseconds: 60 * 1000),
      sendTimeout: const Duration(milliseconds: 60 * 1000),
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
