import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_client/sale_deposit_client.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_pos/sale_deposit_pos.controller.dart';

class SaleDepositNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleDepositNavigationController());
    Get.lazyPut(() => SaleDepositClientController());
    Get.lazyPut(() => SaleDepositPosController());
    Get.lazyPut(() => SaleDepositPosController());
  }
}
