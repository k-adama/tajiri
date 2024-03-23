import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_details.entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/detail_content.component.dart';

class InvoiceOrderItemComponent extends StatelessWidget {
  final OrderDetailsEntity orderDetail;

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
                        text: getNameFood(orderDetail),
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

  String getNameFood(OrderDetailsEntity orderDetails) {
    final food = orderDetails.food;
    if (food == null) return orderDetails.bundle['name'];
    // if (food.foodVariantCategory?.isNotEmpty ?? false) {
    //   return food.foodVariantCategory![0].name ?? '_';
    // } else {
    return food.name ?? '_';
    // }
  }
}
