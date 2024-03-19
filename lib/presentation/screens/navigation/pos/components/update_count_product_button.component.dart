import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class UpdateCountProductButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  const UpdateCountProductButton(
      {super.key, required this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: Style.primaryColor, borderRadius: BorderRadius.circular(2)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
          child: Icon(
            iconData,
            color: Style.black,
          ),
        ),
      ),
    );
  }
}
