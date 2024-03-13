import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/http.service.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:ui' as ui;

import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppHelpers {
  AppHelpers._();

  static dynamic getUserInLocalStorage() {
    final dynamic user = LocalStorageService.instance.get(UserConstant.keyUser);

    if (user == null) {
      logoutApi();
      return null;
    }
    return user;
  }

  static logoutApi() async {
    HttpService server = HttpService();
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      await client.get(
        '/auth/logout/',
      );
      Mixpanel.instance
          .track("Logout", properties: {"Date": DateTime.now().toString()});
      Mixpanel.instance.reset();
      LocalStorageService.instance.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('==> login failure: $e');
    }
  }

  static showNoConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      backgroundColor: Style.brandGreen,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      content: Text(
        'No internet connection',
        style: Style.interNoSemi(
          size: 14,
          color: Style.white,
        ),
      ),
      action: SnackBarAction(
        label: 'Close',
        disabledTextColor: Style.black,
        textColor: Style.black,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showBottomSnackBar(BuildContext context, Widget content,
      Duration duration, bool isShowSnackBar) {
    final snackBar = SnackBar(
      content: content,
      backgroundColor: Style.secondaryColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
    );

    if (isShowSnackBar) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
  }

  static showCheckTopSnackBarInfoForm(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: text,
        ),
        onTap: onTap);
  }

  static double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection:
          ui.TextDirection.ltr, // Use TextDirection.ltr for left-to-right text
    )..layout(minWidth: 0, maxWidth: double.infinity);
    if (text.length <= 6) return textPainter.width + 22;
    return textPainter.width + 80;
  }

  static showCheckTopSnackBar(BuildContext context, String text) {
    return showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: "$text. Please check your credentials and try again",
      ),
    );
  }

  static showCheckTopSnackBarInfo(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return showTopSnackBar(
        context,
        CustomSnackBar.info(
          message: text,
        ),
        onTap: onTap);
  }

  static showCheckTopSnackBarDone(BuildContext context, String text) {
    return showTopSnackBar(
      context,
      CustomSnackBar.success(
        message: text,
      ),
    );
  }

  static double getOrderStatusProgress(String? status) {
    switch (status) {
      case 'new':
        return 0.2;
      case 'accepted':
        return 0.4;
      case 'ready':
        return 0.6;
      case 'on_a_way':
        return 0.8;
      case 'delivered':
        return 1;
      default:
        return 0.2;
    }
  }

  static String? getAppName() {
    /*  final List<SettingsData> settings = LocalStorage.instance.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'title') {
        return setting.value;
      }
    } */
    return '';
  }

  static bool getReferralActive() {
    /*  final List<SettingsData> settings = LocalStorage.instance.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'referral_active') {
        return setting.value == "1";
      }
    } */
    return false;
  }

  static String? getAppPhone() {
    /*  final List<SettingsData> settings = LocalStorage.instance.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'phone') {
        return setting.value;
      }
    } */
    return '';
  }

  static String? getPaymentType() {
    /*   final List<SettingsData> settings = LocalStorage.instance.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'payment_type') {
        return setting.value;
      }
    } */
    return 'admin';
  }

  static String? getAppAddressName() {
    /*  final List<SettingsData> settings = LocalStorage.instance.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'address') {
        return setting.value;
      }
    } */
    return '';
  }

  static String getTranslation(String trKey) {
    /*    final Map<String, dynamic> translations =
        LocalStorage.instance.getTranslations();
    for (final key in translations.keys) {
      if (trKey == key) {
        return translations[key];
      }
    } */
    return trKey;
  }

  static String getTranslationReverse(String trKey) {
    /*    final Map<String, dynamic> translations =
        LocalStorage.instance.getTranslations();
    for (int i = 0; i < translations.values.length; i++) {
      if (trKey == translations.values.elementAt(i)) {
        return translations.keys.elementAt(i);
      }
    } */
    return trKey;
  }

  static bool checkIsSvg(String? url) {
    if (url == null || (url.length) < 3) {
      return false;
    }
    final length = url.length;
    return url.substring(length - 3, length) == 'svg';
  }

  static double? getInitialLatitude() {
    /*   final List<SettingsData> settings = LocalStorage.instance.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString =
            setting.value?.substring(0, setting.value?.indexOf(','));
        if (latString == null) {
          return null;
        }
        final double? lat = double.tryParse(latString);
        return lat;
      }
    } */
    return null;
  }

  static double? getInitialLongitude() {
    /*   final List<SettingsData> settings = LocalStorage.instance.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString =
            setting.value?.substring(0, setting.value?.indexOf(','));
        if (latString == null) {
          return null;
        }
        final String? lonString = setting.value
            ?.substring((latString.length) + 2, setting.value?.length);
        if (lonString == null) {
          return null;
        }
        final double? lon = double.tryParse(lonString);
        return lon;
      }
    } */
    return null;
  }

  static void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget modal,
    required bool isDarkMode,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 200,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Style.transparent,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: modal,
      ),
    );
  }

  static void showAlertDialog({
    required BuildContext context,
    required Widget child,
    bool canPop = true,
    double radius = 16,
  }) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Style.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius.r),
        ),
      ),
      contentPadding: EdgeInsets.all(20.r),
      iconPadding: EdgeInsets.zero,
      content: PopScope(
        canPop: canPop,
        child: child,
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: canPop,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showAlertVideoDemoDialog({
    required BuildContext context,
    required Widget child,
  }) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: child,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
