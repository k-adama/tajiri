import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class InformationInvoiceComponent extends StatelessWidget {
  final String title;
  final String body;

  const InformationInvoiceComponent({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Style.interBold(size: 14, color: Style.dark),
          ),
          Text(
            body,
            style: Style.interBold(size: 16),
          ),
        ],
      ),
    );
  }
}
