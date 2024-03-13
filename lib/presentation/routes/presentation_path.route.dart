part of 'presentation_screen.route.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const DEMO_APP = _Paths.DEMO_APP;
  static const FIRST = _Paths.FIRST;
  static const NAVIGATION = _Paths.NAVIGATION;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = "/splash";
  static const DEMO_APP = "/demo_app";
  static const FIRST = "/first";
  static const NAVIGATION = "/navigation";
}
