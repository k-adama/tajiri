import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class BluetoothButtonComponent extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;
  const BluetoothButtonComponent({super.key, required this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: Style.dark,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 16,
            height: 16,
          ),
        ),
      ),
    );
  }
}
