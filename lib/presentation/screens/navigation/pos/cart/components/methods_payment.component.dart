import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';

class MethodsPaymentComponent extends StatefulWidget {
  const MethodsPaymentComponent({super.key});

  @override
  State<MethodsPaymentComponent> createState() =>
      _MethodsPaymentComponentState();
}

class _MethodsPaymentComponentState extends State<MethodsPaymentComponent> {
  final posController = Get.find<PosController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 80.0,
          mainAxisSpacing: 1,
          crossAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        itemCount: PAIEMENTS.length,
        itemBuilder: (context, index) {
          final settleOrder = PAIEMENTS[index];
          return Obx(() => InkWell(
                key: Key(settleOrder['id']),
                onTap: () {
                  posController.paymentMethodId.value = settleOrder['id'];
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(1.0.w),
                    child: Card(
                      elevation: posController.paymentMethodId.value !=
                              settleOrder['id']
                          ? 0
                          : 15,
                      child: Container(
                        height: posController.paymentMethodId.value !=
                                settleOrder['id']
                            ? 69.h
                            : 70.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: posController.paymentMethodId.value !=
                                  settleOrder['id']
                              ? Style.lightBlue
                              : Style.white,
                          borderRadius: posController.paymentMethodId.value !=
                                  settleOrder['id']
                              ? BorderRadius.circular(1)
                              : BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: posController.paymentMethodId.value !=
                                        settleOrder['id']
                                    ? 33.w
                                    : 34.w,
                                height: posController.paymentMethodId.value !=
                                        settleOrder['id']
                                    ? 29.h
                                    : 30.h,
                                child: Image.asset(
                                  settleOrder['icon'],
                                  height: posController.paymentMethodId.value !=
                                          settleOrder['id']
                                      ? 29.h
                                      : 30.h,
                                ),
                              ),
                              Text(
                                settleOrder['name'],
                                style: Style.interNormal(
                                    size: posController.paymentMethodId.value !=
                                            settleOrder['id']
                                        ? 9.sp
                                        : 10.sp),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
