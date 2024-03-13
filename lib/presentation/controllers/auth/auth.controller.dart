
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.dart';
import 'package:tajiri_pos_mobile/app/services/app_helpers.dart';
import 'package:tajiri_pos_mobile/app/services/app_validators.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/data/repositories/auth/auth.repository.dart';

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

  final AuthRepository _authRepository = AuthRepository();

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

  Future<void> getUser(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();

    if (connected) {
      final response = await _authRepository.getProfileDetails();
      response.when(
        success: (data) async {
          LocalStorageService.instance.set(UserConstant.keyUser,jsonEncode(data) ?? "");
          isLoading = false;
          update();
          var profile = {
            'Name': '${data?.firstname} ${data?.lastname}',
            'first_name': '${data?.firstname}',
            'last_name': '${data?.lastname}',
            "Id": data?.id,
            'Phone': data?.phone,
            'Gender': data?.gender,
            "Restaurant Name": data?.restaurantUser?[0].restaurant?.name
          };

          Mixpanel.instance.identify(data?.id as String);
          profile.forEach((key, value) {
            Mixpanel.instance.getPeople().set(key, value);
          });

          Mixpanel.instance.getGroup("Restaurant ID",
              data?.restaurantUser?[0].restaurant?.id as String);
          Mixpanel.instance.setGroup("Restaurant Name",
              data?.restaurantUser?[0].restaurant?.name as String);

          Mixpanel.instance.track('Login',
              properties: {"Method used": "Phone", "Status": "Succes"});

          OneSignal.shared.setSMSNumber(smsNumber: "+225${data?.phone}");
          OneSignal.shared.sendTags({
            "Restaurant":
            data?.restaurantUser?[0].restaurant?.name as String
          });
          OneSignal.shared.setExternalUserId(data?.id as String);
          //Get.offAllNamed(Routes.MAIN);
        },
        failure: (failure, status) {
          Mixpanel.instance.track('Login',
              properties: {"Method used": "Phone", "Status": "Faillure"});
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        },
      );
    }
  }

  Future<void> login(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (checkEmail()) {
        if (!AppValidators.isValidEmail(email)) {
          isEmailNotValid = true;
          update();
          return;
        }
      }

      if (!AppValidators.isValidPassword(password)) {
        isPasswordNotValid = true;
        update();
        return;
      }
      isLoading = true;
      update();
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      response.when(
        success: (data) async {
          LocalStorageService.instance.set(AuthConstant.keyToken,data?.token ?? "");
          await getUser(context);
        },
        failure: (failure, status) {
          isLoading = false;
          isLoginError = true;
          update();
          Mixpanel.instance.track('Login',
              properties: {"Method used": "Phone", "Status": "Faillure"});
          AppHelpers.showCheckTopSnackBar(
            context,
            status.toString(),
          );
        },
      );
    }
  }
}