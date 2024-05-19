import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class GenderSelectionComponent extends StatefulWidget {
  final String text;
  final String iconPath;
  final Function() onTap;
  final bool isSelected;

  const GenderSelectionComponent({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<GenderSelectionComponent> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelectionComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 47.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isSelected ? Style.secondaryColor : Style.bgGrey,
            width: 2.0.w,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SvgPicture.asset(widget.iconPath, width: 24.0.w),
            SizedBox(width: 8.0.w),
            Text(widget.text),
          ],
        ),
      ),
    );
  }
}
