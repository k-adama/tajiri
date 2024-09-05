import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_pos/deposit_pos.controller.dart';

class DepositPosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DepositPosController());
  }
}
