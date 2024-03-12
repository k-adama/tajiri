import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';

class NavigationBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
  }
}
