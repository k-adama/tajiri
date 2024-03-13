import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/payment_method_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class MethodOfPaymentComponent extends StatefulWidget {
  final HomeController homeController;
  const MethodOfPaymentComponent({super.key, required this.homeController});

  @override
  State<MethodOfPaymentComponent> createState() =>
      _MethodOfPaymentComponentState();
}

class _MethodOfPaymentComponentState extends State<MethodOfPaymentComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 14.0.w, bottom: 8.0.w, left: 8.0.w, right: 8.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                  child: Text(
                    "Moyen de paiement acceptable",
                    style: Style.interBold(size: 18.sp, color: Style.titleDark),
                    maxLines: 2,
                  ),
                ),
                10.verticalSpace,
                SizedBox(
                  // height: (size.width - 30) / 1.8,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3,
                    ),
                    itemCount: PAIEMENTS.length,
                    itemBuilder: (context, index) {
                      var paymentItem = PAIEMENTS[
                          index]; // Replace `paymentList` with the actual list of payment items

                      return paymentContainer(paymentItem, index);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget paymentContainer(Map<String, dynamic> paymentItem, int index) {
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
              paymentItem['icon'],
              height: 30.h,
            ),
            SizedBox(
              width: 12.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentItem['name'],
                  style: Style.interNormal(size: 8.sp, color: Style.darker),
                ),
                Obx(
                  () {
                    final dynamic payment =
                        widget.homeController.paymentsMethodAmount.firstWhere(
                      (itemPy) => itemPy.id == PAIEMENTS[index]['id'],
                      orElse: () => PaymentMethodDataEntity(
                        id: PAIEMENTS[index]['id'],
                        total: 0,
                        name: PAIEMENTS[index]['name'],
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
                  },
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
