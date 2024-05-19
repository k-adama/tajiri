import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosController());
  }
}
