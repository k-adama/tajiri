import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';

class AddIconComponent extends StatelessWidget {
  final VoidCallback? onTap;
  final double? size;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry? margin;

  const AddIconComponent(
      {super.key, this.onTap, this.size, this.color, this.radius, this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 20),
        width: size ?? 24,
        height: size ?? 24,
        decoration: BoxDecoration(
          color: color ?? tajiriDesignSystem.appColors.mainGrey950,
          borderRadius: tajiriDesignSystem.appBorderRadius.xs,
        ),
        child: const Icon(
          Icons.add,
          color: Style.white,
        ),
      ),
    );
  }
}
