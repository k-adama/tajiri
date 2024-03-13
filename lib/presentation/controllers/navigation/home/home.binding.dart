import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => OrdersController());
    // Get.lazyPut(() => PosController());
  }
}
