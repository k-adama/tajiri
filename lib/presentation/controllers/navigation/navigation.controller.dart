import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';

class NavigationController extends GetxController {
  bool isScrolling = false;
  int selectIndex = 0;
  bool activeCart = false;

  @override
  void onInit() {
    super.onInit();
  }

  void selectIndexFunc(int index) {
    selectIndex = index;
    update();
  }

  bool checkGuest() {
    final String token =
        LocalStorageService.instance.get(AuthConstant.keyToken) ?? "";
    return token.isEmpty;
  }

  void changeScrolling(bool isScrolling) {
    isScrolling = isScrolling;
    update();
  }

  void changeActiveCart(bool isScrolling) {
    activeCart = isScrolling;
    update();
  }
}
