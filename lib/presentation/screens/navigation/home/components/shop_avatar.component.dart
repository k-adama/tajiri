import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';

// ignore: must_be_immutable
class ShopAvatarComponent extends StatelessWidget {
  final String shopImage;
  final double size;
  final double padding;
  final double radius;
  Color bgColor;

  ShopAvatarComponent({
    super.key,
    required this.shopImage,
    required this.size,
    required this.padding,
    this.bgColor = Style.whiteWithOpacity,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      padding: EdgeInsets.all(padding.r),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(radius)),
      child: CustomNetworkImageUi(
        url: shopImage,
        height: size.r,
        width: size.r,
        radius: size.r / 2,
      ),
    );
  }
}
