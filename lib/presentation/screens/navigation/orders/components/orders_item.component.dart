import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_save_or_paid_button.component.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class OrdersItemComponent extends StatefulWidget {
  Order order;
  OrdersItemComponent({super.key, required this.order});
  @override
  State<OrdersItemComponent> createState() => _OrdersItemComponentState();
}

class _OrdersItemComponentState extends State<OrdersItemComponent> {
  final OrdersController orderController = Get.find();
  bool isPaid = false;
  @override
  void initState() {
    super.initState();
    /*if (checkListingType(user) == ListingType.waitress) {
      isPaid =
          AppConstants.getStatusOrderInProgressOrDone(widget.order, "DONE");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        //orderController.filterByWaitress(posController.waitressCurrentId);
      });
    } else {
      isPaid =
          AppConstants.getStatusOrderInProgressOrDone(widget.order, "DONE");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //orderController.filterByTable(posController.tableCurrentId);
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 12.r),
        child: Container(
          padding: orderController.isExpanded
              ? null
              : const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
                color: Style.light, style: BorderStyle.solid, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            backgroundColor: Style.white,
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.expand_more),
                SizedBox(height: 40),
              ],
            ),
            title: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.order.waitressId != null ||
                            widget.order.tableId != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Style.primaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              orderController.tableOrWaitressName(widget.order),
                              style: Style.interNormal(
                                color: Style.black,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.order.grandTotal}".currencyLong(),
                          style: Style.interBold(
                            size: 16.sp,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  AppConstants.getStatusOrderInProgressOrDone(
                                          widget.order, "DONE")
                                      ? Style.backRed
                                      : Style.backGreen,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0.w, vertical: 6.w),
                            child: Center(
                                child: Text(
                              AppConstants.getStatusInFrench(widget.order),
                              style: Style.interNormal(
                                  color: AppConstants
                                          .getStatusOrderInProgressOrDone(
                                              widget.order, "DONE")
                                      ? Style.red
                                      : Style.green),
                            )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            subtitle: orderController.isExpanded
                ? null
                : Row(
                    children: [
                      for (int i = 0; i < 2; i++)
                        if (i < widget.order.orderProducts.length)
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.only(left: 2),
                              child: Text(
                                "${widget.order.orderProducts[i].quantity}x ${getNameFromOrderDetail(widget.order.orderProducts?[i])}",
                                style: Style.interNormal(color: Style.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                    ],
                  ),
            onExpansionChanged: (value) {
              setState(() {
                orderController.isExpanded = value;
              });
            },
            children: [
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: widget.order.orderProducts.map((orderDetail) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Style.bgGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${getNameFromOrderDetail(orderDetail)} x ${orderDetail.quantity}",
                            ),
                          );
                        }).toList() ??
                        [],
                  )),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: OrderSaveOrPaidButtonComponent(
                    order: widget.order, isPaid: isPaid),
              ),
              10.verticalSpace,
            ],
          ),
        ));
  }
}
