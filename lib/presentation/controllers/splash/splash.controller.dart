import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    getToken();
    super.onReady();
  }

  Future<void> getToken() async {
    final storage = LocalStorageService.instance;

    if (storage == null) {
      /*Get.offAllNamed(Routes.DEMO_APP);
      FlutterNativeSplash.remove();*/
      return;
    }

    /*if (storage.getToken().isEmpty) {
      if (storage.getOnboarding() != null) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.DEMO_APP); //LOGIN
      }
    } else {
      Get.offAllNamed(Routes.MAIN);
    }
    FlutterNativeSplash.remove();*/
  }
}
