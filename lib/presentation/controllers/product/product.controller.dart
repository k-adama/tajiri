import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';
import 'package:tajiri_pos_mobile/app/extensions/product.extension.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class ProductsController extends GetxController {
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
  bool isProductLoading = false;
  final products = List<Product>.empty().obs;
  final productsInit = List<Product>.empty().obs;
  final categories = List<Category>.empty().obs;
  RxString categoryId = 'all'.obs;

  int price = 0;
  String name = "";
  String description = "";
  bool isAvailable = false;
  // final PosController _posController = Get.find();
  static final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  final restaurantId = user?.restaurantId;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() async {
    Future.wait([
      fetchProductsAndCategories(),
    ]);
    super.onReady();
  }

  Future<void> fetchProductsAndCategories() async {
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts({bool refreshCategorieId = false}) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        isProductLoading = true;
        update();

        final result =
            await tajiriSdk.productsService.getProducts(restaurantId!);
        products.assignAll(result);
        productsInit.assignAll(result);
        if (refreshCategorieId) {
          setCategoryId("all");
        }

        isProductLoading = false;
        update();
      } catch (e) {
        isProductLoading = false;
        update();
        print("Fetch product error $e");
      }
    }
  }

  Future<void> fetchProductById(String idProduct) async {
    print("====Fetch Product by id $idProduct==");
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        final order = await tajiriSdk.productsService.getProduct(idProduct);
        updateProductList(order);
        setCategoryId("all");
        update();
      } catch (e) {
        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );
      }
    }
  }

  void updateProductList(Product newProduct) {
    final indexInit =
        productsInit.indexWhere((order) => order.id == newProduct.id);
    print("update order list $indexInit");
    if (indexInit != -1) {
      // Replace the old order with the new order in ordersInit
      productsInit[indexInit] = newProduct;
    } else {
      // Add the new order to ordersInit if it doesn't exist
      productsInit.insert(0, newProduct);
    }

    products.assignAll(productsInit);
  }

  Future<void> fetchCategories() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();

      final newCategories =
          await tajiriSdk.categoriesService.getCategories(restaurantId!);
      newCategories.insert(
        0,
        Category(
          id: "all",
          name: "Tout",
          imageUrl: '🗂️',
          restaurantId: '',
          mainCategoryId: '',
        ),
      );
      newCategories.insert(
        newCategories.length,
        Category(
          id: KIT_ID,
          name: "Packs de vente",
          imageUrl: '🎁',
          restaurantId: '',
          mainCategoryId: '',
        ),
      );
      categories.assignAll(newCategories);
      handleFilter("all", "all");
      isProductLoading = false;
      update();
    }
  }

  Future<void> updateProductPrice(
      BuildContext context, Product product, bool isPrice) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      UpdateProductDto updateProductDto = UpdateProductDto(
        price: price == 0 ? product.price : price,
        isAvailable: isAvailable,
      );
      try {
        await tajiriSdk.productsService
            .updateProduct(product.id, updateProductDto);
        //TODO  FETCH PRODUCT BY ID WHEN UPDATE
        fetchProductById(product.id);
        // fetchProducts();
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
              fetchProductById(product.id);
              // fetchProducts(refreshCategorieId: true);
            },
          ),
        );
        update();
        price = 0;
      } catch (e) {
        AppHelpersCommon.showCheckTopSnackBar(
          context,
          e.toString(),
        );
      }
      isProductLoading = false;
      update();
    }
  }

  Future<void> updateFoodVariantPrice(
      BuildContext context, ProductVariant productVariant) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      UpdateProductVariantDto updateProductVariantDto = UpdateProductVariantDto(
        price: price == 0 ? productVariant.price : price,
      );

      try {
        await tajiriSdk.productVariantsService
            .updateVariant(productVariant.id, updateProductVariantDto);
        fetchProductById(productVariant.productId);
        // fetchProducts();
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
              fetchProductById(productVariant.productId);
              // fetchProducts(refreshCategorieId: true);
            },
          ),
        );
        update();
        price = 0;
      } catch (e) {
        AppHelpersCommon.showCheckTopSnackBar(
          context,
          e.toString(),
        );
      }
      isProductLoading = false;
      update();
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

  void handleFilter(String categoryId, String categoryName) {
    setCategoryId(categoryId);

    if (categoryId == 'all') {
      products.assignAll(productsInit);
      update();
      Mixpanel.instance.track("POS Category Filter", properties: {
        "Category Name": categoryName,
        "Number of Search Results": products.length,
        "Number of Out of Stock":
            products.where((food) => food.quantity == 0).length,
        "Number of products with variants":
            products.where((food) => food.variants.isNotEmpty).length
      });
      return;
    }

    if (categoryId == KIT_ID) {
      final newData = productsInit.where((item) => item.isBundle).toList();
      products.assignAll(newData);
      update();

      Mixpanel.instance.track("POS Category Filter", properties: {
        "Category Name": categoryName,
        "Number of Search Results": newData.length,
        "Number of Out of Stock": 0,
        "Number of products with variants": 0
      });
      return;
    }

    final newData =
        productsInit.where((item) => item.categoryId == categoryId).toList();
    products.assignAll(newData);
    update();

    Mixpanel.instance.track("POS Category Filter", properties: {
      "Category Name": categoryName,
      "Number of Search Results": newData.length,
      "Number of Out of Stock":
          newData.where((food) => food.quantity == 0).length,
      "Number of products with variants":
          newData.where((food) => food.variants.isNotEmpty).length
    });
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
}
