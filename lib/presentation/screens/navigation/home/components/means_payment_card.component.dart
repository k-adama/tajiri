import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/payment_method_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class MeansPaymentCardComponent extends StatelessWidget {
  final Map<String, dynamic> meansOfpayment;
  const MeansPaymentCardComponent({super.key, required this.meansOfpayment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Style.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(
              meansOfpayment['icon'],
              height: 30.h,
            ),
            SizedBox(
              width: 12.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meansOfpayment['name'],
                  style: Style.interNormal(size: 8.sp, color: Style.darker),
                ),
                GetBuilder<HomeController>(builder: (homeController) {
                  final dynamic payment =
                      homeController.paymentsMethodAmount.firstWhere(
                    (itemPy) => itemPy.id == meansOfpayment['id'],
                    orElse: () => PaymentMethodDataEntity(
                      id: meansOfpayment['id'],
                      total: 0,
                      name: meansOfpayment['name'],
                    ),
                  );

                  final total = payment.total ?? 0;
                  return RichText(
                    text: TextSpan(
                      text: "$total".notCurrency(),
                      style: Style.interBold(
                          size: 10.sp, color: Style.secondaryColor),
                      children: const <TextSpan>[
                        TextSpan(
                            text: TrKeysConstant.splashFcfa,
                            style: TextStyle(color: Style.dark)),
                      ],
                    ),
                  );
                })
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
