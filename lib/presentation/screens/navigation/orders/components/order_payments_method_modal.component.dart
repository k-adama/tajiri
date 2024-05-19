import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';

class OrderPaymentsMethodesModalComponent extends StatefulWidget {
  const OrderPaymentsMethodesModalComponent({super.key});

  @override
  State<OrderPaymentsMethodesModalComponent> createState() => _OrderPaymentsMethodesModalComponentState();
}

class _OrderPaymentsMethodesModalComponentState extends State<OrderPaymentsMethodesModalComponent> {
  final NavigationController navigationController = Get.put(NavigationController());
  final OrdersController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Style.white.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 40,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  color: Style.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  )),
              width: double.infinity,
              height: screenSize.height - 150.h,
              child: KeyboardDismisserUi(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    8.verticalSpace,
                    Center(
                      child: Container(
                        height: 4.0,
                        width: 48.0,
                        decoration: const BoxDecoration(
                          color: Style.dragElement,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0), // Adjust radius as needed
                          ),
                        ),
                      ),
                    ),
                    24.verticalSpace,
                   Expanded(
                     flex: 1,
                     child:  Container(
                       height: 70,
                       width: double.infinity,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "Méthode de paiement",
                             style: Style.interBold(size: 18.sp),
                           ),
                           Text(
                             "Veuillez sélectionner un mode de paiement",
                             style: Style.interNormal(
                                 size: 13.sp, color: Style.dark),
                           )
                         ],
                       ),
                     ),
                   ),
                   Expanded(
                     flex: 6,
                     child: ListView.builder(
                       shrinkWrap: true,
                       scrollDirection: Axis.vertical,
                       itemCount: PAIEMENTS.length,
                       itemBuilder: (BuildContext context, index) {
                         final settleOrder = PAIEMENTS[index];
                         return InkWell(
                           key: Key(settleOrder['id']),
                           onTap: () async {
                            navigationController.posController.paymentMethodId.value = settleOrder['id'];
                             Navigator.pop(context);
                             await orderController.updateOrder(
                                 context, settleOrder['id']);
                           },
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(
                               width: double.infinity,
                               height: 70,
                               decoration: BoxDecoration(
                                 color: navigationController.posController.paymentMethodId.value !=
                                     settleOrder['id']
                                     ? Style.white.withOpacity(0.9)
                                     : Style.lighter,
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(
                                     horizontal: 20.0, vertical: 20),
                                 child: Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceBetween,
                                   children: [
                                     Container(
                                       width: 150,
                                       height: 50,
                                       child: Row(
                                         crossAxisAlignment:
                                         CrossAxisAlignment.start,
                                         children: [
                                           Image.asset(
                                             settleOrder['icon'],
                                             width: 25,
                                             height: 25,
                                           ),
                                           20.horizontalSpace,
                                           Text(
                                             settleOrder['name'],
                                             style: Style.interNormal(
                                                 color: Style.black, size: 20),
                                           )
                                         ],
                                       ),
                                     ),
                                     Container(
                                       width: 30,
                                       height: 30,
                                       child: const Icon(
                                         Icons.arrow_forward_ios_outlined,
                                         color: Style.dark,
                                         size: 20,
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ),
                           ),
                         );
                       },
                     ),
                   )

                  ],
                ),
              )),
            )),
      ),
    );
  }
}
