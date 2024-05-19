import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class CustomChairComponent extends StatelessWidget {
  final ChairPosition chairPosition;
  final double borderRadiusSize;
  final double chairSpace;
  final double chairHeight;
  final double chairWidth;

  const CustomChairComponent(
      {super.key,
      required this.chairPosition,
      this.borderRadiusSize = 16,
      this.chairHeight = 24,
      this.chairWidth = 64,
      required this.chairSpace});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: chairPosition == ChairPosition.top ||
              chairPosition == ChairPosition.bottom
          ? EdgeInsets.only(left: chairSpace.r)
          : chairPosition == ChairPosition.left ||
                  chairPosition == ChairPosition.right
              ? EdgeInsets.only(top: chairSpace.r)
              : null,
      height: chairPosition == ChairPosition.top ||
              chairPosition == ChairPosition.bottom
          ? chairHeight.r
          : chairWidth.r,
      width: chairPosition == ChairPosition.top ||
              chairPosition == ChairPosition.bottom
          ? chairWidth.r
          : chairHeight.r,
      decoration: BoxDecoration(
        color: Style.white,
        borderRadius: BorderRadius.only(
          topLeft: chairPosition == ChairPosition.top ||
                  chairPosition == ChairPosition.left
              ? Radius.circular(borderRadiusSize.r)
              : Radius.zero,
          topRight: chairPosition == ChairPosition.top ||
                  chairPosition == ChairPosition.right
              ? Radius.circular(borderRadiusSize.r)
              : Radius.zero,
          bottomLeft: chairPosition == ChairPosition.bottom ||
                  chairPosition == ChairPosition.left
              ? Radius.circular(borderRadiusSize.r)
              : Radius.zero,
          bottomRight: chairPosition == ChairPosition.bottom ||
                  chairPosition == ChairPosition.right
              ? Radius.circular(borderRadiusSize.r)
              : Radius.zero,
        ),
      ),
    );
  }
}
