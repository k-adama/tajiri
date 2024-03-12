import 'package:get/instance_manager.dart';
import 'package:Tajiri/presentation/controllers/splash/splash.controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
