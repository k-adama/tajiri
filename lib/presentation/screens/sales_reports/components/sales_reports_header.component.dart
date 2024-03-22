import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class SalesReportHeaderComponent extends StatelessWidget {
  final String title;
  final TextStyle style;
  const SalesReportHeaderComponent({
    Key? key,
    required this.title,
    required this.style,
  }) : super(key: key);

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
