import 'package:get/instance_manager.dart';
import 'package:Tajiri/presentation/controllers/demo/demo.controller.dart';

class DemoAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DemoAppController());
  }
}
