import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class ForgotTextButton extends StatelessWidget{
  final String title;
  final Function() onPressed;
  final double? fontSize;
  final Color? fontColor;
  final double? letterSpacing;

  const ForgotTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.fontSize,
    this.fontColor = Style.black,
    this.letterSpacing = -14 * 0.02,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith(
          (states) => Style.dontHaveAccBtnBack,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: Style.interNormal(
          textDecoration: TextDecoration.underline,
          size: 12,
          color: Style.black,
        ),
      ),
    );
  }
}
