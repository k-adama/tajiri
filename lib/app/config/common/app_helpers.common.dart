import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';

class AppHelpersCommon {
  AppHelpersCommon._();

  static UserEntity? getUserInLocalStorage() {
    final userEncoding =
        LocalStorageService.instance.get(AuthConstant.keyToken);

    if (userEncoding == null) {
      // logoutApi();
      return null;
    }
    final user = jsonDecode(userEncoding) as UserEntity;
    return user;
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
}
