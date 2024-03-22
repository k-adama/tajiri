import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class OrderCancelDialogComponent extends StatelessWidget {
  final VoidCallback cancel;
  final VoidCallback noCancel;
  const OrderCancelDialogComponent(
      {Key? key, required this.cancel, required this.noCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60.w),
      decoration: BoxDecoration(
        color: Style.white.withOpacity(0.96),
        boxShadow: [
          BoxShadow(
            color: Style.white.withOpacity(0.65),
            spreadRadius: 0,
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Êtes vous sûr de vouloir annuler cette commande ?",
            style: Style.interNormal(
              size: 14,
              color: Style.black,
            ),
          ),
          50.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomButton(
                  title: "NON",
                  onPressed: noCancel,
                  background: Style.transparent,
                  textColor: Style.black,
                  isLoadingColor: Style.black,
                  borderColor: Style.borderColor,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: CustomButton(
                  title: "OUI",
                  onPressed: cancel,
                  background: Style.red,
                  textColor: Style.white,
                  isLoadingColor: Style.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
