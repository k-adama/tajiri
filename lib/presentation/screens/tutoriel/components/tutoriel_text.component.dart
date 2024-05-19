import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class TutorielTextComponent extends StatelessWidget {

  const TutorielTextComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vidéos tutoriels",
          style: Style.interBold(size: 23.sp),
        ),
        5.verticalSpace,
        Text(
          "Découvrez les fonctionnalités de l'application Tajiri à travers nos vidéos tutoriels.",
          style: Style.interNormal(color: Style.dark),
        ),
      ],
    );
  }
}
