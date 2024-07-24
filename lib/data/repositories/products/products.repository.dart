import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/services/api_result.service.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/network_exceptions.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/categorie_entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/customer.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant_category.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';

class ProductsRepository {
  HttpService server = HttpService();

  Future<ApiResultService<List<FoodDataEntity>>> getFoods() async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/products/foods/',
      );

      return ApiResultService.success(
        data: (response.data as List)
            .map((element) => FoodDataEntity.fromJson(element))
            .toList(),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<FoodDataEntity>> createFood(dynamic data) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.post(
        '/products/foods/',
        data: data,
      );

      return ApiResultService.success(
        data: FoodDataEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<FoodDataEntity>> updateFood(
      dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/products/foods/$id/',
        data: data,
      );

      return ApiResultService.success(
        data: FoodDataEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<FoodDataEntity>> getFoodById(String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/products/foods/$id/',
      );
      final json = response.data as dynamic;
      final foodData = json.map((item) => FoodDataEntity.fromJson(item));
      return ApiResultService.success(
        data: foodData,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<List<CategoryEntity>>> getFoodCategories() async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/products/food-categories/',
      );
      final json = response.data as List<dynamic>;
      final categoryData =
          json.map((item) => CategoryEntity.fromJson(item)).toList();
      return ApiResultService.success(
        data: categoryData,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<CategoryEntity>> createFoodCategory(
      String name, String description) async {
    try {
      final user = AppHelpersCommon.getUserInLocalStorage();
     // final String restaurantId = user!.role!.restaurantId!;
      final data = {
        "name": name,
        "description": description,
       // "restaurantId": restaurantId,
        "isAvailable": true
      };
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.post(
        '/products/food-categories/',
        data: data,
      );

      return ApiResultService.success(
        data: CategoryEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<FoodVariantCategoryEntity>> createFoodVariantCategory(
      String name, String foodId) async {
    try {
      final data = {"name": name, "foodId": foodId};
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.post(
        '/products/food-variant-categories/',
        data: data,
      );

      return ApiResultService.success(
        data: FoodVariantCategoryEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<FoodVariantCategoryEntity>> updateFoodVariantCategory(
      dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/products/food-variant-categories/$id/',
        data: data,
      );

      return ApiResultService.success(
        data: FoodVariantCategoryEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<FoodVariantEntity>> createFoodVariant(
      dynamic data) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.post(
        '/products/food-variants/',
        data: data,
      );

      return ApiResultService.success(
        data: FoodVariantEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<FoodVariantEntity>> updateFoodVariant(
      dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/products/food-variants/$id/',
        data: data,
      );

      return ApiResultService.success(
        data: FoodVariantEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<dynamic>> getBundlePacks() async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/products/bundle-packs/',
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

  Future<ApiResultService<OrderEntity>> createOrder(dynamic data) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.post(
        '/orders/',
        data: data,
      );
      return ApiResultService.success(
        data: OrderEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<OrderEntity>> updateOrder(
      dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/orders/$id/',
        data: data,
      );
      return ApiResultService.success(
        data: OrderEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<List<CustomerEntity>>> getCustomers() async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/customers/',
      );
      final json = response.data as List<dynamic>;
      final customersData =
          json.map((item) => CustomerEntity.fromJson(item)).toList();
      return ApiResultService.success(
        data: customersData,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<CustomerEntity>> createCustomers(dynamic data) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.post(
        '/customers/',
        data: data,
      );

      return ApiResultService.success(
        data: CustomerEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }
}
