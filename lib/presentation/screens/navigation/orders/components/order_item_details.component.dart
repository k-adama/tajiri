// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
// import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
// import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
// import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
// import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
// import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
// import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_payments_method_modal.component.dart';
// import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
// import 'package:tajiri_sdk/tajiri_sdk.dart';

// class OrderItemDetailsComponent extends StatefulWidget {
//   const OrderItemDetailsComponent({super.key});

//   @override
//   State<OrderItemDetailsComponent> createState() => _OrderItemDetailsComponentState();
// }

// class _OrderItemDetailsComponentState extends State<OrderItemDetailsComponent> {
//   //final PosController posController = Get.find();
//   final OrdersController ordersController = Get.put(OrdersController());
//   //final MainController mainController = Get.put(MainController());

//   final Order ordersData = Get.arguments;
//   @override
//   Widget build(BuildContext context) {
//    // final dynamic payment = ordersController.getPayment(ordersData);
//     final isPaid =
//         AppConstants.getStatusOrderInProgressOrDone(ordersData, "DONE");
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           iconTheme: const IconThemeData(color: Style.black),
//           backgroundColor: Style.white,
//         ),
//         backgroundColor: Style.white,
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(16.r),
//             color: Style.white,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     orderHeader(),
//                     50.verticalSpace,
//                    /* AppConstants.getStatusOrderInProgressOrDone(
//                             ordersData, "DONE")
//                         ? Row(
//                             children: [
//                               paymentMethodAndInvoice(payment, "Moyen",
//                                   "de paiment", false, ordersData, false),
//                               6.horizontalSpace,
//                               paymentMethodAndInvoice(payment, "Reçu", "TAJ#",
//                                   true, ordersData, false),
//                             ],
//                           )
//                         : const SizedBox(),
//                     !AppConstants.getStatusOrderInProgressOrDone(
//                             ordersData, "DONE")
//                         ? paymentMethodAndInvoice(
//                             payment, "Reçu", "TAJ#", true, ordersData, true)
//                         : const SizedBox(),
//                     50.verticalSpace,*/
//                     clientInformation(
//                         "NOM DU CLIENT", ordersData.customerType!),
//                     totalCommand("SOUS TOTAL", ordersData.subTotal ?? 0),
//                     totalCommand("REMISE", 0),
//                     50.verticalSpace,
//                     SizedBox(
//                       height: 60,
//                       width: double.infinity,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "TOTAL",
//                             style: TextStyle(
//                               color: Style.dark,
//                               fontSize: 12.sp,
//                             ),
//                           ),
//                           Container(
//                             width: 250,
//                             height: 30,
//                             child: Stack(
//                               children: [
//                                 Text(
//                                   "${ordersData.grandTotal}".notCurrency(),
//                                   style: Style.interBold(
//                                     size: 20.sp,
//                                     color: Style.black,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   left: ordersController.getTextWidth(
//                                     ordersData.grandTotal.toString(),
//                                     Style.interNormal(
//                                       size: 20,
//                                       color: Style.darker,
//                                     ),
//                                   ),
//                                   bottom: 2,
//                                   child: Container(
//                                     width: 40,
//                                     height: 14,
//                                     child: Text(
//                                       TrKeysConstant.splashFcfa,
//                                       style: Style.interNormal(
//                                           size: 8, color: Style.darker),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 50.verticalSpace,
//                 Container(
//                   height: 130,
//                   child: bottomsAction(isPaid),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }

