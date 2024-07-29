import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/data/repositories/products/products.repository.dart';
import 'package:tajiri_pos_mobile/domain/entities/categorie_entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant_category.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';

class ProductsController extends GetxController {
  final ProductsRepository _productsRepository = ProductsRepository();
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
  bool isProductLoading = false;
  List<Product> foods = List<Product>.empty().obs;
  List<Product> foodsInit = List<Product>.empty().obs;
  RxList bundlePacks = [].obs;
  final categories = List<CategoryEntity>.empty().obs;
  RxString categoryId = 'all'.obs;
  // RxString categoryNameSelect = ''.obs;

  int price = 0;
  String name = "";
  String description = "";
  int costBuy = 0;
  int quantity = 0;
  RxString pickCategoryId = "".obs;
  RxString pickFoodVariantCategoryId = "".obs;
  RxString pickFoodId = "".obs;
  bool isAvailable = false;
  RxString imageUrl = "".obs;
  RxString imageCompress = "".obs;
  final PosController _posController = Get.find();
  final foodVariantCategories = List<FoodVariantCategoryEntity>.empty().obs;
  final user = AppHelpersCommon.getUserInLocalStorage();

  @override
  void onReady() async {
    fetchFoods();
    super.onReady();
  }

  Future<void> fetchFoods({bool refreshCategorieId = false}) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final response = await _productsRepository.getFoods();
      final responseBundlePacks = await _productsRepository.getBundlePacks();

