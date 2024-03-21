import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class InvoiceButtonsComponent extends StatefulWidget {
  final OrdersDataEntity ordersData;
  final VoidCallback printButtonTap;
  final VoidCallback shareButtonTap;
  final VoidCallback returnToOrderButtonTap;

  const InvoiceButtonsComponent({
    super.key,
    required this.ordersData,
    required this.printButtonTap,
    required this.shareButtonTap,
    required this.returnToOrderButtonTap,
  });

  @override
  State<InvoiceButtonsComponent> createState() =>
      _InvoiceButtonsComponentState();
}

class _InvoiceButtonsComponentState extends State<InvoiceButtonsComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.ordersData.status == "PAID" ? 10.0 : 10.0,
            vertical: 1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  title: widget.ordersData.status == "PAID"
                      ? 'Imprimer le reçu'
                      : 'Imprimer la facture',
                  textColor: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  weight: 20,
                  background: Style.primaryColor,
                  radius: 5,
                  isUnderline: false,
                  onPressed: widget.printButtonTap,
                ),
                CustomButton(
                  title: widget.ordersData.status == "PAID"
                      ? 'Partager le reçu'
                      : 'Imprimer la facture',
                  textColor: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  weight: 20,
                  background: Style.white,
                  radius: 5,
                  haveBorder: true,
                  isUnderline: false,
                  borderColor: Style.secondaryColor,
                  onPressed: widget.shareButtonTap,
                ),
              ],
            ),
            5.verticalSpace,
            CustomButton(
              title: "Retour à la prise de commande",
              textColor: Style.secondaryColor,
              isLoadingColor: Style.secondaryColor,
              weight: 20,
              background: Style.white,
              radius: 5,
              haveBorder: false,
              isUnderline: true,
              onPressed: widget.returnToOrderButtonTap,
            ),
          ],
        ),
      ),
    );
  }
}
