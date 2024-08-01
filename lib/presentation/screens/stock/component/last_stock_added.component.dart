import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class LastStockAddedComponent extends StatelessWidget {
  final Inventory food;
  final Size size;
  LastStockAddedComponent({
    super.key,
    required this.food,
    required this.size,
  });

  final StockController stockController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 24.h,
          right: 16.w,
          left: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Dernier approvisionnement"),
              FutureBuilder<String>(
                future: stockController.lastMove(food.histories),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? '',
                    style: Style.interSemi(
                      size: 11,
                      color: Style.black,
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            width: (size.width - 125) / 4,
            height: 40,
            decoration: BoxDecoration(
                color: Style.lightBlue,
                borderRadius: BorderRadius.circular(60)),
            child: Center(
              child: Text(
                stockController.lastSupply(food.histories).toString(),
                style: Style.interBold(
                  size: 14,
                  color: Style.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
