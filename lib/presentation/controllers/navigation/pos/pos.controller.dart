import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get_rx/get_rx.dart';
import 'dart:async';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.dart';
import 'package:tajiri_pos_mobile/domain/entities/categorie_entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/customer.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant_category.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/repositories/products.repository.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull_dialog.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/product_in_cart.widget.dart';

class PosController extends GetxController {
  final ProductsRepository _productsRepository = ProductsRepository();
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
  bool isLoading = true;
  String? selectedOption;
  bool isAddAndRemoveLoading = false;
  bool isProductLoading = true;
  bool isCustomnersLoading = true;
  final foods = List<FoodDataEntity>.empty().obs;
  final foodsInit = List<FoodDataEntity>.empty().obs;
  RxList bundlePacks = [].obs;
  final categories = List<CategoryEntity>.empty().obs;
  RxString categoryId = ''.obs;
  Rx<dynamic> customerSelected = null.obs;
  int totalCartValue = 0;

  List<MainItemEntity> cartItemList = List<MainItemEntity>.empty().obs;

  RxString settleOrderId = "ON_PLACE".obs;
  RxString orderNotes = "".obs;
  RxString paymentMethodId = "d8b8d45d-da79-478f-9d5f-693b33d654e6".obs;
  OrdersDataEntity newOrder = OrdersDataEntity();
  OrdersDataEntity currentOrder = OrdersDataEntity();
  Rx<bool> isLoadingOrder = false.obs;
  RxString emptySearchMessage = "".obs;
  RxList<String> searchResults = <String>[].obs;

  final foodVariantCategories = List<FoodVariantCategoryEntity>.empty().obs;

  CustomerEntity currentCustomer = CustomerEntity();
  CustomerEntity newCustomer = CustomerEntity();
  List<CustomerEntity> customers = List<CustomerEntity>.empty().obs;
  List<CustomerEntity> customerInit = List<CustomerEntity>.empty().obs;
  Rx<CustomerEntity> customer = CustomerEntity().obs;

  RxString customerMessage = "".obs;
  RxString customerId = ''.obs;
  String customerFirstname = "";
  String customerLastname = "";
  String customerPhone = "";
  TextEditingController customerEmail = TextEditingController();
  TextEditingController note = TextEditingController();

  bool isLoadingCreateCustomer = false;
  Rx<bool> isPaid = false.obs;
  Map<String, dynamic>? waitressOrTableValue;
  List<Map<String, dynamic>> dropdownItems = [];
  bool listingEnable = true;
  String listingType = "waitress";
  String waitressId = '';
  String tableId = '';
  String? waitressCurrentId;
  String? tableCurrentId;
  Color containerColor = Style.menuFlottant;

