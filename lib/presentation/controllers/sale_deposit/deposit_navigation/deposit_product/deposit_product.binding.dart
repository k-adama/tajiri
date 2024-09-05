import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_product/sale_deposit_product.controller.dart';

class DepositProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DepositProductController());
  }
}