      response.when(
        success: (data) async {
          if (data == null) {
            return;
          }

          foods.assignAll(data.toList());
          foodsInit.assignAll(data.toList());

          bundlePacks.assignAll(responseBundlePacks.data);

          if (refreshCategorieId) {
            setCategoryId("all");
          }

          isProductLoading = false;
          update();

          final newCategories = data
              .where((e) {
                return e.category != null;
              })
              .map((e) => e.category!)
              .toSet()
              .toList();

          newCategories.insert(
            0,
            CategoryEntity(
              id: "all",
              name: "Tout",
              imageUrl: '🗂️',
            ),
          );
          newCategories.insert(
            newCategories.length,
            CategoryEntity(
              id: KIT_ID,
              name: "Packs de vente",
              imageUrl: '🎁',
            ),
          );
          categories.assignAll(newCategories);

          List<FoodVariantCategoryEntity> newFoodVariantCategories = [];

          for (var foodData in data) {
            final listFoodVariantCategories = foodData.foodVariantCategory;

            if (listFoodVariantCategories!.isNotEmpty) {
              for (var value in listFoodVariantCategories) {
                newFoodVariantCategories.add(value);
              }
            }
          }

          foodVariantCategories.assignAll(newFoodVariantCategories);
          update();
        },
        failure: (failure, status) {
          isProductLoading = false;
          update();
        },
      );
    }
  }

  Future<void> updateFood(
      BuildContext context, Product foodData, bool isPrice) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final data = {
        "name": name == "" ? foodData.name : name,
        "description": description == "" ? foodData.description : description,
        "price": price == 0 ? foodData.price : price,
        "costBuy": costBuy == 0 ? 0 : costBuy,
        "isFeatured": true,
        "quantity": quantity == 0 ? foodData.quantity : quantity,
        "isAvailable": isAvailable,
        "categoryId": pickCategoryId.value == ""
            ? foodData.categoryId
            : pickCategoryId.value,
        "imageUrl": imageUrl.value == "" ? foodData.imageUrl : imageUrl.value,
      };
      final response = await _productsRepository.updateFood(data, foodData.id!);

      response.when(
        success: (data) async {
          pickCategoryId.value = "";
          imageUrl.value = "";
          imageCompress.value = "";
          _posController.fetchProducts();
          isProductLoading = false;
          update();
          AppHelpersCommon.showAlertDialog(
            context: context,
            canPop: false,
            child: SuccessfullDialog(
              haveButton: false,
              isCustomerAdded: true,
              title: isPrice
                  ? "Le prix a été modifié avec succès!"
                  : getAvailableMessage()['title'],
              content: isPrice ? "" : getAvailableMessage()['content'],
              svgPicture: isPrice
                  ? "assets/svgs/icon_price_tag.svg"
                  : getAvailableMessage()['image'],
              redirect: () {
                if (isPrice) {
                  Get.close(3);
                } else {
                  Get.close(2);
                }
                fetchFoods(refreshCategorieId: true);
              },
            ),
          );
          update();
        },
        failure: (failure, status) {
          isProductLoading = false;
          update();
        },
      );
    }
  }

  getAvailableMessage() {
    if (isAvailable) {
      final data = {
        "image": "assets/svgs/product-2.svg",
        "title": "Le produit disponible !",
        "content": "Ce produit est à nouveau disponible dans votre stock."
      };
      return data;
    } else {
      final data = {
        "image": "assets/svgs/product-1.svg",
        "title": "Le produit indisponible",
        "content": "Ce produit ne sera plus affiché dans votre stock."
      };
      return data;
    }
  }

  Future<void> updateFoodVariant(
      BuildContext context, ProductFoodVariant foodVariant) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final data = {
        "name": name == "" ? foodVariant.name : name,
        "price": price == 0 ? foodVariant.price : price,
        "quantity": quantity == 0 ? foodVariant.quantity : quantity,
        "managementStock": true,
        "foodVariantCategoryId": foodVariant.foodVariantCategoryId,
      };
      final response =
          await _productsRepository.updateFoodVariant(data, foodVariant.id!);

      response.when(
        success: (data) async {
          pickFoodVariantCategoryId.value = "";
          _posController.fetchProducts();
          isProductLoading = false;
          AppHelpersCommon.showAlertDialog(
            context: context,
            canPop: false,
            child: SuccessfullDialog(
              haveButton: false,
              isCustomerAdded: true,
              title: "Le prix a été modifié avec succès!",
              content: "",
              svgPicture: "assets/svgs/icon_price_tag.svg",
              redirect: () {
                Get.close(3);
                fetchFoods(refreshCategorieId: true);
              },
            ),
          );
          update();
        },
        failure: (failure, status) {
          isProductLoading = false;
          update();
        },
      );
    }
  }

  void setPrice(String text) {
    price = int.parse(text);
  }

  void setIsvalaible(bool text) {
    isAvailable = text;
  }

  void setCategoryId(String id) {
    categoryId.value = id;
    update();
  }

  // void setCategoryNameSelect(String name) {
  //   categoryNameSelect.value = name;
  //   update();
  // }

  void handleFilter(String categoryId, String categoryName) {
    setCategoryId(categoryId);
    // setCategoryNameSelect(categoryName);

    if (categoryId == 'all') {
      foods.assignAll(foodsInit);
      update();
      Mixpanel.instance.track("POS Category Filter", properties: {
        "Category Name": categoryName,
        "Number of Search Results": foods.length,
        "Number of Out of Stock":
            foods.where((food) => food.quantity == 0).length,
        "Number of products with variants": foods
            .where((food) =>
                food.foodVariantCategory != null &&
                food.foodVariantCategory!.isNotEmpty)
            .length
      });
      return;
    }

    if (categoryId == KIT_ID) {
      final transformedList = bundlePacks.map((bundle) {
        return {
          ...bundle,
          'type': 'bundle',
        };
      }).toList();
      final foodData =
          transformedList.map((item) => Product.fromJson(item)).toList();
      foods.assignAll(foodData);
      update();

      Mixpanel.instance.track("POS Category Filter", properties: {
        "Category Name": categoryName,
        "Number of Search Results": transformedList.length,
        "Number of Out of Stock": 0,
        "Number of products with variants": 0
      });
      return;
    }

    final newData =
        foodsInit.where((item) => item.categoryId == categoryId).toList();
    foods.assignAll(newData);
    update();

    Mixpanel.instance.track("POS Category Filter", properties: {
      "Category Name": categoryName,
      "Number of Search Results": newData.length,
      "Number of Out of Stock":
          newData.where((food) => food.quantity == 0).length,
      "Number of products with variants": newData
          .where((food) =>
              food.foodVariantCategory != null &&
              food.foodVariantCategory!.isNotEmpty)
          .length
    });
  }
}
