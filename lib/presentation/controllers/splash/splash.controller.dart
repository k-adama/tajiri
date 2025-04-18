import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';

class SplashController extends GetxController {
  Future<void> getToken() async {
    final storage = LocalStorageService.instance;
    Get.offAllNamed(Routes.CHOOSE_ROLE);

    // if (storage.get(AuthConstant.keyToken) == null) {
    //   if (storage.get(AuthConstant.keyOnboarding) != null) {
    //     Get.offAllNamed(Routes.LOGIN); //LOGIN
    //   } else {
    //     Get.offAllNamed(Routes.DEMO_APP);
    //   }
    // } else {
    //   Get.offAllNamed(Routes.NAVIGATION);
    // }
  }
}
