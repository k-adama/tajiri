import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_client/deposit_client.controller.dart';

class DepositClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DepositClientController());
  }
}
