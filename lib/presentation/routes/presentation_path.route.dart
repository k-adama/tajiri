part of 'presentation_screen.route.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const SPLASH = _Paths.SPLASH;
  static const DEMO_APP = _Paths.DEMO_APP;
  static const FIRST = _Paths.FIRST;
  static const NAVIGATION = _Paths.NAVIGATION;
  static const DEMO_LOGIN = _Paths.DEMO_LOGIN;
  static const TUTORIELS = _Paths.TUTORIELS;
  static const CART_PAID = _Paths.CART_PAID;
  static const CART_SAVE = _Paths.CART_SAVE;
  static const INVOICE = _Paths.INVOICE;
}

abstract class _Paths {
  _Paths._();

  static const LOGIN = '/login';
  static const SPLASH = "/splash";
  static const DEMO_APP = "/demo_app";
  static const FIRST = "/first";
  static const NAVIGATION = "/navigation";
  static const DEMO_LOGIN = "/demo_login";
  static const TUTORIELS = "/tutoriels";
  static const CART_PAID = "/cart_paid";
  static const CART_SAVE = "/cart_save";
  static const INVOICE = "/invoice";
}
