import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class LoginWelcomeComponent extends StatelessWidget {
  const LoginWelcomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        50.verticalSpace,
        SvgPicture.asset("assets/svgs/logo_tajiri.svg",
            height: 200.h),
        RichText(
          text: TextSpan(
            text:TrKeysConstant.welcomeText ,
            style: Style.interNormal(
                size: 27.sp, color: Style.secondaryColor),
            children: <TextSpan>[
              TextSpan(
                  text: " !",
                  style: Style.interNormal(
                      size: 30.sp,
                      color: Style.secondaryColor)),
            ],
          ),
        ),
        30.verticalSpace,
        Container(
          width: 320.w,
          child: Text(
            TrKeysConstant.descriptionAppText,
            textAlign: TextAlign.center,
            style: Style.interNormal(
                size: 15.sp, color: Style.secondaryColor),
          ),
        ),
        40.verticalSpace,
      ],
    );
  }
}
