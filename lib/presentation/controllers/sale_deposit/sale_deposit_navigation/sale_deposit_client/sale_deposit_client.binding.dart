import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_client/sale_deposit_client.controller.dart';

class SaleDepositClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleDepositClientController());
  }
}
