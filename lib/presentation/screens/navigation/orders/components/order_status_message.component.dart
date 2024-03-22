import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class OrderStatusMessageComponent extends StatelessWidget {
  final String status;
  final Color textColor;
  OrderStatusMessageComponent({super.key, required this.status, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Commande",
        style: Style.interRegular(
          size: 15,
          color: textColor,
        ),
      ),
      Text(
        status,
        style: Style.interRegular(
          size: 15,
          color: textColor,
        ),
      ),
    ],
  );
  }
}