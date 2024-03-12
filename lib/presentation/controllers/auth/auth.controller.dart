
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajiri_pos_mobile/app/services/app_validators.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  String password = "";
  String email = "";
  String name = "";
  bool isLoginError = false;
  bool isEmailNotValid = false;
  bool isNameNotValid = false;
  bool isPasswordNotValid = false;
  bool showPassword = false;
  bool isKeepLogin = false;

  void setPassword(String text) {
    password = text.trim();
    isLoginError = false;
    isEmailNotValid = false;
    isPasswordNotValid = false;
    update();
  }

  void setEmail(String text) {
    email = text.trim();
    isLoginError = false;
    isEmailNotValid = false;
    isPasswordNotValid = false;
    update();
  }

  void setName(String text) {
    name = text.trim();
    isLoginError = false;
    isNameNotValid = false;
    update();
  }

  void setShowPassword(bool show) {
    showPassword = show;
    update();
  }

  checkEmail() {
    return AppValidators.isValidEmail(email);
  }

  Future<void> login(BuildContext context) async {
    
  }
}