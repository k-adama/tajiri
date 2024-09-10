import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/local_cart_enties/bag_data.entity.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/components/deposit_categorie_food.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull_second.dialog.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class DepositPosController extends GetxController {
  RxInt priceAddFood = 0.obs;
  int quantityAddFood = 1;
  final isProductLoading = true.obs;
  final createOrderLoading = false.obs;

  final products = List<Product>.empty().obs;
  final productsInit = List<Product>.empty().obs;

  Product? productDataInCart;

  final categories = List<SaleDepositCategorieFood>.empty().obs;
  RxString categoryId = 'all'.obs;

  // cart
  RxInt selectedBagIndex =
      0.obs; // toujours le seul pannier selectionné par default ici
  RxList<BagDataEntity> bags =
      <BagDataEntity>[BagDataEntity(index: 0, bagProducts: [])].obs;

  BagDataEntity get selectbag => bags[selectedBagIndex.value];
  final selectbagProductsLength = 0.obs;

  final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  String? get restaurantId => user?.restaurantId;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onInit() {
    fetchCategories();
    fetchProducts();
    super.onInit();
  }

  void handleFilter(String id, String categoryName) {
    categoryId.value = id;
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
    categories.value = SaleDepositCategorieFood.categories;

    // final connected = await AppConnectivityService.connectivity();
    // if (connected) {
    //   isProductLoading.value = true;
    //   update();

    //   final newCategories =
    //       await tajiriSdk.categoriesService.getCategories(restaurantId!);
    //   newCategories.insert(
    //     0,
    //     Category(
    //       id: "all",
    //       name: "Tout",
    //       imageUrl: '🗂️',
    //       restaurantId: '',
    //       mainCategoryId: '',
    //     ),
    //   );
    //   newCategories.insert(
    //     newCategories.length,
    //     Category(
    //       id: KIT_ID,
    //       name: "Packs de vente",
    //       imageUrl: '🎁',
    //       restaurantId: '',
    //       mainCategoryId: '',
    //     ),
    //   );
    //   categories.assignAll(newCategories);
    //   handleFilter("all", "all");
    //   isProductLoading.value = false;
    //   update();
    // }
  }

  saveOrder(BuildContext context) {
    createOrderLoading.value = true;
    createOrderLoading.value = false;
    AppHelpersCommon.showAlertDialog(
      context: context,
      canPop: false,
      child: SuccessfullSecondDialog(
        content: 'La commande à bien été enregistrée au compte du client.',
        title: "Commande enregistrée",
        redirect: () {},
        asset: "assets/svgs/confirmOrderIcon.svg",
        button: CustomButton(
          isUnderline: true,
          textColor: Style.bluebrandColor,
          background: tajiriDesignSystem.appColors.mainBlue50,
          underLineColor: Style.bluebrandColor,
          title: 'Prendre une nouvelle commande',
          onPressed: () {
            Get.close(2);
          },
        ),
        closePressed: () {
          Get.close(2);
        },
      ),
    );
  }

  fieldModalProductToUpdateProductAndReturnSelectId(
      BuildContext context, String? itemId) {
    var existingProductIndex =
        selectbag.bagProducts.indexWhere((item) => item.itemId == itemId);

    //
    final selectBagProducts = selectbag.bagProducts[existingProductIndex];
    quantityAddFood = selectBagProducts.quantity!;
    setPriceAddFood(selectBagProducts.price!);

    setProductDataInCart(selectBagProducts.depositProduct!);

    update();
  }

  void removeItemInBag(DepositCartItem item) {
    if (selectedBagIndex.value < bags.length) {
      final product = selectbag.bagProducts
          .firstWhereOrNull((product) => product.itemId == item.itemId);

      selectbag.bagProducts.remove(product);

      bags[selectedBagIndex.value] = selectbag;

      calculateBagProductTotal(); // Recalculer le total après la suppression de l'item
      selectbagProductsLength.value = selectbag.bagProducts.length;
      update();
    }
  }

  setPriceAddFood(int value) {
    priceAddFood.value = value;
    update();
  }

  void handleAddModalFoodInCartItemInitialState() {
    quantityAddFood = 1;
    priceAddFood.value = 0;
    update();
  }

  setProductDataInCart(Product foodDataEntity) {
    productDataInCart = foodDataEntity;
    update();
  }

  double calculateBagProductTotal() {
    if (selectedBagIndex.value < bags.length) {
      double total = 0.0;
      for (var item in selectbag.bagProducts) {
        total += (item.price ?? 0) * (item.quantity ?? 0);
      }

      return total;
    }
    return 0;
  }
}
