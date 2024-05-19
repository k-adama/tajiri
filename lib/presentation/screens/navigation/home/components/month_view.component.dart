import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class MonthlyViewComponent extends StatefulWidget {
  final double? widgetWidth;
  final double? textSize;
  final HomeController homeController;
  const MonthlyViewComponent(
      {super.key,
      this.textSize,
      this.widgetWidth,
      required this.homeController});
  @override
  State<MonthlyViewComponent> createState() => _MonthlyViewComponentState();
}

class _MonthlyViewComponentState extends State<MonthlyViewComponent> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => widget.homeController.tabs.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  widget.homeController.getLastMonths().map<Widget>((item) {
                final index =
                    widget.homeController.getLastMonths().indexOf(item);
                return GestureDetector(
                  onTap: () async {
                    widget.homeController.selectedMonth.value = index;
                    final monthIndex = monthNames.indexOf(item);
                    final dateRange = widget.homeController
                        .getFirstAndLastDayOfMonth(monthIndex);
                    widget.homeController.startDate = dateRange['start']!;
                    widget.homeController.endDate = dateRange['end']!;

                    widget.homeController.isFetching.value = true;
                    await widget.homeController.fetchDataForReports();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(7),
                    child: _buildDateButton(item, index, context),
                  ),
                );
              }).toList(),
            )
          : const SizedBox(),
    );
  }

  Widget _buildDateButton(String item, int index, BuildContext context) {
    return Container(
      width: widget.widgetWidth, // 45  not overflow | origin width 50 height 50
      height: widget.widgetWidth,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        /*border: Border.all(
          width: 1,
          color: Colors.black,
        ),*/
        color: widget.homeController.selectedMonth.value == index
            ? Style.secondaryColor
            : Style.light,
      ),
      child: Center(
        child: Text(
          item,
          style: Style.interBold(
            size: widget.textSize!,
            color: widget.homeController.selectedMonth == index
                ? Style.white
                : Style.dark,
          ),
        ),
      ),
    );
  }
}
