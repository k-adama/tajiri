import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/bluetooth_setting/bluetooth_setting.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';

class NavigationBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PosController());
    Get.lazyPut(() => TableController(), fenix: true);
    Get.lazyPut(() => WaitressController(), fenix: true);
    Get.lazyPut(() => BluetoothSettingController(), fenix: true);
    Get.lazyPut(() => OrdersController());
  }
}
