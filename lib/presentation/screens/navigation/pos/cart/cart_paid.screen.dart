import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/cart/cart.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/customer_info_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/customer_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/methods_payment.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/type_command.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class CartPaidScreen extends StatefulWidget {
  const CartPaidScreen({super.key});

  @override
  State<CartPaidScreen> createState() => _CartPaidScreenState();
}

class _CartPaidScreenState extends State<CartPaidScreen> {
  final posController = Get.find<PosController>();
  final cartController = Get.find<CartController>();

  final waitressId = Get.arguments;

  @override
  void initState() {
    super.initState();
    posController.waitressCurrentId;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Style.white,
      body: GetBuilder<PosController>(
        builder: (_posController) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Style.white,
              width: double.infinity,
              height: 150.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Paiement",
                      style: Style.interBold(size: 29.sp),
                    ),
                    InkWell(
                      onTap: () {
                        AppHelpersCommon.showCustomModalBottomSheet(
                          context: context,
                          modal: const CustomerListComponent(),
                          isDarkMode: false,
                          isDrag: true,
                          radius: 12,
                        );
                      },
                      child: Obx(() {
                        return CustomerInfoCardComponent(
                          customer: posController.customer.value,
                          width: (size.width - 50) * 0.60,
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
            10.verticalSpace,
            Container(
              color: Style.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Méthode de paiment".toUpperCase(),
                          style: TextStyle(
                            color: Style.dark,
                            fontSize: 12.sp,
                          ),
                        ),
                        const MethodsPaymentComponent(),
                        const Divider(),
                      ],
                    ),
                    10.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Type de commande".toUpperCase(),
                          style: TextStyle(
                            color: Style.dark,
                            fontSize: 12.sp,
                          ),
                        ),
                        const TypeCommandComponent(),
                        10.verticalSpace,
                        const Divider(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 60.h,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TOTAL",
                                style: TextStyle(
                                  color: Style.dark,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(
                                width: 250.w,
                                height: 30.h,
                                child: Stack(
                                  children: [
                                    Text(
                                      "${posController.totalCartValue}"
                                          .notCurrency(),
                                      style: Style.interBold(
                                        size: 20.sp,
                                        color: Style.black,
                                      ),
                                    ),
                                    Positioned(
                                      left: cartController.getTextWidth(
                                        posController.totalCartValue.toString(),
                                        Style.interNormal(
                                          size: 20,
                                          color: Style.darker,
                                        ),
                                      ),
                                      bottom: 2,
                                      child: SizedBox(
                                        width: 40.w,
                                        height: 14.sp,
                                        child: Text(
                                          TrKeysConstant.splashFcfa,
                                          style: Style.interNormal(
                                              size: 8, color: Style.darker),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), // Adjust spacing as needed
                        Obx(() {
                          return CustomButton(
                            isLoading: posController.isLoadingOrder.value,
                            background: Style.primaryColor,
                            title: "Payer",
                            radius: 3,
                            textColor: Style.secondaryColor,
                            isLoadingColor: Style.secondaryColor,
                            onPressed: () async {
                              await posController.handleCreateOrder(context);
                            },
                          );
                        }),
                        24.verticalSpace,
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
