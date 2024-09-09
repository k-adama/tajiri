import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class CustomGroupFieldComponent extends StatelessWidget {
  final String title;
  final double? titleSize;
  final String? description;
  final Widget field;
  const CustomGroupFieldComponent(
      {super.key,
      required this.title,
      this.description,
      required this.field,
      this.titleSize = 16});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: Style.interBold()),
        ),
        if (description != null)
          Text(
            description!,
            style: Style.interNormal(
              size: 14,
              color: Colors.grey,
            ),
          ),
        5.verticalSpace,
        field
      ],
    );
  }
}
