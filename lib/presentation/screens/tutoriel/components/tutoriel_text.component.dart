import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class TutorielTextComponent extends StatelessWidget {
  final String title;
  final String description;

  const TutorielTextComponent({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Style.interBold(size: 23.sp),
        ),
        5.verticalSpace,
        Text(
          description,
          style: Style.interNormal(color: Style.dark),
        ),
      ],
    );
  }
}
