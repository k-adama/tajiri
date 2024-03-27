import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/stock_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';

class SeeStockHistoryComponent extends StatefulWidget {
  bool seeHistory;
  List<StockDataEnty>? stockList;
  SeeStockHistoryComponent(
      {super.key, required this.seeHistory, required this.stockList});

  @override
  State<SeeStockHistoryComponent> createState() =>
      _SeeStockHistoryComponentState();
}

class _SeeStockHistoryComponentState extends State<SeeStockHistoryComponent> {
  final StockController stockController = Get.find();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: 500,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.stockList?.length ?? 0, // TODO STOCK model
        itemBuilder: (BuildContext context, int index) {
          final stock = widget.stockList?[index];
          return Padding(
            padding: EdgeInsets.only(left: 16.r, right: 16.r),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${stockController.formatDate(stock)}",
                            style:
                                Style.interNormal(color: Style.dark, size: 14),
                          ),
                          Text("${stockController.getTypeMove(stock)} ",
                              style: Style.interBold()),
                          Text(
                            "${stockController.getUser(stock)}",
                            style:
                                Style.interNormal(color: Style.dark, size: 14),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: (size.width - 125) / 4,
                        height: 40,
                        decoration: BoxDecoration(
                            color: stockController.getQuantity(stock)[0] == "+"
                                ? Style.backGreen
                                : Style.backRed,
                            borderRadius: BorderRadius.circular(60)),
                        child: Center(
                          child: Text(
                            "${stockController.getQuantity(stock)}",
                            style: Style.interBold(
                                size: 14,
                                color:
                                    stockController.getQuantity(stock)[0] == "+"
                                        ? Style.green
                                        : Style.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Style.light,
                  height: 10,
                  thickness: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
