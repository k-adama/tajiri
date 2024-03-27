import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';

class StockCardTitleComponent extends StatelessWidget {
  final String title;
  final String description;
  final bool isTitle;
  StockCardTitleComponent(
      {super.key,
      required this.title,
      required this.description,
      required this.isTitle});

  final StockController stockController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      child: Text(
        stockController.checkboxstatus
            ? title // title
            : description, // description
        style: isTitle
            ? Style.interBold(
                size: 18.sp,
                color: stockController.checkboxstatus
                    ? Style.titleDark
                    : Style.white,
              )
            : Style.interNormal(
                size: 12.sp,
                color: stockController.checkboxstatus
                    ? Style.titleDark
                    : Style.white,
              ),
      ),
    );
  }
}
