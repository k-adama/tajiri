import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';


// ignore: must_be_immutable
class TitleAndIconWidget extends StatelessWidget {
  final String title;
  final double titleSize;
  final String? rightTitle;
  final bool isIcon;
  final Color rightTitleColor;
  final double paddingHorizontalSize;
  VoidCallback? onRightTap;

  TitleAndIconWidget({
    Key? key,
    this.isIcon = false,
    required this.title,
    this.rightTitle,
    this.rightTitleColor = Style.black,
    this.onRightTap,
    this.titleSize = 20,
    this.paddingHorizontalSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalSize.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Style.interNoSemi(
                size: titleSize.sp,
                color: Style.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: onRightTap ?? () {},
            child: Row(
              children: [
                Text(
                  rightTitle ?? "",
                  style: Style.interRegular(
                    size: 14,
                    color: rightTitleColor,
                  ),
                ),
                isIcon
                    ? const Icon(Icons.keyboard_arrow_right)
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
