import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/main.dart';

class TotalAmountToPaidComponent extends StatelessWidget {
  const TotalAmountToPaidComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Total créance client",
          style: Style.interNormal(
            size: 13,
            color: tajiriDesignSystem.appColors.mainGrey500,
          ),
        ),
        Container(
          width: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: const BoxDecoration(
            color: Style.grey100,
          ),
          child: Center(
            child: Text(
              "20000".currencyLong(),
              style: Style.interBold(
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 55),
      ],
    );
  }
}

class TotalCardComponent extends StatelessWidget {
  final int? total;
  const TotalCardComponent({super.key, this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
        color: tajiriDesignSystem.appColors.mainGrey50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Total"),
          Text(
            "$total".currencyLong(),
            style: Style.interBold(size: 15),
          ),
        ],
      ),
    );
  }
}
