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
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/type_command.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class CartSaveScreen extends StatefulWidget {
  const CartSaveScreen({super.key});

  @override
  State<CartSaveScreen> createState() => _CartSaveScreenState();
}

class _CartSaveScreenState extends State<CartSaveScreen> {
  final cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Style.lightBlue,
      body: GetBuilder<PosController>(
        builder: (posController) => Column(
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
                      "Enregistrement",
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
            Expanded(
              child: Container(
                color: Style.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
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
                        20.verticalSpace,
                        const Divider(),
                        20.verticalSpace,
                        // Text(
                        //   "ENTRER UNE NOTE",
                        //   style: Style.interNormal(
                        //     color: Style.dark,
                        //     size: 12.sp,
                        //   ),
                        // ),
                        // 3.verticalSpace,
                        // NoteFieldComponent(
                        //   onChanged: (value) {
                        //     posController.orderNotes.value = value;
                        //   },
                        //   controller: posController.note,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
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
                            "${posController.totalCartValue}".notCurrency(),
                            style: Style.interBold(
                              size: 20.sp,
                              color: Style.black,
                            ),
                          ),
                          Positioned(
                            left: cartController.getTextWidth(
                              posController.totalCartValue.toString(),
                              Style.interNormal(
                                size: 20.sp,
                                color: Style.darker,
                              ),
                            ),
                            bottom: 2,
                            child: SizedBox(
                              width: 40.w,
                              height: 14.h,
                              child: Text(
                                TrKeysConstant.splashFcfa,
                                style: Style.interNormal(
                                    size: 8.sp, color: Style.darker),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                isLoading: posController.isLoadingOrder.value,
                background: Style.primaryColor,
                title: "Enregistrer",
                radius: 3,
                textColor: Style.secondaryColor,
                isLoadingColor: Style.secondaryColor,
                onPressed: () async {
                  await posController.handleCreateOrderInProgres(context);
                },
              ),
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
