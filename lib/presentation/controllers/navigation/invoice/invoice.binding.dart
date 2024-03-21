import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/invoice/invoice.controller.dart';

class InvoiceBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InvoiceController());
  }
}
