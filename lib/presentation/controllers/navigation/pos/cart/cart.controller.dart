import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CartController extends GetxController {
  String settleOrderId = "ON_PLACE".obs.value;

  @override
  void onReady() async {
    super.onReady();
  }

  double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection:
          ui.TextDirection.ltr, // Use TextDirection.ltr for left-to-right text
    )..layout(minWidth: 0, maxWidth: double.infinity);
    if (text.length <= 6) return textPainter.width + 20;
    if (text.length > 6 && text.length <= 10) return textPainter.width + 25;
    return textPainter.width + 80;
  }
}
