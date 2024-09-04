part of 'presentation_screen.route.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const SPLASH = _Paths.SPLASH;
  static const DEMO_APP = _Paths.DEMO_APP;
  static const CHOOSE_ROLE = _Paths.CHOOSE_ROLE;

  static const NAVIGATION = _Paths.NAVIGATION;
  static const SALE_DEPOSIT_NAVIGATION = _Paths.SALE_DEPOSIT_NAVIGATION;

  static const DEMO_LOGIN = _Paths.DEMO_LOGIN;
  static const TUTORIELS = _Paths.TUTORIELS;
  static const SALES_REPORT = _Paths.SALES_REPORT;
  static const SALES_REPORT_DATE_TIME_PICKER =
      _Paths.SALES_REPORT_DATE_TIME_PICKER;
  static const CART_PAID = _Paths.CART_PAID;
  static const CART_SAVE = _Paths.CART_SAVE;
  static const INVOICE = _Paths.INVOICE;
  static const STOCK = _Paths.STOCK;
  static const TABLE = _Paths.TABLE;
  static const EDIT_TABLE = _Paths.EDIT_TABLE;
  static const WAITRESS = _Paths.WAITRESS;
  static const SETTING_BLUETOOTH = _Paths.SETTING_BLUETOOTH;
  static const EDIT_WAITRESS = _Paths.EDIT_WAITRESS;
  static const PRODUCTS = _Paths.PRODUCTS;
  static const EDIT_FOOD_AND_VARIANT = _Paths.EDIT_FOOD_AND_VARIANT;
  static const ADD_FOOD_VARIANT_CATEGORY = _Paths.ADD_FOOD_VARIANT_CATEGORY;
}

abstract class _Paths {
  _Paths._();

  static const LOGIN = '/login';
  static const SPLASH = "/splash";
  static const DEMO_APP = "/demo_app";
  static const CHOOSE_ROLE = "/chosse_role";

  static const NAVIGATION = "/navigation";
  static const SALE_DEPOSIT_NAVIGATION = "/sale_deposit_navigation";
  static const DEMO_LOGIN = "/demo_login";
  static const TUTORIELS = "/tutoriels";
  static const SALES_REPORT = "/sales_report";
  static const SALES_REPORT_DATE_TIME_PICKER = "/sales_report_date_time_picker";
  static const CART_PAID = "/cart_paid";
  static const CART_SAVE = "/cart_save";
  static const INVOICE = "/invoice";
  static const STOCK = '/stock';
  static const TABLE = "/table";
  static const EDIT_TABLE = "/edit_table";
  static const WAITRESS = "/waitress";
  static const SETTING_BLUETOOTH = "/settings_bluetooth";
  static const EDIT_WAITRESS = "/edit_waitress";
  static const PRODUCTS = "/products";
  static const EDIT_FOOD_AND_VARIANT = "/edit_food_and_variant";
  static const ADD_FOOD_VARIANT_CATEGORY = "/add_food_variant_category";
}
