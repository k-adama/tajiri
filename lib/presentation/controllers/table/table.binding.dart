import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';

class TableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TableController());
  }
}
