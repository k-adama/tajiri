import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:Tajiri/presentation/controllers/demo/demo.binding.dart';
import 'package:Tajiri/presentation/controllers/fisrt/first.binding.dart';
import 'package:Tajiri/presentation/controllers/splash/splash.binding.dart';
import 'package:Tajiri/presentation/screens/demo/demo.screen.dart';
import 'package:Tajiri/presentation/screens/first/first.screen.dart';
import 'package:Tajiri/presentation/screens/splash/splash.screen.dart';

part 'presentation_path.route.dart';

class PresentationScreenRoute {
  PresentationScreenRoute._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.DEMO_APP,
      page: () => const DemoAppScreen(),
      binding: DemoAppBinding(),
    ),
    GetPage(
      name: _Paths.FIRST,
      page: () => const FirstScreen(),
      binding: FirstBinding(),
    ),
  ];
}
