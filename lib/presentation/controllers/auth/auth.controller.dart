import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/restaurant.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/app/services/app_validators.service.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

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
  final tajiriSdk = TajiriSDK.instance;

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
      try {
        final response = await tajiriSdk.authService.login(email, password);
        final user = await tajiriSdk.staffService.getStaff("me");
        final restaurant =
            await tajiriSdk.restaurantsService.getRestaurant(user.restaurantId);

        await Future.wait([
          LocalStorageService.instance
              .set(AuthConstant.keyToken, response.token),
          LocalStorageService.instance
              .set(UserConstant.keyUser, jsonEncode(user)),
          LocalStorageService.instance
              .set(RestaurantConstant.keyRestaurant, jsonEncode(restaurant))
        ]);

        isLoading = false;
        update();

        user.toJson().forEach((key, value) {
          Mixpanel.instance.getPeople().set(key, value);
        });

        Mixpanel.instance.identify(user.id);
        Mixpanel.instance.getGroup("Restaurant ID", user.restaurantId);
        Mixpanel.instance.setGroup("Restaurant Name", restaurant.name);
        Mixpanel.instance.track('Login',
            properties: {"Method used": "Phone", "Status": "Succes"});
        Get.offAllNamed(Routes.NAVIGATION);
      } catch (e) {
        isLoading = false;
        update();
        Mixpanel.instance.track('Login',
            properties: {"Method used": "Phone", "Status": "Faillure"});
        AppHelpersCommon.showCheckTopSnackBar(
          context,
          e.toString(),
        );
        isLoading = false;
        update();
      }
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
      try {
        final response = await tajiriSdk.authService.demo(name, email);
        final user = await tajiriSdk.staffService.getStaff("me");
        final restaurant =
            await tajiriSdk.restaurantsService.getRestaurant(user.restaurantId);
        await Future.wait([
          LocalStorageService.instance
              .set(AuthConstant.keyToken, response.token),
          LocalStorageService.instance.set(AuthConstant.keyIsDemo, "true"),
          LocalStorageService.instance
              .set(UserConstant.keyUser, jsonEncode(user)),
          LocalStorageService.instance
              .set(RestaurantConstant.keyRestaurant, jsonEncode(restaurant))
        ]);

        isLoading = false;
        update();

        user.toJson().forEach((key, value) {
          Mixpanel.instance.getPeople().set(key, value);
        });

        Mixpanel.instance.identify(user.id);
        Mixpanel.instance.getGroup("Restaurant ID", user.restaurantId);
        Mixpanel.instance.setGroup("Restaurant Name", restaurant.name);
        Mixpanel.instance.track('Login',
            properties: {"Method used": "Phone", "Status": "Succes"});
        Get.offAllNamed(Routes.NAVIGATION);
      } catch (e, s) {
        isLoading = false;
        update();
        Mixpanel.instance.track('Login',
            properties: {"Method used": "Phone", "Status": "Faillure"});
        AppHelpersCommon.showCheckTopSnackBar(
          context,
          e.toString(),
        );
        print("Error $e; stack $s");
        isLoading = false;
        update();
      }
    }
  }
}
