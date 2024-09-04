import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/sale_deposit_pos/components/sale_deposit_categorie_food.component.dart';

class SaleDepositPosController extends GetxController {
  final productIsLoad = false.obs;

  final categories = List<SaleDepositCategorieFood>.empty().obs;
  RxString categoryId = 'all'.obs;

  @override
  void onInit() {
    categories.value = SaleDepositCategorieFood.categories;

    super.onInit();
  }

  void handleFilter(String id, String categoryName) {
    categoryId.value = id;
    update();
  }
}
