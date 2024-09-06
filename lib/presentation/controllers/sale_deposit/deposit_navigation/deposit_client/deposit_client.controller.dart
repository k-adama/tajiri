import 'package:get/get.dart';

class DepositClientController extends GetxController {
  // Simuler une API qui récupère 10 éléments
  Future<List<String>> fetchOrdersFromApi(int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 2)); // Simuler un délai
    return List.generate(
        pageSize, (index) => 'Order ${(page - 1) * pageSize + index + 1}');
  }
}
