import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'dart:ui' as ui;

import 'package:tajiri_sdk/src/models/order.model.dart';

class InvoiceTotalComponent extends StatelessWidget {
  final Order order;
  const InvoiceTotalComponent({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TOTAL",
              style: TextStyle(
                color: Style.dark,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(
              width: 250,
              height: 30,
              child: Stack(
                children: [
                  Text(
                    "${order.grandTotal}".notCurrency(),
                    style: Style.interBold(
                      size: 20.sp,
                      color: Style.black,
                    ),
                  ),
                  Positioned(
                    left: getTextWidth(
                      order.grandTotal.toString(),
                      Style.interNormal(
                        size: 20,
                        color: Style.darker,
                      ),
                    ),
                    bottom: 2,
                    child: SizedBox(
                      width: 40,
                      height: 14,
                      child: Text(
                        TrKeysConstant.splashFcfa,
                        style: Style.interNormal(size: 8, color: Style.darker),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection:
          ui.TextDirection.ltr, // Use TextDirection.ltr for left-to-right text
    )..layout(minWidth: 0, maxWidth: double.infinity);
    if (text.length <= 6) return textPainter.width + 22;
    return textPainter.width + 80;
  }
}
