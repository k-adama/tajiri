import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sales_reports/sales_reports.controller.dart';

class SalesReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesReportController());
    // Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => PosController());
  }
}
