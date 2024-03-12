import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/day_view.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/month_view.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/week_view.component.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

typedef ChangeIndexFunction = void Function(int index);

class TabViewComponent extends StatelessWidget {
  final HomeController homeController;
  final TabController tabController;
  final ChangeIndexFunction changeIndex;

  const TabViewComponent(
      {super.key,
      required this.homeController,
      required this.tabController,
      required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Builder(builder: (BuildContext context) {
        return LayoutBuilder(builder: (BuildContext context, constraints) {
          if (constraints.maxHeight >= 200) {
            return DefaultTabController(
              length: 3,
              child: SizedBox(
                width: double.infinity,
                height: 110.h,
                child: Column(
                  children: [
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Style.light,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerHeight: 0,
                        indicator: BoxDecoration(
                          color: Style.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onTap: (index) async {
                          changeIndex(index);
                          homeController.viewSelected.value =
                              homeController.tabs[index];
                          switch (index) {
                            case 0:
                              homeController.startDate =
                                  homeController.selectedDate.value;
                              homeController.endDate =
                                  homeController.selectedDate.value;

                              break;
                            case 1:
                              homeController.updateDatesByWeekly(
                                  homeController.selectedWeek.value);
                              break;
                            default:
                              int currentMonth =
                                  homeController.getCurrentMonth();
                              final dateRange = homeController
                                  .getFirstAndLastDayOfMonth(currentMonth);
                              homeController.startDate = dateRange['start']!;
                              homeController.endDate = dateRange['end']!;
                          }
                          homeController.isFetching.value = true;
                          await homeController.fetchDataForReports(
                              indexFilter: index);
                        },
                        tabs: List.generate(
                          3,
                          (index) => Tab(
                            child: Text(
                              homeController.tabs[index].capitalizeFirst!,
                              style: Style.interNormal(
                                size: 11.sp,
                                color: tabController.index == index
                                    ? Style.dark
                                    : Style.dark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        // constraints.maxHeight | constraints.maxWidth
                        if (constraints.maxHeight <= 200) {
                          return TabBarView(
                            controller: tabController,
                            children: [
                              DayViewComponent(
                                textSize: 10.sp,
                                widgetWidth: constraints.maxWidth - 310.w,
                                homeController: homeController,
                              ),
                              WeeklyViewComponent(
                                textSize: 10.sp,
                                widgetWidth: constraints.maxWidth - 260.w,
                                homeController: homeController,
                              ),
                              MonthlyViewComponent(
                                textSize: 10.sp,
                                widgetWidth: constraints.maxWidth - 315.w,
                                homeController: homeController,
                              ),
                            ],
                          );
                        } else {
                          return TabBarView(
                            controller: tabController,
                            children: [
                              DayViewComponent(
                                textSize: 10.sp,
                                widgetWidth: 50.w,
                                homeController: homeController,
                              ),
                              WeeklyViewComponent(
                                textSize: 10.sp,
                                widgetWidth: 120.w,
                                homeController: homeController,
                              ),
                              MonthlyViewComponent(
                                textSize: 14.sp,
                                widgetWidth: 50.w,
                                homeController: homeController,
                              ),
                            ],
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return DefaultTabController(
              length: 3,
              child: SizedBox(
                width: double.infinity,
                height: 110.h,
                child: Column(
                  children: [
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Style.light,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: tabController,
                        dividerHeight: 0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Style.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: (index) async {
                          //changeIndex(index);
                          homeController.viewSelected.value =
                              homeController.tabs[index];
                          switch (index) {
                            case 0:
                              homeController.startDate =
                                  homeController.selectedDate.value;
                              homeController.endDate =
                                  homeController.selectedDate.value;

                              break;
                            case 1:
                              homeController.updateDatesByWeekly(
                                  homeController.selectedWeek.value);
                              break;
                            default:
                              final dateRange =
                                  homeController.getFirstAndLastDayOfMonth(
                                      homeController.selectedMonth.value);
                              homeController.startDate = dateRange['start']!;
                              homeController.endDate = dateRange['end']!;
                          }
                          homeController.isFetching.value = true;
                          await homeController.fetchDataForReports();
                        },
                        tabs: List.generate(
                          3,
                          (index) => Tab(
                            child: Text(
                              homeController.tabs[index].capitalizeFirst!,
                              style: Style.interNormal(
                                size: 11.sp,
                                color: tabController.index == index
                                    ? Style.dark
                                    : Style.dark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        // constraints.maxHeight | constraints.maxWidth
                        if (constraints.maxHeight <= 200) {
                          return TabBarView(
                            controller: tabController,
                            children: [
                              DayViewComponent(
                                textSize: 10.sp,
                                widgetWidth: 45.w,
                                homeController: homeController,
                              ),
                              WeeklyViewComponent(
                                textSize: 10.sp,
                                widgetWidth: 110.w,
                                homeController: homeController,
                              ),
                              MonthlyViewComponent(
                                textSize: 10.sp,
                                widgetWidth: 45.w,
                                homeController: homeController,
                              ),
                            ],
                          );
                        } else {
                          return TabBarView(
                            controller: tabController,
                            children: [
                              DayViewComponent(
                                textSize: 10.sp,
                                widgetWidth: 50.w,
                                homeController: homeController,
                              ),
                              WeeklyViewComponent(
                                textSize: 10.sp,
                                widgetWidth: 120.w,
                                homeController: homeController,
                              ),
                              MonthlyViewComponent(
                                textSize: 14.sp,
                                widgetWidth: 50.w,
                                homeController: homeController,
                              ),
                            ],
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            );
          }
        });
      }),
    );
  }
}
