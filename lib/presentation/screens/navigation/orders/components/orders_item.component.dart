import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_payments_method_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class OrdersItemComponent extends StatefulWidget {
  //MainController? mainController;
  OrderEntity order;
  OrdersItemComponent({super.key, required this.order});
  @override
  State<OrdersItemComponent> createState() => _OrdersItemComponentState();
}

class _OrdersItemComponentState extends State<OrdersItemComponent> {
  final UserEntity? user = AppHelpersCommon.getUserInLocalStorage();
  final OrdersController orderController = Get.find();
 // final PosController posController = Get.find();
  //final TableController tableController = Get.find();

  bool isPaid = false;
  @override
  void initState() {
    super.initState();
    if (checkListingType(user) == ListingType.waitress) {
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
    }
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
                    orderController.tableOrWaitessNoNullOrNotEmpty(widget.order)
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
                        if (widget.order.orderDetails != null &&
                            i < widget.order.orderDetails!.length)
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.only(left: 2),
                              child: Text(
                                "${widget.order.orderDetails?[i]?.quantity ?? ''}x ${widget.order.orderDetails?[i]?.food?.name ?? 'N/A'}",
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
                    children: widget.order.orderDetails?.map((orderDetail) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Style.bgGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${orderDetail.food == null ? orderDetail.bundle['name'] : orderDetail.food!.name}" +
                                  " x ${orderDetail.quantity ?? ''}",
                            ),
                          );
                        }).toList() ??
                        [],
                  )),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: bottomsAction(isPaid),
              ),
              10.verticalSpace,
            ],
          ),
        ));
    /* GestureDetector(
      onTap: () {
        Mixpanel.instance.track("Check Order", properties: {
          "Customer type": widget.order.customerType,
          "Total Price": widget.order.grandTotal,
          "Order Status": widget.order.status,
          "Payment method": widget.order.paymentMethod != null
              ? widget.order.paymentMethod?.name
              : ""
        });
        Get.toNamed(Routes.ORDER_ITEM_DETAILS, arguments: widget.order);
      },
      child: 
      Container(
          padding: EdgeInsets.only(top: 12.r, left: 16.r, right: 16.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order.tableId != null &&
                                widget.order.tableId!.isNotEmpty
                            ? widget.order.table!.name!
                            : widget.order.orderNotes == null ||
                                    widget.order.orderNotes == ''
                                ? "Commande N° ${widget.order.orderNumber}"
                                : widget.order.orderNotes!,
                        style: Style.interNormal(size: 14.sp),
                      ),
                      Text(
                        "${widget.order.grandTotal}".currencyLong(),
                        style: Style.interBold(
                          size: 16.sp,
                        ),
                      ),
                      Text(
                        intl.DateFormat("MMM dd, HH:MM").format(
                            DateTime.parse(widget.order.createdAt ?? "")),
                        style:
                            Style.interRegular(size: 13.sp, color: Style.light),
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppConstants.getStatusOrderInProgressOrDone(
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
                            color: AppConstants.getStatusOrderInProgressOrDone(
                                    widget.order, "DONE")
                                ? Style.red
                                : Style.green),
                      )),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Style.light,
                height: 10.h,
                thickness: 1,
              ),
            ],
          )),
    );*/
  }

  Widget bottomsAction(bool isPaid) {
    return widget.order.status == AppConstants.orderNew ||
            widget.order.status == AppConstants.orderCooking ||
            widget.order.status == AppConstants.orderAccepted ||
        widget.order.status == AppConstants.orderReady
        ? Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: CustomButton(
                      isLoading: orderController.isAddAndRemoveLoading,
                      background: Style.secondaryColor,
                      title: "Modifier",
                      textColor: Style.white,
                      isLoadingColor: Style.white,
                      haveBorder: false,
                      radius: 5,
                      onPressed: () {
                        /*posController.deleteCart();
                        posController.orderNotes.value =
                            widget.order.orderNotes!;
                        for (var i = 0;
                            i < widget.order.orderDetails!.length;
                            i++) {
                          FoodData food =
                              widget.order.orderDetails![i].food != null
                                  ? widget.order.orderDetails![i].food
                                  : widget.order.orderDetails![i].bundle;

                          if (food.price !=
                                  widget.order.orderDetails![i].price &&
                              food.foodVariantCategory != null &&
                              food.foodVariantCategory!.isNotEmpty) {
                            final FoodVariant? foodVariant = food
                                .foodVariantCategory![0].foodVariant!
                                .firstWhere((element) =>
                                    element.price! ==
                                    widget.order.orderDetails![i].price);
                            posController.addCart(
                                context,
                                food,
                                foodVariant,
                                widget.order.orderDetails![i].quantity,
                                widget.order.orderDetails![i].price,
                                true);
                            continue;
                          }

                          posController.addCart(
                              context,
                              food,
                              null,
                              widget.order.orderDetails![i].quantity,
                              widget.order.orderDetails![i].price,
                              true);
                        }
                        posController.setCurrentOrder(widget.order);
                        if (widget.order.customer != null) {
                          posController.customer.value = widget.order.customer!;
                        }

                        posController.orderNotes.value =
                            widget.order.orderNotes!;
                        posController.note.text = widget.order.orderNotes!;

                        AppHelpers.showCustomModalBottomSheet(
                          context: context,
                          modal: CartOrderView(
                            mainController: widget.mainController,
                          ),
                          isDarkMode: false,
                          isDrag: true,
                          radius: 12,
                        );*/
                      },
                    ),
                  ),
                  4.horizontalSpace,
                  Flexible(
                    child: Obx(() => orderController.isLoadingOrder.isTrue
                        ? CustomButton(
                            isLoading: orderController.isLoadingOrder.value,
                            background: Style.primaryColor,
                            radius: 5,
                            title: "Payer",
                      textColor: Style.white,
                      isLoadingColor: Style.secondaryColor,
                            onPressed: () {
                              orderController.currentOrderId.value =
                                  widget.order.id!;

                              orderController.currentOrderNo.value =
                                  widget.order.orderNumber!.toString();
                              AppHelpersCommon.showCustomModalBottomSheet(
                                  paddingTop:
                                      MediaQuery.of(context).padding.top +
                                          100.h,
                                  context: context,
                                  modal: const OrderPaymentsMethodesModalComponent(),
                                  isDarkMode: false,
                                  isDrag: true,
                                  radius: 12);
                              // Navigator.pop(context);
                            },
                          )
                        : CustomButton(
                            isLoading: orderController.isLoadingOrder.value,
                            background: Style.primaryColor,
                            radius: 5,
                            title: "Payer",
                            isLoadingColor: Style.secondaryColor,
                            textColor: Style.secondaryColor,
                            onPressed: () {
                              orderController.currentOrderId.value =
                                  widget.order.id!;
                              orderController.currentOrderNo.value =
                                  widget.order.orderNumber!.toString();
                              AppHelpersCommon.showCustomModalBottomSheet(
                                  paddingTop:
                                      MediaQuery.of(context).padding.top +
                                          100.h,
                                  context: context,
                                  modal: const OrderPaymentsMethodesModalComponent(),
                                  isDarkMode: false,
                                  isDrag: true,
                                  radius: 12);
                              // Navigator.pop(context);
                            },
                          )),
                  ),
                ],
              ),
              CustomButton(
                isLoading: orderController.isAddAndRemoveLoading,
                title: "Voir la facture",
                background: Style.transparent,
                textColor: Style.secondaryColor,
                radius: 5,
                haveBorder: true,
                borderColor: Style.secondaryColor,
                imagePath: "assets/svgs/ion_receipt-sharpinvoice.svg",
                onPressed: () {
                  //Get.toNamed(Routes.INVOICE_PDF, arguments: widget.order);
                },
              )
            ],
          )
        : CustomButton(
            isLoading: orderController.isAddAndRemoveLoading,
            background: Style.primaryColor,
            title: widget.order.status == AppConstants.orderCancelled ? "Voir la facture" : "Voir le reçu de paiement",
            textColor: Style.secondaryColor,
            isLoadingColor: Style.secondaryColor,
            radius: 5,
            haveBorder: false,
            onPressed: () {
              //Get.toNamed(Routes.INVOICE_PDF, arguments: widget.order);
            },
          );
  }
}
