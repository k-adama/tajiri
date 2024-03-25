import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';

class WaitressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaitressController());
  }
}
