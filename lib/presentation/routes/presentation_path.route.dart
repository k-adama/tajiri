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
  static const PRODUCTS = _Paths.PRODUCTS;
  static const EDIT_FOOD_AND_VARIANT = _Paths.EDIT_FOOD_AND_VARIANT;
  static const ADD_FOOD_VARIANT_CATEGORY = _Paths.ADD_FOOD_VARIANT_CATEGORY;
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
  static const PRODUCTS = "/products";
  static const EDIT_FOOD_AND_VARIANT = "/edit_food_and_variant";
  static const ADD_FOOD_VARIANT_CATEGORY = "/add_food_variant_category";
}
