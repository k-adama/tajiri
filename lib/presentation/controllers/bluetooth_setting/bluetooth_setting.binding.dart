import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/bluetooth_setting/bluetooth_setting.controller.dart';

class BluetoothSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BluetoothSettingController());
  }
}
