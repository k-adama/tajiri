import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/fisrt/fisrt.controller.dart';

class FirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirstController());
  }
}
