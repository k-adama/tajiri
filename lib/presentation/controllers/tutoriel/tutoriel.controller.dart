import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class TutorielsController extends GetxController {
  RxList<Tutorial> tutoriels = List<Tutorial>.empty().obs;

  final user = AppHelpersCommon.getUserInLocalStorage();
  String? get restaurantId => user?.restaurantId;

  final tajiriSdk = TajiriSDK.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTutoriels();
  }

  Future<dynamic> fetchTutoriels() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        update();
        final result =
            await tajiriSdk.tutorialsService.getTutorials(restaurantId!);
        tutoriels.assignAll(result);
        update();
      } catch (e, s) {
        print("Error : $e");
        print("StackTrace : $s");
        update();
      }
    }
  }
}
