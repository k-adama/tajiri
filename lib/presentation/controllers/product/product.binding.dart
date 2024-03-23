import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductsController());
  }
}
