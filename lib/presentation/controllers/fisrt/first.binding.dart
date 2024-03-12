import 'package:get/instance_manager.dart';
import 'package:Tajiri/presentation/controllers/fisrt/fisrt.controller.dart';

class FirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirstController());
  }
}
