import 'package:flutter/material.dart';

class SalesReportHeaderComponent extends StatelessWidget {
  final String title;
  final TextStyle style;
  const SalesReportHeaderComponent({
    super.key,
    required this.title,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Text(
        title,
        style: style,
      ),
    );
  }
}
