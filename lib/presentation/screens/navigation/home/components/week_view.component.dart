import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class WeeklyViewComponent extends StatefulWidget {
  final double? widgetWidth;
  final double? textSize;
  final HomeController homeController;

  const WeeklyViewComponent(
      {super.key,
      this.textSize,
      this.widgetWidth,
      required this.homeController});

  @override
  State<WeeklyViewComponent> createState() => _WeeklyViewComponentState();
}

class _WeeklyViewComponentState extends State<WeeklyViewComponent> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.homeController.tabs.isNotEmpty
        ? Container(
            //color: Style.white,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildWeekButton("Surpassée", "sur_last", context),
              _buildWeekButton("Sem. Passée", "last", context),
              _buildWeekButton("En cours", "current", context), //Cette semaine
            ]),
          )
        : const SizedBox());
  }

  Widget _buildWeekButton(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
      child: GestureDetector(
        onTap: () async {
          widget.homeController.selectedWeek.value = value;
          widget.homeController.updateDatesByWeekly(value);
          widget.homeController.isFetching.value = true;
          await widget.homeController.fetchDataForReports();
        },
        child: Container(
          height: 40.h,
          width: widget.widgetWidth, // 110 100 not overflow | origin width 120
          decoration: BoxDecoration(
            color: value == widget.homeController.selectedWeek.value
                ? Style.secondaryColor
                : Style.light,
            borderRadius: BorderRadius.circular(30),
            // border: Border.all(width: 1, color: Style.black)
          ),
          child: Center(
            child: Text(
              label,
              style: Style.interBold(
                size: widget.textSize!,
                color: value == widget.homeController.selectedWeek.value
                    ? Style.white
                    : Style.dark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
