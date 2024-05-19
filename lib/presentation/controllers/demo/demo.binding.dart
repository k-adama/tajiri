import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/auth/auth.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/demo/demo.controller.dart';

class DemoAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DemoAppController());
    Get.lazyPut(() => AuthController());
  }
}
