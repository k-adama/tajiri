import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class EditProductPriceButtonComponent extends StatelessWidget {
  final bool isLoading;
  final Color background;
  final String title;
  final Color textColor;
  final Color borderColor;
  final Function()? onPressed;
  const EditProductPriceButtonComponent({
    Key? key,
    this.isLoading = false,
    this.background = Style.primaryColor,
    required this.title,
    this.textColor = Style.white,
    required this.onPressed,
    this.borderColor = Style.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      isLoading: isLoading,
      background: background,
      title: title,
      textColor: textColor,
      radius: 3,
      borderColor: borderColor,
      onPressed: onPressed,
    );
  }
}
