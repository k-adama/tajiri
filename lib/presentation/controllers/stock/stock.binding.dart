import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';

class StockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StockController());
  }
}
