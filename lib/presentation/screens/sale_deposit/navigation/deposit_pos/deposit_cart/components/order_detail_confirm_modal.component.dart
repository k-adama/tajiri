import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class OrderConfirmDetailModalComponent extends StatelessWidget {
  final bool isLoading;
  final VoidCallback confirmOrder;

  const OrderConfirmDetailModalComponent(
      {super.key, required this.isLoading, required this.confirmOrder});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4.h,
                width: 180,
                decoration: BoxDecoration(
                  color: Style.black,
                  borderRadius: BorderRadius.all(Radius.circular(40.r)),
                ),
              ),
            ),
            20.verticalSpace,
            Text(
              "Restaurant Bellevue",
              style: Style.interBold(
                size: 20,
              ),
            ),
            Text(
              "06.09.2024  10:31",
              style: Style.interBold(
                size: 20,
                color: Colors.grey,
              ),
            ),
            const Divider(thickness: 1, color: Style.grey100),
            16.verticalSpace,
            20.verticalSpace,
            SizedBox(
              height: 45,
              child: CustomButton(
                background: tajiriDesignSystem.appColors.mainBlue500,
                title: "Enregistrer la commande",
                isLoading: isLoading,
                textColor: Style.white,
                isLoadingColor: Style.white,
                haveBorder: false,
                radius: 5,
                onPressed: confirmOrder,
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
