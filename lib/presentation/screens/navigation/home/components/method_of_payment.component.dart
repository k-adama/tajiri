import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/means_payment_card.component.dart';

class MethodOfPaymentComponent extends StatefulWidget {
  const MethodOfPaymentComponent({super.key});

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
                      var meansOfpayment = PAIEMENTS[
                          index]; // Replace `paymentList` with the actual list of payment items

                      return MeansPaymentCardComponent(
                        meansOfpayment: meansOfpayment,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
