import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/auth/auth.binding.dart';
import 'package:tajiri_pos_mobile/presentation/screens/auth/login.screen.dart';

part 'presentation_path.route.dart';

class PresentationScreenRoute {
  PresentationScreenRoute._();
  static const INITIAL = Routes.LOGIN;
  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
       page: ()=>LoginScreen(),
       binding: AuthBinding()
       )
  ];
}