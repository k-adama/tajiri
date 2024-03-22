import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_payments_method_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/cart.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class OrderSaveOrPaidButtonComponent extends StatelessWidget {
  final OrderEntity order;
  final bool isPaid;
  OrderSaveOrPaidButtonComponent({super.key, required this.order, required this.isPaid});

  final OrdersController orderController = Get.find();
  final NavigationController navigationController = Get.put(NavigationController());
  @override
  Widget build(BuildContext context) {
    return order.status == AppConstants.orderNew ||
            order.status == AppConstants.orderCooking ||
            order.status == AppConstants.orderAccepted ||
        order.status == AppConstants.orderReady
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
                        navigationController.posController.fullCartAndUpdateOrder(context, order);
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
                                  order.id!;

                              orderController.currentOrderNo.value =
                                  order.orderNumber!.toString();
                              AppHelpersCommon.showCustomModalBottomSheet(
                                  paddingTop:
                                      MediaQuery.of(context).padding.top +
                                          100.h,
                                  context: context,
                                  modal: const OrderPaymentsMethodesModalComponent(),
                                  isDarkMode: false,
                                  isDrag: true,
                                  radius: 12);
                              //Navigator.pop(context);
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
                                  order.id!;
                              orderController.currentOrderNo.value =
                                  order.orderNumber!.toString();
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
                  Get.toNamed(Routes.INVOICE, arguments: order);
                },
              )
            ],
          )
        : CustomButton(
            isLoading: orderController.isAddAndRemoveLoading,
            background: Style.primaryColor,
            title: order.status == AppConstants.orderCancelled ? "Voir la facture" : "Voir le reçu de paiement",
            textColor: Style.secondaryColor,
            isLoadingColor: Style.secondaryColor,
            radius: 5,
            haveBorder: false,
            onPressed: () {
              Get.toNamed(Routes.INVOICE, arguments: order);
            },
          );
  }
}