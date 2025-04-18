import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/constants/restaurant.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'dart:ui' as ui;

class AppHelpersCommon {
  AppHelpersCommon._();

  static Staff? getUserInLocalStorage() {
    final userEncoding = LocalStorageService.instance.get(UserConstant.keyUser);
    if (userEncoding == null) {
      // logoutApi();
      return null;
    }
    final user = Staff.fromJson(
        jsonDecode(LocalStorageService.instance.get(UserConstant.keyUser)!));
    return user;
  }

  static Restaurant? getRestaurantInLocalStorage() {
    final restoEncoding =
        LocalStorageService.instance.get(RestaurantConstant.keyRestaurant);
    if (restoEncoding == null) {
      return null;
    }
    final resto = Restaurant.fromJson(jsonDecode(
        LocalStorageService.instance.get(RestaurantConstant.keyRestaurant)!));
    return resto;
  }

  static String? getPrinterMacAdress() {
    final macAdress =
        LocalStorageService.instance.get(UserConstant.keyMacAdress);
    return macAdress;
  }

  static setPrinterMacAdress(String? adress) {
    if (adress != null) {
      LocalStorageService.instance.set(UserConstant.keyMacAdress, adress);
    }
  }

  static deletePrinterMacAdress() {
    LocalStorageService.instance.delete(UserConstant.keyMacAdress);
  }

  // Paper Size

  /// value of [mm58] = is 1;
  /// value of [mm80] = is 2;
  /// value of [mm72] = is 3;
  static Future<PaperSize?> getPaperSize() async {
    final paperSize =
        LocalStorageService.instance.getInt(UserConstant.keyPaperSize);

    if (paperSize == PaperSize.mm58.value) {
      return PaperSize.mm58;
    } else if (paperSize == PaperSize.mm80.value) {
      return PaperSize.mm80;
    } else if (paperSize == PaperSize.mm72.value) {
      return PaperSize.mm72;
    }
    return null;
  }

  static setPaperSize(int? paperSizeValue) {
    if (paperSizeValue != null) {
      LocalStorageService.instance
          .setInt(UserConstant.keyPaperSize, paperSizeValue);
    }
  }

  static deletePaperSize() {
    LocalStorageService.instance.delete(UserConstant.keyPaperSize);
  }

  static logoutApi() async {
    try {
      Mixpanel.instance
          .track("Logout", properties: {"Date": DateTime.now().toString()});
      Mixpanel.instance.reset();
      Get.offAllNamed(Routes.LOGIN);
      LocalStorageService.instance.logout();
    } catch (e) {
      print('==> login failure: $e');
    }
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
      removeCurrentSnackBar(context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      removeCurrentSnackBar(context);
    }
  }

  static removeCurrentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  static bool checkIsSvg(String? url) {
    if (url == null || (url.length) < 3) {
      return false;
    }
    final length = url.length;
    return url.substring(length - 3, length) == 'svg';
  }

  // MODAL

  static Future<dynamic> showCustomModalBottomSheet({
    required BuildContext context,
    required Widget modal,
    required bool isDarkMode,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 200,
  }) {
    return showModalBottomSheet(
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

  // CHECH SNACK BAR

  static showCheckTopSnackBarInfoForm(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: text,
      ),
      onTap: onTap,
    );
  }

  static showCheckTopSnackBar(BuildContext context, String text) {
    return showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: "$text. Please check your credentials and try again",
      ),
    );
  }

  // ALERT DIALOG

  static void showAlertDialog({
    required BuildContext context,
    required Widget child,
    bool isTransparent = false,
    Color backgroundColor = Style.white,
    bool canPop = true,
    double radius = 16,
  }) {
    AlertDialog alert = AlertDialog(
      backgroundColor: isTransparent ? Style.transparent : backgroundColor,
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

  static showCheckTopSnackBarInfo(BuildContext context, String text,
      {VoidCallback? onTap,
      Duration displayDuration = const Duration(milliseconds: 3000)}) {
    return showTopSnackBar(
        context,
        displayDuration: displayDuration,
        CustomSnackBar.info(
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
