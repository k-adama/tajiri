import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class CustomSecondaryButton extends StatelessWidget {
  final double? height;
  final String title;
  final Color titleColor;
  final Function()? onPressed;
  const CustomSecondaryButton(
      {super.key,
      this.height = 38,
      required this.title,
      this.onPressed,
      required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: const BoxDecoration(),
        child: Center(
            child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: titleColor,
          ))),
          child: Text(
            title,
            style: Style.interNormal(
              size: 15,
              color: titleColor,
              underLineColor: titleColor,
              letterSpacing: -14 * 0.01,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        )),
      ),
    );
  }
}
