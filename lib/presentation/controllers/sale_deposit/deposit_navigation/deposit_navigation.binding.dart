import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_client/deposit_client.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_pos/deposit_pos.controller.dart';

class DepositNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DepositNavigationController());
    Get.lazyPut(() => DepositClientController());
    Get.lazyPut(() => DepositPosController());
    Get.lazyPut(() => DepositPosController());
  }
}
