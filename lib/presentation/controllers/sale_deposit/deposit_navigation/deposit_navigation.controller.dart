import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/deposit_add_client.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_product/deposit_add_product.screen.dart';

class DepositNavigationController extends GetxController {
  int selectIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  void selectIndexFunc(int index) {
    selectIndex = index;
    update();
  }

  addIconTap() {
    if (selectIndex == 0) {
      Get.to(const DepositAddClientScreen());
    } else if (selectIndex == 2) {
      Get.to(const DepositAddProductScreen());
    }
  }
}
