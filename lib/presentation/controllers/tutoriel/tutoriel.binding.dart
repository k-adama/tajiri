import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/tutoriel/tutoriel.controller.dart';

class TutorielsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TutorielsController());
  }
}
