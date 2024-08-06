import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class Item {
  Item({
    required this.productName,
    required this.productQtyStart,
    required this.productQtySupply,
    required this.productQtySales,
    required this.productPriceTotal,
    required this.productQtyFinal,
    this.isExpanded = false,
  });

  String productName;
  int productQtyStart;
  int productQtySupply;
  int productQtySales;
  int productPriceTotal;
  int productQtyFinal;
  bool isExpanded;
}

class SalesReportsExpansionPanelListComponent extends StatefulWidget {
  List<SaleItem> salesData;
  SalesReportsExpansionPanelListComponent({super.key, required this.salesData});

  @override
  State<SalesReportsExpansionPanelListComponent> createState() =>
      _SalesReportsExpansionPanelListComponentState();
}

class _SalesReportsExpansionPanelListComponentState
    extends State<SalesReportsExpansionPanelListComponent> {
  late List<Item> _data;

  @override
  void initState() {
    super.initState();
    _data = generateItems(widget.salesData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildPanel(context));
  }

  Widget _buildPanel(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _data[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Style.light, style: BorderStyle.solid, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                backgroundColor: Style.white,
                title: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (screenSize.width / 2) - 50.w,
                          child: Text(
                            item.productName,
                            style: Style.interBold(size: 16.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                              color: Style.secondaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "${item.productPriceTotal}".currencyShort(),
                              style: Style.interBold(
                                  color: Style.white, size: 14.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                subtitle: Row(
                  children: [
                    subtitleInformation(
                        "Stock initial ${item.productQtyStart}"),
                    subtitleInformation("Sortie ${item.productQtySales}"),
                  ],
                ),
                children: [
                  Column(
                    children: [
                      bodyInformation("Entrée", item.productQtySupply),
                      const Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      bodyInformation(
                          "Restant",
                          (item.productQtyStart == 0
                              ? 0
                              : item.productQtyStart - item.productQtySales)),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget subtitleInformation(String subtitle) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
          color: Style.lighter, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
            child: Text(
          subtitle,
          style: Style.interNormal(color: Style.dark, size: 12),
        )),
      ),
    );
  }

  Widget bodyInformation(String text, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Style.interNormal(color: Style.dark, size: 12),
          ),
          Text(
            value.toString(),
            style: Style.interNormal(color: Style.dark, size: 12),
          )
        ],
      ),
    );
  }
}

List<Item> generateItems(List<SaleItem> salesData) {
  int numberOfItems = salesData.length;
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      productName: salesData[index].itemName,
      productQtyStart: 0,
      // salesData[index].productQtyStart ?? 0,
      productQtySupply: 0,
      //salesData[index].productQtySupply ?? 0,
      productQtySales: salesData[index].qty,
      productPriceTotal: salesData[index].totalAmount.toInt(),
      productQtyFinal: 0,
      //salesData[index].productQtyFinal ?? 0,
    );
  });
}
