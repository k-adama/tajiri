import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/detail_content.component.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart' as taj_sdk;

class InvoiceOrderItemComponent extends StatelessWidget {
  final taj_sdk.OrderProduct orderDetail;

  const InvoiceOrderItemComponent({
    super.key,
    required this.orderDetail,
  });

  @override
  Widget build(BuildContext context) {
    int calculatedPrice =
        (orderDetail.price ?? 0) * (orderDetail.quantity ?? 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: Table(
          children: [
            TableRow(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderDetailStringContent(
                        text: getNameFromOrderDetail(orderDetail),
                        isBold: false,
                        isEnd: false),
                    Text(
                      "Qté ${orderDetail.quantity.toString()}",
                      style: Style.interNormal(size: 10),
                    ),
                  ],
                ),
                OrderDetailNumberContent(value: orderDetail.price ?? 0),
                OrderDetailNumberContent(value: calculatedPrice),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
