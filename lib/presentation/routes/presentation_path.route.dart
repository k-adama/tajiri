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
  static const SALES_REPORT = _Paths.SALES_REPORT;
  static const SALES_REPORT_DATE_TIME_PICKER =
      _Paths.SALES_REPORT_DATE_TIME_PICKER;
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
  static const SALES_REPORT = "/sales_report";
  static const SALES_REPORT_DATE_TIME_PICKER = "/sales_report_date_time_picker";
}
