import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class DayViewComponent extends StatefulWidget {
  final double? widgetWidth;
  final double? textSize;
  final HomeController homeController;
  const DayViewComponent(
      {super.key,
      this.textSize,
      this.widgetWidth,
      required this.homeController});
  @override
  State<DayViewComponent> createState() => _DayViewComponentState();
}

class _DayViewComponentState extends State<DayViewComponent> {
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      child: SizedBox(
        //color: Style.white,
        width: double.infinity,
        child: Obx(() => widget.homeController.tabs.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (DateTime date in widget.homeController.weekDates)
                    GestureDetector(
                      key: Key('date_${date.toIso8601String()}'),
                      onTap: () async {
                        if (date.isAfter(currentDate)) return;
                        widget.homeController.selectedDate.value = date;
                        widget.homeController.startDate = date;
                        widget.homeController.endDate = date;
                        widget.homeController.isFetching.value = true;
                        await widget.homeController.fetchDataForReports();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            width: widget.widgetWidth! - 5, // 45
                            height: widget.widgetWidth! + 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    widget.homeController.isSelectedDate(date)
                                        ? Style.secondaryColor
                                        : date.isAfter(currentDate)
                                            ? Style.light
                                            : Style.white //Style.light,
                                ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.homeController
                                      .formatDate(date)
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: Style.interSemi(
                                    size: 12.sp,
                                    color: widget.homeController
                                            .isSelectedDate(date)
                                        ? Colors.white
                                        : date.isAfter(currentDate)
                                            ? Style.dark
                                            : Style.dark,
                                  ),
                                ),
                                Text(date.day.toString().padLeft(2, '0'),
                                    style: Style.interBold(
                                      size: widget.homeController
                                              .isSelectedDate(date)
                                          ? 14.sp
                                          : 12.sp,
                                      color: widget.homeController
                                              .isSelectedDate(date)
                                          ? Colors.white
                                          : date.isAfter(currentDate)
                                              ? Colors.black
                                              : Colors.black,
                                    )),
                              ],
                            ),
                          )),
                    ),
                ],
              )
            : const SizedBox()),
      ),
    );
  }
}