//   Widget orderHeader() {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   ordersData.tableId != null && ordersData.tableId!.isNotEmpty
//                       ? ordersData.tableId.toString()
//                       : ordersData.orderNotes == null ||
//                               ordersData.orderNotes == ''
//                           ? "Commande N° ${ordersData.orderNumber}"
//                           : ordersData.orderNotes!,
//                   style: Style.interNormal(size: 14, color: Style.dark),
//                 ),
//                 Text(
//                   "${ordersData.grandTotal}".currencyLong(),
//                   style: Style.interBold(
//                     size: 16,
//                   ),
//                 ),
//                 Text(
//                   intl.DateFormat("MMM dd, HH:MM")
//                       .format(DateTime.parse(ordersData.createdAt.toString())),
//                   style: Style.interRegular(size: 13, color: Style.light),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 color: AppConstants.getStatusOrderInProgressOrDone(
//                         ordersData, "DONE")
//                     ? Style.backRed
//                     : Style.backGreen,
//                 borderRadius: BorderRadius.circular(20)),
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
//               child: Center(
//                   child: Text(
//                 AppConstants.getStatusInFrench(ordersData),
//                 style: Style.interNormal(
//                     color: AppConstants.getStatusOrderInProgressOrDone(
//                             ordersData, "DONE")
//                         ? Style.red
//                         : Style.green),
//               )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget bottomsAction(bool isPaid) {
//     return AppConstants.getStatusOrderInProgressOrDone(ordersData, "IN_PROGRESS")
//         ? Column(
//             children: [
//               Flexible(
//                 child: Obx(() => ordersController.isLoadingOrder.isTrue
//                     ? CustomButton(
//                         isLoading: ordersController.isLoadingOrder.value,
//                         background: Style.primaryColor,
//                         radius: 5,
//                         title: "Payer",
//                         isLoadingColor: Style.secondaryColor,
//                         onPressed: () {
//                           ordersController.currentOrderId.value =
//                               ordersData.id!;

//                           ordersController.currentOrderNo.value =
//                               ordersData.orderNumber!.toString();
//                           AppHelpersCommon.showCustomModalBottomSheet(
//                               paddingTop:
//                                   MediaQuery.of(context).padding.top + 100.h,
//                               context: context,
//                               modal: const OrderPaymentsMethodesModalComponent(),
//                               isDarkMode: false,
//                               isDrag: true,
//                               radius: 12);
//                           // Navigator.pop(context);
//                         },
//                       )
//                     : CustomButton(
//                         isLoading: ordersController.isLoadingOrder.value,
//                         background: Style.primaryColor,
//                         radius: 5,
//                         title: "Payer",
//                         textColor: Style.secondaryColor,
//                         isLoadingColor: Style.secondaryColor,
//                         onPressed: () {
//                           ordersController.currentOrderId.value =
//                               ordersData.id!;
//                           ordersController.currentOrderNo.value =
//                               ordersData.orderNumber!.toString();
//                           AppHelpersCommon.showCustomModalBottomSheet(
//                               paddingTop:
//                                   MediaQuery.of(context).padding.top + 100.h,
//                               context: context,
//                               modal: const OrderPaymentsMethodesModalComponent(),
//                               isDarkMode: false,
//                               isDrag: true,
//                               radius: 12);
//                           // Navigator.pop(context);
//                         },
//                       )),
//               ),
//               Flexible(
//                 child: CustomButton(
//                   isLoading: false ,//posController.isAddAndRemoveLoading,
//                   background: Style.white,
//                   radius: 5,
//                   textColor: Style.titleDark,
//                   borderColor: Style.titleDark,
//                   haveBorder: false,
//                   title: "Modifier la commande",
//                   onPressed: () {
//                     /*posController.deleteCart();
//                     posController.orderNotes.value = ordersData.orderNotes!;
//                     for (var i = 0; i < ordersData.orderDetails!.length; i++) {
//                       FoodData food = ordersData.orderDetails![i].food != null
//                           ? ordersData.orderDetails![i].food
//                           : ordersData.orderDetails![i].bundle;

//                       if (food.price != ordersData.orderDetails![i].price &&
//                           food.foodVariantCategory != null &&
//                           food.foodVariantCategory!.isNotEmpty) {
//                         final FoodVariant? foodVariant = food
//                             .foodVariantCategory![0].foodVariant!
//                             .firstWhere((element) =>
//                                 element.price! ==
//                                 ordersData.orderDetails![i].price);
//                         posController.addCart(
//                             context,
//                             food,
//                             foodVariant,
//                             ordersData.orderDetails![i].quantity,
//                             ordersData.orderDetails![i].price,
//                             true);
//                         continue;
//                       }

