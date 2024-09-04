import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_pos/sale_deposit_pos.controller.dart';

class SaleDepositPosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleDepositPosController());
  }
}
