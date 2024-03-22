import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';

class TotalCommandComponent extends StatelessWidget {
  final String name;
  final int price;
  final bool isTotal;

  const TotalCommandComponent({
    super.key,
    required this.name,
    required this.price,
    required this.isTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Style.interNormal(
                  size: 16,
                ),
              ),
              Text(
                '$price'.currencyLong(),
                style: isTotal
                    ? Style.interBold(
                        size: 16,
                      )
                    : Style.interBold(
                        size: 16,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
