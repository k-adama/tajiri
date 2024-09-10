import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_pos/deposit_cart/deposit_cart.controller.dart';

class DepositCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DepositCartController());
  }
}
