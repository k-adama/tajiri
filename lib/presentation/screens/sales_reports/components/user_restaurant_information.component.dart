import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class UserOrRestaurantInformationComponent extends StatelessWidget {
  final String text;
  const UserOrRestaurantInformationComponent({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Style.interBold(size: 30.sp, color: Style.black),
    );
  }
}
