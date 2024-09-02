import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/detail_content.component.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart' as taj;

class InvoiceOrderItemComponent extends StatelessWidget {
  final taj.OrderProduct orderProduct;

  const InvoiceOrderItemComponent({
    super.key,
    required this.orderProduct,
  });

  @override
  Widget build(BuildContext context) {
    int calculatedPrice = (orderProduct.price) * (orderProduct.quantity);

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
                        text: getNameFromOrderProduct(orderProduct),
                        isBold: false,
                        isEnd: false),
                    Text(
                      "Qté ${orderProduct.quantity.toString()}",
                      style: Style.interNormal(size: 10),
                    ),
                  ],
                ),
                OrderDetailNumberContent(value: orderProduct.price),
                OrderDetailNumberContent(value: calculatedPrice),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
