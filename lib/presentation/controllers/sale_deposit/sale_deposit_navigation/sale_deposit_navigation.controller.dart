import 'package:get/get.dart';

class SaleDepositNavigationController extends GetxController {
  int selectIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  void selectIndexFunc(int index) {
    selectIndex = index;
    update();
  }
}
