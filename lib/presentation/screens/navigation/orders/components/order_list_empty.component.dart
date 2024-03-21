import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class OrderListEmptyComponent extends StatelessWidget {
  const OrderListEmptyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      18.verticalSpace,
      Image.asset("assets/images/notFound.png"),
      Text(
        "Pas de resultats",
        style: Style.interSemi(size: 14.sp),
      ),
    ],
  );
  }
}