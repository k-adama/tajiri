import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';

class LocalStorageService {
  static SharedPreferences? _preferences;

  LocalStorageService._();

  static LocalStorageService? _localStorage;

  static LocalStorageService instance = LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    if (_localStorage == null) {
      _localStorage = LocalStorageService._();
      await _localStorage!._init();
    }
    return _localStorage!;
  }

  static Future<SharedPreferences> getSharedPreferences() async {
    if (_preferences == null) {
      _localStorage = LocalStorageService._();
      await _localStorage!._init();
    }
    return _preferences!;
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? get(String key) {
    return _preferences?.getString(key);
  }

  Future<void> set(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  void delete(String key) {
    _preferences?.remove(key);
  }

  bool getAppThemeMode() =>
      _preferences?.getBool(AppConstants.keyAppThemeMode) ?? false;

  void logout(){
    delete(AuthConstant.keyToken);
    delete(UserConstant.keyUser);
  }
}

