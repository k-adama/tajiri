import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tajiri_pos_mobile/domain/entities/tutoriel.entity.dart';

class TutorielsController extends GetxController {
  RxList<TutorielEntity> tutoriels = List<TutorielEntity>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchTutoriels();
  }

  Future<dynamic> fetchTutoriels() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('tutoriels').select('*');
    final json = response as List<dynamic>;
    final tutorielsResponse =
        json.map((item) => TutorielEntity.fromJson(item)).toList();
    tutoriels.assignAll(tutorielsResponse);
  }
}
