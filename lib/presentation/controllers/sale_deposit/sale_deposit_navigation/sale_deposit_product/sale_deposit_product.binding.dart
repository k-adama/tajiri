import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_product/sale_deposit_product.controller.dart';

class SaleDepositProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleDepositProductController());
  }
}
