import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:get/get.dart';

class SeeStockOrSaveButtonComponent extends StatefulWidget {
  final Product food;
  bool seeHistory;
  final int addValue;
  VoidCallback haveSeeHistory;
  SeeStockOrSaveButtonComponent(
      {super.key,
      required this.food,
      required this.seeHistory,
      required this.addValue,
      required this.haveSeeHistory});

  @override
  State<SeeStockOrSaveButtonComponent> createState() =>
      _SeeStockOrSaveButtonComponentState();
}

class _SeeStockOrSaveButtonComponentState
    extends State<SeeStockOrSaveButtonComponent> {
  @override
  final StockController stockController = Get.find();
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 24.h,
              right: 16.w,
              left: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomButton(
                  isLoading: false,
                  background: Style.transparent,
                  title: "Voir l'historique",
                  textColor: Style.titleDark,
                  isLoadingColor: Style.titleDark,
                  haveBorder: false,
                  radius: 5,
                  borderColor: Style.black,
                  onPressed: () {
                    widget.haveSeeHistory();
                    Mixpanel.instance.track("History Viewed",
                        properties: {"Product name": widget.food.name});
                  },
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: CustomButton(
                  isLoading: false,
                  background: Style.primaryColor,
                  title: "Enregistrer",
                  textColor: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  radius: 5,
                  haveBorder: false,
                  onPressed: () {
                    Mixpanel.instance
                        .track("Stock Inventory Adjustment", properties: {
                      "Product name": widget.food.name,
                      "Old Quantity": widget.food.quantity,
                      "New Quantity": widget.addValue
                    });

                    stockController.updateStockMovement(
                        context,
                        widget.food.id ?? "",
                        widget.addValue ?? 0,
                        "STOCK_ADJUSTMENT");
                    // alert
                    //Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