  final user = AppHelpersCommon.getUserInLocalStorage();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    fetchFoods();
    fetchCustomers();
    super.onReady();
  }

  setCurrentOrder(OrdersDataEntity order) {
    currentOrder = order;
    update();
  }

  Future<void> fetchFoods() async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final response = await _productsRepository.getFoods();
      final responseBundlePacks = await _productsRepository
          .getBundlePacks(); //TODO: GET BUNDLE PACK DOIT RETURNER PACK ENTITY ET NN DYNAMIC

      response.when(
        success: (data) async {
          if (data == null) {
            return;
          }

          foods.assignAll(
              data.where((element) => element.isAvailable == true).toList());
          foodsInit.assignAll(
              data.where((element) => element.isAvailable == true).toList());

          bundlePacks.assignAll(responseBundlePacks.data);

          isProductLoading = false;

          final newCategories = data
              .where((e) =>
                  e.category != null) // Filter out items with null category
              .map((e) => e.category!) // Safe to use non-nullable access now
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
          /*  AppHelpersCommon.showCheckTopSnackBar(
              context,
              status.toString(),
            ); */
        },
      );
    }
  }

  int getQuantity(int index) {
    final quantity = cartItemList
            .firstWhereOrNull((element) => element.id == foods[index].id)
            ?.quantity ??
        0;
    return quantity;
  }

  Future<void> handleSaveOrder(BuildContext context, String status) async {
    final String restaurantId = user!.role!.restaurantId!;
    final itemFoods = cartItemList.map((item) {
      return {
        'foodId': item.id,
        'price': item.price,
        'quantity': item.quantity,
      };
    }).toList();

    final Map<String, dynamic> params =
        chooseUseWaitressOrTable(status, restaurantId, itemFoods);

    String paymentMethodName = PAIEMENTS.firstWhereOrNull(
        (element) => element['id'] == paymentMethodId.value)?['name'];
    if (status == 'PAID') {
      params['paymentMethodId'] = paymentMethodId.value;
    }

    final response = currentOrder.id != null
        ? await _productsRepository.updateOrder(params, currentOrder.id!)
        : await _productsRepository.createOrder(params);
    response.when(success: (data) async {
      newOrder = data!;
      update();
      handleInitialState();

      customer.value = CustomerEntity();
      Mixpanel.instance.track("Checkout (Send Order to DB)", properties: {
        "CustomerEntity type": newOrder.customer == null ? 'GUEST' : 'SAVED',
        "Order Status": status,
        "Payment method": status == 'PAID' ? paymentMethodName : "",
        "Status": "Success",
        "Products": newOrder.orderDetails?.map((item) {
          final int foodPrice =
              item.food != null ? item.food?.price : item.bundle['price'];
          return {
            'Product Name':
                item.food != null ? item.food?.name : item.bundle['name'],
            'Price': item.price,
            'Quantity': item.quantity,
            'IsVariant': item.price != foodPrice ? true : false
          };
        }).toList()
      });

      if (status != 'PAID') {
        AppHelpersCommon.showAlertDialog(
          context: context,
          canPop: false,
          child: SuccessfullDialog(
            haveButton: false,
            isCustomerAdded: false,
            title: "Enregistrement effectué",
            content: "Consulter l'élément dans l'historique",
            svgPicture: "assets/svgs/enregistrement 1.svg",
            redirect: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      } else {
        isPaid.value = true;
        AppHelpersCommon.showAlertDialog(
          context: context,
          canPop: false,
          child: SuccessfullDialog(
            isCustomerAdded: false,
            haveButton: false,
            title: "Paiement effectué",
            content: "La commande a bien été payée.",
            svgPicture: "assets/svgs/success payment 1.svg",
            redirect: () {
              // Get.toNamed(Routes.INVOICE_PDF, arguments: newOrder);
            },
          ),
        );
      }
    }, failure: (failure, statusCode) {
      Mixpanel.instance.track("Checkout (Send Order to DB)", properties: {
        "CustomerEntity type": newOrder.customer == null ? 'GUEST' : 'SAVED',
        "Order Status": status,
        "Payment method": status == 'PAID' ? paymentMethodName : "",
        "Status": "Failure",
        "Products": newOrder.orderDetails?.map((item) {
          final int foodPrice =
              item.food != null ? item.food?.price : item.bundle['price'];
          return {
            'Product Name':
                item.food != null ? item.food?.name : item.bundle['name'],
            'Price': item.price,
            'Quantity': item.quantity,
            'IsVariant': item.price != foodPrice ? true : false
          };
        }).toList()
      });
      AppHelpersCommon.showCheckTopSnackBar(
        context,
        statusCode.toString(),
      );
    });
  }

  Map<String, dynamic> chooseUseWaitressOrTable(
      String status, String restaurantId, dynamic itemFoods) {
    // Initialiser les paramètres communs
    Map<String, dynamic> params = {
      'subTotal': totalCartValue,
      'grandTotal': totalCartValue,
      'customerType': customer.value.id == null ? 'GUEST' : 'SAVED',
      'status': status,
      'customerId': customer.value.id,
      'items': itemFoods,
      'orderType': settleOrderId.value,
      'orderNotes': orderNotes.value,
      'restaurantId': restaurantId,
      'createdId': user!.id!,
      'couponCode': "",
      'discountAmount': 0,
      'pinCode': "",
      'address': "",
      'tax': 0,
    };

    // Choisir les paramètres en fonction du type de liste
    if (checkListingType(user) == ListingType.waitress) {
      params['waitressId'] = waitressCurrentId ?? "";
    } else if (checkListingType(user) == ListingType.table) {
      params['tableId'] = tableCurrentId ?? "";
    }

    return params;
  }

  Future<void> handleCreateOrder(BuildContext context) async {
    try {
      isLoadingOrder.value = true;
      update();
      await handleSaveOrder(context, 'PAID');
    } catch (error) {
      isLoadingOrder.value = false;
      update();
    }
  }

  Future<void> handleCreateOrderInProgres(BuildContext context) async {
    try {
      isLoadingOrder.value = true;
      update();
      await handleSaveOrder(context, 'NEW');
    } catch (error) {
      isLoadingOrder.value = false;
      update();
    }
  }

  void handleInitialState() {
    cartItemList.clear();
    isLoadingOrder.value = false;
    settleOrderId.value = "ON_PLACE";
    note.clear();
    currentOrder = OrdersDataEntity();
    update();
  }

  void setCategoryId(String id) {
    categoryId.value = id;
    update();
  }

  void handleFilter(String categoryId, String categoryName) {
    setCategoryId(categoryId);

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
          transformedList.map((item) => FoodDataEntity.fromJson(item)).toList();
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

  Future<void> fetchCustomers() async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      isCustomnersLoading = true;
      update();
      final response = await _productsRepository.getCustomers();
      response.when(
        success: (data) async {
          customers.assignAll(data!);
          customerInit.assignAll(data);
          isCustomnersLoading = false;
          update();
        },
        failure: (failure, status) {
          isCustomnersLoading = false;
          update();
        },
      );
    }
  }

  String quantityProduct() {
    if (cartItemList.length > 1) return "${cartItemList.length} produits";
    return "${cartItemList.length} produit";
  }

  Future<void> saveCustomers(BuildContext context) async {
    isLoadingCreateCustomer = true;
    update();
    final String restaurantId = user!.role!.restaurantId!;
    Map<String, dynamic> requestData = {
      'lastname': customerLastname,
      'phone': customerPhone,
      'restaurantId': restaurantId,
    };

    if (customerLastname.isEmpty || customerPhone.isEmpty) {
      isLoadingCreateCustomer = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez remplir les champs obligatoires",
      );
    }
    final response = await _productsRepository.createCustomers(requestData);
    response.when(success: (data) {
      newCustomer = data! as dynamic;
      isLoadingCreateCustomer = false;
      update();

      AppHelpersCommon.showAlertDialog(
        context: context,
        canPop: false,
        child: SuccessfullDialog(
          haveButton: false,
          isCustomerAdded: true,
          title: "Client ajouté",
          content:
              "Le client $customerLastname $customerFirstname a été crée et ajouté à votre base de donnée client.",
          svgPicture: "assets/svgs/user 1.svg",
          redirect: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
      customer.value = data;
      fetchCustomers();
      customerInitialState();
    }, failure: (failure, statusCode) {
      isLoadingCreateCustomer = false;
      update();
      AppHelpersCommon.showCheckTopSnackBar(
        context,
        statusCode.toString(),
      );
    });
  }

  void customerInitialState() {
    isLoading = false;
    currentCustomer = CustomerEntity();
    customerEmail.clear();
    customerFirstname = "";
    customerLastname = "";
    customerPhone = "";
    //Get.back();
    update();
  }

  Future<void> addCount(
      {required BuildContext context,
      required String foodId,
      String? foodVariantId}) async {
    Vibrate.feedback(FeedbackType.selection);
    MainItemEntity elementToUpdate = cartItemList.firstWhere(
        (element) => element.id == foodId,
        orElse: () => MainItemEntity());

    if (foodVariantId != null) {
      elementToUpdate = cartItemList.firstWhere(
          (element) =>
              element.variant != null && element.variant!.id == foodVariantId,
          orElse: () => MainItemEntity());
    }

    elementToUpdate.quantity = elementToUpdate.quantity! + 1;
    cartItemList.remove(elementToUpdate);
    cartItemList.add(elementToUpdate);
    update();
    calculateTotal();
  }

  Future addCart(
      BuildContext context,
      FoodDataEntity product,
      FoodVariantEntity? foodVariant,
      int? quantity,
      int? price,
      bool isModifyOrder) async {
    Vibrate.feedback(FeedbackType.selection);
    if (foodVariant == null) {
      cartItemList.add(MainItemEntity(
        id: product.id,
        quantity: quantity,
        name: product.name,
        image: product.imageUrl,
        price: price == 0 ? product.price : price,
      ));
    } else {
      cartItemList.add(MainItemEntity(
          id: product.id,
          quantity: quantity,
          name: "${product.name} (${foodVariant.name}) ",
          image: product.imageUrl,
          price: price == 0 ? foodVariant.price : price,
          variant: MainItemVariation(
              id: foodVariant.id,
              itemId: 1,
              name: foodVariant.name,
              price: price == 0 ? foodVariant.price : price)));
    }
    isLoading = false;
    Mixpanel.instance.track("Added to Cart", properties: {
      "Product name": product.name,
      "Product ID": product.id,
      "Category": product.category?.name,
      "Selling Price": price == 0 ? product.price : price,
      "Quantity": quantity,
      "Stock Availability": product.quantity,
      "IsVariant": foodVariant != null ? true : false
    });
    update();
    calculateTotal();

    if (cartItemList.isNotEmpty && !isModifyOrder) {
      AppHelpersCommon.showBottomSnackBar(
        context,
        const ProductInCartWidget(),
        AppConstants.productCartSnackbarDuration,
        true,
      );
      update();
    }
  }

  Future<void> removeCount(
      {required BuildContext context,
      required String foodId,
      String? foodVariantId}) async {
    Vibrate.feedback(FeedbackType.selection);
    MainItemEntity elementToUpdate = cartItemList.firstWhere(
        (element) => element.id == foodId,
        orElse: () => MainItemEntity());

    if (foodVariantId != null) {
      elementToUpdate = cartItemList.firstWhere(
          (element) =>
              element.variant != null && element.variant!.id == foodVariantId,
          orElse: () => MainItemEntity());
    }

    if (elementToUpdate.quantity! > 1) {
      elementToUpdate.quantity = elementToUpdate.quantity! - 1;
      cartItemList.remove(elementToUpdate);
      cartItemList.add(elementToUpdate);
      update();
      calculateTotal();
    } else {
      if (foodVariantId != null) {
        cartItemList.removeWhere((element) =>
            element.variant != null &&
            element.variant!.id == elementToUpdate.variant?.id);
      } else {
        cartItemList.removeWhere((element) => element.id == elementToUpdate.id);
      }
      isAddAndRemoveLoading = false;
      update();
      calculateTotal();
    }

    if (cartItemList.isEmpty) {
      AppHelpersCommon.removeCurrentSnackBar(context);
      update();
    }
  }

  getSortList(List<MainItemEntity>? items) {
    if (items == null) return;
    List<MainItemEntity>? sortedItems = items.map((e) => e).toList()
      ..sort((a, b) => b.name!.compareTo(a.name!));
    return sortedItems;
  }

  void calculateTotal() {
    totalCartValue = cartItemList.fold<int>(
      0,
      (previousTotal, item) =>
          previousTotal + ((item.quantity!) * (item.price!)),
    );

    update();
  }

  void searchFilter(String search) {
    setCategoryId("all");
    foods.clear();
    update();
    if (search.isEmpty) {
      foods.addAll(foodsInit);
    } else {
      final nameRecherch = search.toLowerCase();
      foods.addAll(foodsInit.where((item) {
        final foodName = item.name!.toLowerCase();
        final categoryName = item.category!.name!.toLowerCase();

        return foodName.startsWith(nameRecherch) ||
            categoryName.startsWith(nameRecherch);
      }).toList());
      update();
    }
  }
}
