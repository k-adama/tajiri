import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/staff.extension.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_cancel_dialog.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_status_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_status_message.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/orders_item.component.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class OrderCardItemComponent extends StatefulWidget {
  final List<Order> orders;
  final bool isRestaurant;
  const OrderCardItemComponent(
      {super.key, required this.orders, required this.isRestaurant});

  @override
  State<OrderCardItemComponent> createState() => _OrderCardItemComponentState();
}

class _OrderCardItemComponentState extends State<OrderCardItemComponent> {
  final OrdersController _ordersController = Get.find();
  final PosController posController = Get.find();
  final RefreshController _controller = RefreshController();
  final user = AppHelpersCommon.getUserInLocalStorage();
  void _onRefresh() async {
    //_ordersController.fetchOrders();
    if (checkListingType(user) == ListingType.waitress) {
      _ordersController.filterByWaitress(posController.waitressCurrentId);
    }
   // _ordersController.fetchOrders();
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    //_ordersController.fetchOrders();
    if (checkListingType(user) == ListingType.waitress) {
      _ordersController.filterByWaitress(posController.waitressCurrentId);
    }
    _controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _controller,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
          itemCount: widget.orders.length,
          itemBuilder: (BuildContext context, index) {
            Order orderData = widget.orders[index];
            bool isNew = orderData.status == AppConstants.orderAccepted ||
                orderData.status == AppConstants.orderNew ||
                orderData.status == AppConstants.orderCooking ||
                orderData.status == AppConstants.orderReady &&
                    widget.isRestaurant;
            return /*isNew ?*/ orderData.status != AppConstants.orderPaid
                ? Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.35,
                      motion: const ScrollMotion(),
                      children: [
                        if ((orderData.status != AppConstants.orderReady) &&
                            (orderData.status != AppConstants.orderCancelled))
                          OrderStatusButtonComponent(
                            buttonText:
                                orderData.status != AppConstants.orderCooking
                                    ? "    En\nCuisine"
                                    : "Prête",
                            isGrised: !user.canUpdate,
                            buttonColor: Style.secondaryColor,
                            onTap: () {
                              _ordersController.updateOrderStatus(
                                context,
                                orderData.id.toString(),
                                orderData.status != AppConstants.orderCooking
                                    ? AppConstants.orderCooking
                                    : AppConstants.orderReady,
                              );
                            },
                          ),
                        const SizedBox(width: 4.0),
                        if ((orderData.status != AppConstants.orderReady) &&
                            (orderData.status != AppConstants.orderCancelled))
                          OrderStatusButtonComponent(
                            buttonText: "Annuler",
                            isGrised: !user.canCancel,
                            buttonColor: Style.red,
                            onTap: () {
                              AppHelpersCommon.showAlertDialog(
                                context: context,
                                child: OrderCancelDialogComponent(
                                  noCancel: () {
                                    Navigator.pop(context);
                                    Slidable.of(context)?.close();
                                  },
                                  cancel: () {
                                    _ordersController.updateOrderStatus(
                                      context,
                                      orderData.id.toString(),
                                      AppConstants.orderCancelled,
                                    );
                                    Navigator.pop(context);
                                    Slidable.of(context)?.close();
                                  },
                                ),
                                radius: 10,
                              );
                            },
                          ),
                        if (orderData.status == AppConstants.orderCancelled)
                          OrderStatusMessageComponent(
                              status: "annulée", textColor: Style.red),
                        if (orderData.status == AppConstants.orderReady)
                          OrderStatusMessageComponent(
                              status: "prête", textColor: Style.secondaryColor),
                      ],
                    ),
                    child: OrdersItemComponent(
                      order: orderData,
                    ),
                  )
                : OrdersItemComponent(
                    order: orderData,
                  );
          }),
    );
  }
}
