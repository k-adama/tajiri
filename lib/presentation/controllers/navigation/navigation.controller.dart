import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/product_in_cart.widget.dart';

class NavigationController extends GetxController {
  bool isScrolling = false;
  int selectIndex = 0;
  bool activeCart = false;

  final posController = Get.find<PosController>();

  @override
  void onInit() {
    super.onInit();
  }

  void selectIndexFunc(int index) {
    selectIndex = index;

    update();
    final context = Get.context!;
    if (index == 1 && posController.cartItemList.isNotEmpty) {
      AppHelpersCommon.showBottomSnackBar(
        context,
        const ProductInCartWidget(),
        AppConstants.productCartSnackbarDuration,
        true,
      );
    } else {
      AppHelpersCommon.removeCurrentSnackBar(context);
    }
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
