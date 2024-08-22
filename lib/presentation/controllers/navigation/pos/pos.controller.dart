import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/product.extension.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/cart.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class PosController extends GetxController {
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
  bool isLoading = true;
  String? selectedOption;
  bool isAddAndRemoveLoading = false;
  final isProductLoading = true.obs;
  bool isCustomnersLoading = true;
  final products = List<Product>.empty().obs;
  final productsInit = List<Product>.empty().obs;
  RxList bundlePacks = [].obs;
  final categories = List<Category>.empty().obs;
  RxString categoryId = 'all'.obs;
  Rx<dynamic> customerSelected = null.obs;
  int totalCartValue = 0;

  final cartItemList = List<MainItemEntity>.empty().obs;

  RxString settleOrderId = "ON_PLACE".obs;
  RxString orderNotes = "".obs;
  RxString paymentMethodId = "d8b8d45d-da79-478f-9d5f-693b33d654e6".obs;
  Order? newOrder;
  Order? currentOrder;

  Rx<bool> isLoadingOrder = false.obs;
  RxString emptySearchMessage = "".obs;
  RxList<String> searchResults = <String>[].obs;

  final customers = List<Customer>.empty().obs;
  final customerInit = List<Customer>.empty().obs;
  final customer = Rx<Customer?>(null);

  TextEditingController note = TextEditingController();

  bool isLoadingCreateCustomer = false;
  Map<String, dynamic>? waitressOrTableValue;
  List<Map<String, dynamic>> dropdownItems = [];
  bool listingEnable = true;
  String listingType = "waitress";

  String tableId = '';
  String? waitressCurrentId;
  String? tableCurrentId;
  Color containerColor = Style.menuFlottant;

  final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  String? get restaurantId => user?.restaurantId;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onClose() {
    AppHelpersCommon.removeCurrentSnackBar(Get.context!);
    super.onClose();
  }

  @override
  void onReady() async {
    Future.wait([
      fetchCategories(),
      fetchProducts(),
      fetchCustomers(),
    ]);

    super.onReady();
  }

  setCurrentOrder(Order order) {
    currentOrder = order;
    update();
  }

  Future<void> fetchProducts() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading.value = true;
      update();

      final result = await tajiriSdk.productsService.getProducts(restaurantId!);
      products.assignAll(result);
      productsInit.assignAll(result);

      isProductLoading.value = false;
      update();
    }
  }

  Future<void> fetchCategories() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading.value = true;
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
      isProductLoading.value = false;
      update();
    }
  }

  int getQuantity(int index) {
    final quantity = cartItemList
            .firstWhereOrNull(
                (element) => element.productId == products[index].id)
            ?.quantity ??
        0;
    return quantity;
  }

  Future<void> handleSaveOrder(BuildContext context, String status) async {
    if (restaurantId == null) {
      isLoadingOrder.value = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Aucun restaurant connecté",
      );
    }
    if (waitressCurrentId == 'all') {
      isLoadingOrder.value = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez sélectionner le nom d'une serveuse",
      );
    }

    final createOrderDto = getCreateOrderDto(status);
    final paymentMethodName = getNamePaiementById(paymentMethodId.value);

    print("${createOrderDto.toJson()}---${currentOrder?.id}");

    try {
      final result = currentOrder?.id != null
          ? await tajiriSdk.ordersService
              .updateOrder(currentOrder!.id, getUpdateOrderDto(status))
          : await tajiriSdk.ordersService.createOrder(createOrderDto);

      newOrder = result;
      update();
      handleInitialState();

      customer.value = null;
      Mixpanel.instance.track("Checkout (Send Order to DB)", properties: {
        "CustomerEntity type": newOrder?.customerId == null ? 'GUEST' : 'SAVED',
        "Order Status": status,
        "Payment method": status == 'PAID' ? paymentMethodName : "",
        "Status": "Success",
        "Products": newOrder?.orderProducts.map((item) {
          final int foodPrice = item.product.price;
          return {
            'Product Name': item.product.name,
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
              Get.close(3);
            },
          ),
        );
      } else {
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
              Get.close(2);
              Get.toNamed(
                Routes.INVOICE,
                arguments: {"order": result, "isPaid": true},
              );
            },
          ),
        );
      }
    } catch (e, s) {
      print(s);
      Mixpanel.instance.track("Checkout (Send Order to DB)", properties: {
        "CustomerEntity type": newOrder?.customerId == null ? 'GUEST' : 'SAVED',
        "Order Status": status,
        "Payment method": status == 'PAID'
            ? paymentMethodNameById(paymentMethodId.value)
            : "",
        "Status": "Failure",
        "Products": newOrder?.orderProducts.map((item) {
          final int foodPrice = item.product.price;
          return {
            'Product Name': item.product.name,
            'Price': item.price,
            'Quantity': item.quantity,
            'IsVariant': item.price != foodPrice ? true : false
          };
        }).toList()
      });

      AppHelpersCommon.showCheckTopSnackBar(
        context,
        e.toString(),
      );
      isLoadingOrder.value = false;
    }
  }

  CreateOrderDto getCreateOrderDto(String status) {
    final user = AppHelpersCommon.getUserInLocalStorage();
    final restaurantId = user?.restaurantId;

    String customeType = customer.value?.id == null ? 'GUEST' : 'SAVED';

    final orderProductDto = cartItemList.map((item) {
      // TODO productTypeOfCookingId and extra not implemented in this app

      return OrderProductDto(
        productId: item.productId!,
        price: item.price!,
        quantity: item.quantity ?? 0,
        variantId: item.variant?.id,
      );
    }).toList();

    final paiementValue = PaymentValueDto(
        paymentMethodId: paymentMethodId.value, amount: totalCartValue);

    final createDto = CreateOrderDto(
      subTotal: totalCartValue,
      grandTotal: totalCartValue,
      restaurantId: restaurantId!,
      paymentValues: status == 'PAID' ? [paiementValue] : null,
      customerType: customeType,
      orderType: settleOrderId.value,
      status: status,
      customerId: customer.value?.id,
      orderNotes: orderNotes.value,
      createdId: user?.id,
      couponCode: "",
      discountAmount: 0,
      pinCode: "",
      tax: 0,
      products: orderProductDto,
      tableId: checkListingType(user) == ListingType.table
          ? currentOrder?.tableId ?? tableCurrentId
          : null,
      waitressId: checkListingType(user) == ListingType.waitress
          ? currentOrder?.waitressId ?? waitressCurrentId
          : null,
    );
    return createDto;
  }

  UpdateOrderDto getUpdateOrderDto(String status) {
    final user = AppHelpersCommon.getUserInLocalStorage();

    String customeType = customer.value?.id == null ? 'GUEST' : 'SAVED';

    final orderProductDto = cartItemList.map((item) {
      // TODO productTypeOfCookingId and extra not implemented in this app

      return OrderProductDto(
        productId: item.productId!,
        price: item.price ?? 0,
        quantity: item.quantity ?? 1,
        variantId: item.variant?.id,
      );
    }).toList();

    final updateDto = UpdateOrderDto(
      subTotal: totalCartValue.toInt(),
      grandTotal: totalCartValue.toInt(),
      customerType: customeType,
      orderType: settleOrderId.value,
      status: status,
      customerId: customer.value?.id,
      orderNotes: orderNotes.value,
      createdId: user?.id,
      couponCode: "",
      discountAmount: 0,
      pinCode: "",
      tax: 0,
      products: orderProductDto,
      tableId: checkListingType(user) == ListingType.table
          ? currentOrder?.tableId ?? tableCurrentId
          : null,
    );
    return updateDto;
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
      print("Erreur handleCreateOrderInProgres : $error");
      isLoadingOrder.value = false;
      update();
    } finally {
      isLoadingOrder.value = false;
      update();
    }
  }

  void handleInitialState() {
    cartItemList.clear();
    isLoadingOrder.value = false;
    settleOrderId.value = "ON_PLACE";
    note.clear();
    currentOrder = null;
    update();
  }

  //TODO : for clear selected  waitress and table
  resetSelectedTableOrWaitress() {
    // reset waitress and table select

    final waitressController = Get.find<WaitressController>();
    final tableController = Get.find<TableController>();

    waitressController.selectedWaitress.value = null;
    tableController.selectedTable.value = null;

    waitressCurrentId = null;
    tableCurrentId = null;
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

  Future<void> fetchCustomers() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isCustomnersLoading = true;
      update();
      final result =
          await tajiriSdk.customersService.getCustomers(restaurantId!);
      customers.assignAll(result);
      customerInit.assignAll(result);
      isCustomnersLoading = false;
      update();
    }
  }

  String quantityProduct() {
    if (cartItemList.length > 1) return "${cartItemList.length} produits";
    return "${cartItemList.length} produit";
  }

  Future<void> saveCustomers(
    BuildContext context,
    String customerLastname,
    String customerPhone,
  ) async {
    isLoadingCreateCustomer = true;
    update();
    if (restaurantId == null) {
      isLoadingCreateCustomer = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Aucun restaurant connecté",
      );
    }
    if (customerLastname.trim().isEmpty || customerPhone.trim().isEmpty) {
      isLoadingCreateCustomer = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez remplir les champs obligatoires",
      );
    }
    final CreateCustomerDto createCustomerDto = CreateCustomerDto(
        lastname: customerLastname,
        phone: customerPhone,
        restaurantId: restaurantId!);
    try {
      final createWaitress =
          await tajiriSdk.customersService.createCustomer(createCustomerDto);
      final newCustomer = createWaitress;
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
              "Le client $customerLastname a été crée et ajouté à votre base de donnée client.",
          svgPicture: "assets/svgs/user 1.svg",
          redirect: () {
            Get.close(3);
          },
        ),
      );
      customer.value = newCustomer;
      fetchCustomers();
      customerInitialState();
    } catch (e) {
      AppHelpersCommon.showCheckTopSnackBar(
        context,
        e.toString(),
      );
      isLoadingCreateCustomer = false;
      update();
    }
  }

  void customerInitialState() {
    isLoading = false;
    //Get.back();
    update();
  }

  Future<void> addCount(
      {required BuildContext context,
      required String productId,
      String? productVariantId}) async {
    Vibrate.feedback(FeedbackType.selection);
    MainItemEntity elementToUpdate = cartItemList.firstWhere(
        (element) => element.productId == productId,
        orElse: () => MainItemEntity());

    if (productVariantId != null) {
      elementToUpdate = cartItemList.firstWhere(
          (element) =>
              element.variant != null &&
              element.variant!.id == productVariantId,
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
      Product product,
      ProductVariant? productVariant,
      int? quantity,
      int? price,
      bool isModifyOrder) async {
    Vibrate.feedback(FeedbackType.selection);
    if (productVariant == null) {
      cartItemList.add(MainItemEntity(
        productId: product.id,
        quantity: quantity,
        name: product.name,
        image: product.imageUrl,
        price: price == 0 ? product.price : price,
      ));
    } else {
      cartItemList.add(MainItemEntity(
          productId: product.id,
          quantity: quantity,
          name: "${product.name} (${productVariant.name}) ",
          image: product.imageUrl,
          price: price == 0 ? productVariant.price : price,
          variant: MainItemVariation(
              id: productVariant.id,
              itemId: 1,
              name: productVariant.name,
              price: price == 0 ? productVariant.price : price)));
    }
    isLoading = false;
    Mixpanel.instance.track("Added to Cart", properties: {
      "Product name": product.name,
      "Product ID": product.id,
      "Category": product.category.name,
      "Selling Price": price == 0 ? product.price : price,
      "Quantity": quantity,
      "Stock Availability": product.quantity,
      "IsVariant": productVariant != null ? true : false
    });
    update();
    calculateTotal();
  }

  Future<void> removeCount(
      {required BuildContext context,
      required String foodId,
      String? foodVariantId}) async {
    Vibrate.feedback(FeedbackType.selection);
    MainItemEntity elementToUpdate = cartItemList.firstWhere(
        (element) => element.productId == foodId,
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
        cartItemList.removeWhere(
            (element) => element.productId == elementToUpdate.productId);
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

  List<MainItemEntity> getSortList(List<MainItemEntity>? items) {
    if (items == null) {
      return [];
    }
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

  void deleteCart() async {
    cartItemList.clear();
    update();
  }

  void searchFilter(String search) {
    setCategoryId("all");
    products.clear();
    update();
    if (search.isEmpty) {
      products.addAll(productsInit);
    } else {
      final nameRecherch = search.toLowerCase();
      products.addAll(productsInit.where((item) {
        final foodName = item.name.toLowerCase();
        final categoryName = item.category.name.toLowerCase();

        return foodName.startsWith(nameRecherch) ||
            categoryName.startsWith(nameRecherch);
      }).toList());
      update();
    }
  }

  void searchClient(search) {
    customers.clear();
    update();
    if (search.isEmpty) {
      customers.addAll(customerInit);
      update();
    } else {
      final searchCustomers = search.toLowerCase();
      customers.addAll(customerInit.where((item) {
        final customerFirstname = item.firstname?.toLowerCase() ?? "";
        final customerLastname = item.lastname.toString().toLowerCase();
        final customerPhone = item.phone.toString().toLowerCase();

        return customerFirstname.startsWith(searchCustomers) ||
            customerLastname.startsWith(searchCustomers) ||
            customerPhone.startsWith(searchCustomers);
      }).toList());
      update();
    }
  }

  void fullCartAndUpdateOrder(BuildContext context, Order order) async {
    deleteCart();
    orderNotes.value = order.orderNotes!;
    for (var i = 0; i < order.orderProducts.length; i++) {
      Product food = order.orderProducts[i].product;

      if (food.price != order.orderProducts[i].price && food.hasVariants) {
        final foodVariant = food.variants.firstWhere(
            (element) => element.price == order.orderProducts[i].price);
        addCart(context, food, foodVariant, order.orderProducts[i].quantity,
            order.orderProducts[i].price, true);
        continue;
      }

      addCart(context, food, null, order.orderProducts[i].quantity,
          order.orderProducts[i].price, true);
    }
    setCurrentOrder(order);
    if (order.customerId != null) {
      //TODO :
      // customer.value = order.customer!;
    }

    orderNotes.value = order.orderNotes!;
    note.text = order.orderNotes!;

    AppHelpersCommon.showCustomModalBottomSheet(
      context: context,
      modal: const CartScreen(),
      isDarkMode: false,
      isDrag: true,
      radius: 12,
    );
  }
}
