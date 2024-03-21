import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/auth.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';

class CreateOrHaveAccountComponent extends StatelessWidget {
  final String title;
  final String path;
  final Color style;
  const CreateOrHaveAccountComponent(
      {super.key,
      required this.title,
      required this.path,
      required this.style});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (path.isNotEmpty) {
          final storage = LocalStorageService.instance;
          storage.set(AuthConstant.keyOnboarding, "true");
          Get.toNamed(path);
        } else {
          AppHelpersCommon.showBottomSnackBar(
              context,
              Text("Pas disponible",
                  style: Style.interNormal(color: Style.white)),
              const Duration(milliseconds: 1000),
              true);
        }
      },
      child: SizedBox(
        height: 30,
        child: Center(
          child: Text(
            title,
            style: Style.interBold(
                size: 13.sp,
                isUnderLine: true,
                underLineColor: style,
                color: style),
          ),
        ),
      ),
    );
  }
}
