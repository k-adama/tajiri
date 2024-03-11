import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    getToken();
    super.onReady();
  }

  Future<void> getToken() async {
    final storage = LocalStorageService.instance;

    if (storage == null) {
      Get.offAllNamed(Routes.DEMO_APP);
      FlutterNativeSplash.remove();
      return;
    }
    if (storage.get(AuthConstant.keyToken) == null) {
      if (storage.get(AuthConstant.keyOnboarding) != null) {
        Get.offAllNamed(Routes.FIRST);
        // print("first");
      } else {
        // print("demo");
        Get.offAllNamed(Routes.DEMO_APP); //LOGIN
      }
    } else {
      print("Aucune page");
      //Get.offAllNamed(Routes.MAIN);
    }
    FlutterNativeSplash.remove();
  }
}