//                       posController.addCart(
//                           context,
//                           food,
//                           null,
//                           ordersData.orderDetails![i].quantity,
//                           ordersData.orderDetails![i].price,
//                           true);
//                     }
//                     posController.setCurrentOrder(ordersData);
//                     if (ordersData.customer != null) {
//                       posController.customer.value = ordersData.customer!;
//                     }

//                     posController.orderNotes.value = ordersData.orderNotes!;
//                     posController.note.text = ordersData.orderNotes!;

//                     AppHelpersCommon.showCustomModalBottomSheet(
//                       context: context,
//                       modal: const CartOrderView(),
//                       isDarkMode: false,
//                       isDrag: true,
//                       radius: 12,
//                     );*/
//                   },
//                 ),
//               ),
//             ],
//           )
//         : const SizedBox();
//   }

//   Widget totalCommand(String name, int price) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               name,
//               style: Style.interNormal(size: 16.sp, color: Style.dark),
//             ),
//             Text(
//               '$price'.currencyLong(),
//               style: Style.interNormal(size: 16.sp, color: Style.titleDark),
//             ),
//           ],
//         ),
//         Divider(
//           color: Style.light,
//           height: 15.h,
//           thickness: 1,
//         ),
//       ],
//     );
//   }

//   Widget paymentMethodAndInvoice(dynamic payment, String title, String body,
//       bool isInvoice, Order ordersData, bool isPending) {
//     final sizeScreen = MediaQuery.of(context).size;
//     return Container(
//       width: isPending ? double.infinity : sizeScreen.width - 210.w,
//       height: 55.h,
//       decoration: BoxDecoration(
//           color: Style.lighter, borderRadius: BorderRadius.circular(5)),
//       child: Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: Style.interNormal(size: 10.sp, color: Style.dark),
//                 ),
//                 Text(
//                   isInvoice ? "${body}${ordersData.orderNumber}" : body,
//                   style: isInvoice
//                       ? Style.interBold(size: 10.sp, color: Style.dark)
//                       : Style.interNormal(size: 10.sp, color: Style.dark),
//                 ),
//               ],
//             ),
//             isInvoice
//                 ? Container(
//                     width: 50.w,
//                     height: 25.h,
//                     decoration: BoxDecoration(
//                         color: Style.primaryColor,
//                         borderRadius: BorderRadius.circular(15)),
//                     child: InkWell(
//                       onTap: () {
//                         //Get.toNamed(Routes.INVOICE_PDF, arguments: ordersData);
//                       },
//                       child: Center(
//                         child: Text(
//                           "Voir",
//                           style: Style.interBold(size: 11.sp),
//                         ),
//                       ),
//                     ),
//                   )
//                 : payment.isNotEmpty
//                     ? Container(
//                         width: 25.w,
//                         height: 25.h,
//                         child: Image.asset(
//                           payment['icon'] ?? "",
//                         ),
//                       )
//                     : Container(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget clientInformation(String title, String customerType) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(title,
//                 style: Style.interNormal(size: 16.sp, color: Style.dark)),
//             Text(
//               "Client de passe",
//              /* customerType == "GUEST"
//                   ? "Client de passe"
//                   : "${ordersData.customer?.lastname != null ? ordersData.customer?.lastname : ""} ${ordersData.customer?.firstname != null ? ordersData.customer?.firstname : ""}",*/
//               style: Style.interNormal(size: 14.sp, color: Style.titleDark),
//             ),
//           ],
//         ),
//         Divider(
//           color: Style.light,
//           height: 15.h,
//           thickness: 1,
//         ),
//       ],
//     );
//   }
// }
