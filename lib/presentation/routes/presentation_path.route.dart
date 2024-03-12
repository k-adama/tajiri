part of 'presentation_screen.route.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
}

abstract class _Paths {
  _Paths._();

  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
}