import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';

class OrderDetailStringContent extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isEnd;

  const OrderDetailStringContent({
    super.key,
    required this.text,
    required this.isBold,
    required this.isEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: isEnd ? TextAlign.end : TextAlign.start,
      style: isBold ? Style.interBold(size: 12) : Style.interNormal(size: 12),
    );
  }
}

class OrderDetailNumberContent extends StatelessWidget {
  final int value;

  const OrderDetailNumberContent({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value.toString().currencyLong(),
      textAlign: TextAlign.end,
      style: Style.interNormal(size: 10),
    );
  }
}
