import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/app/services/app_validators.service.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/data/repositories/auth/auth.repository.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:get/route_manager.dart';

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
    return AppValidatorsService.isValidEmail(email);
  }

  Future<void> getUser(BuildContext context) async {
    final connected = await AppConnectivityService.connectivity();

    if (connected) {
      final response = await _authRepository.getProfileDetails();
      response.when(
        success: (data) async {
          LocalStorageService.instance
              .set(UserConstant.keyUser, jsonEncode(data));
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

          Mixpanel.instance.getGroup(
              "Restaurant ID", data?.restaurantUser?[0].restaurant?.id ?? "");
          Mixpanel.instance.setGroup("Restaurant Name",
              data?.restaurantUser?[0].restaurant?.name ?? "");

          Mixpanel.instance.track('Login',
              properties: {"Method used": "Phone", "Status": "Succes"});

          OneSignal.shared.setSMSNumber(smsNumber: "+225${data?.phone ?? ""}");
          OneSignal.shared.sendTags(
              {"Restaurant": data?.restaurantUser?[0].restaurant?.name ?? ""});
          OneSignal.shared.setExternalUserId(data?.id ?? "");
          Get.offAllNamed(Routes.NAVIGATION);
        },
        failure: (failure, status) {
          print("===================================== IN GetUser Failure");
          Mixpanel.instance.track('Login',
              properties: {"Method used": "Phone", "Status": "Faillure"});
          AppHelpersCommon.showCheckTopSnackBar(
            context,
            AppHelpersCommon.getTranslation(status.toString()),
          );
        },
      );
    }
  }

  Future<void> login(BuildContext context) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      if (checkEmail()) {
        if (!AppValidatorsService.isValidEmail(email)) {
          isEmailNotValid = true;
          update();
          return;
        }
      }

      if (!AppValidatorsService.isValidPassword(password)) {
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
          LocalStorageService.instance
              .set(AuthConstant.keyToken, data?.token ?? "");
          await getUser(context);
        },
        failure: (failure, status) {
          isLoading = false;
          isLoginError = true;
          update();
          Mixpanel.instance.track('Login',
              properties: {"Method used": "Phone", "Status": "Faillure"});
          AppHelpersCommon.showCheckTopSnackBar(
            context,
            status.toString(),
          );
        },
      );
    }
  }

  Future<void> demoAuth(BuildContext context) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      if (name.isEmpty || name.length <= 2) {
        isNameNotValid = true;
        update();
        AppHelpersCommon.showCheckTopSnackBarInfo(
            context, "Entrez un nom valide ");
        return;
      }

      if (email.isEmpty || email.length < 10) {
        isEmailNotValid = true;
        update();
        AppHelpersCommon.showCheckTopSnackBarInfo(
            context, "Entrez un numéro de téléphone valide ");
        return;
      }
      isLoading = true;
      update();

      final response = await _authRepository.demoSend(
        name: name,
        phone: email,
      );

      //Connect demo account
      response.when(
        success: (data) async {
          LocalStorageService.instance
              .set(AuthConstant.keyToken, data?.token ?? "");
          LocalStorageService.instance.set(AuthConstant.keyIsDemo, "true");
          await getUser(context);
        },
        failure: (failure, status) {
          isLoading = false;
          isLoginError = true;
          update();
          Mixpanel.instance.track('Login',
              properties: {"Method used": "Phone", "Status": "Faillure"});
          AppHelpersCommon.showCheckTopSnackBar(
            context,
            status.toString(),
          );
        },
      );
    }
  }
}
