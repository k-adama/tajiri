import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:upgrader/upgrader.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

typedef ChangeIndexFunction = void Function(int index);

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _homeController = Get.find();

  late TabController _tabController;
  late RefreshController _storyController;
  late RefreshController _fakeController;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _storyController = RefreshController();
    _fakeController = RefreshController();
    initializeDateFormatting('fr_FR', null);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _storyController.dispose();
    _fakeController.dispose();
    super.dispose();
  }

  void _onLoading() async {
    await _homeController.fetchDataForReports();
    _fakeController.loadComplete();
  }

  void _onRefresh() async {
    await _homeController.fetchDataForReports();
    _fakeController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return UpgradeAlert(
      child: Scaffold(
        backgroundColor: Style.lighter,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          physics: const BouncingScrollPhysics(),
          controller: _fakeController,
          header: WaterDropMaterialHeader(
            distance: 160.h,
            backgroundColor: Style.white,
            color: Style.light,
          ),
          onLoading: () => _onLoading(),
          onRefresh: () => _onRefresh(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 22.h),
              child: Column(
                children: [
                  Obx(() {
                    if (_homeController.storiesGroup.isNotEmpty) {
                      return Container(
                        color: Style.white,
                        height: (screenSize.height / 2) - 250.h,
                        child: SmartRefresher(
                          controller: _storyController,
                          scrollDirection: Axis.horizontal,
                          enablePullDown: false,
                          enablePullUp: true,
                          primary: false,
                          onLoading: () async {
                            await _homeController.fetchGroupStories();
                          },
                          child: AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: _homeController.storiesGroup.length,
                              padding: EdgeInsets.only(left: 16.w),
                              itemBuilder: (context, index) =>
                                  AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: ShopBarItem(
                                      index: index,
                                      controller: _storyController,
                                      story: StoryModel(
                                          shopId: 1,
                                          logoImg: _homeController
                                              .storiesGroup[index].logoImg,
                                          title: _homeController
                                              .storiesGroup[index].name,
                                          productUuid: _homeController
                                              .storiesGroup[index].id,
                                          productTitle: _homeController
                                              .storiesGroup[index].name,
                                          url: "",
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox(); // Return an empty widget if storiesGroup is empty
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: tabulation(
                        context,
                        (index) => setState(() {
                              _tabController.index = index;
                            })),
                  ),
                  Container(
                    height: 340.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 180.h,
                            width: double.infinity,
                            child: Card(
                              elevation: 0,
                              child: ChartBarView(),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 170.h,
                          left: 20,
                          right: 20,
                          child: SalesPayAndRegister(),
                        )
                      ],
                    ),
                  ),
                  const MethodOfPayment(),
                  const Categories(),
                  const Top10Products()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tabulation(BuildContext context, ChangeIndexFunction changeIndex) {
    return Builder(builder: (BuildContext context) {
      return LayoutBuilder(builder: (BuildContext context, constraints) {
        if (constraints.maxHeight >= 200) {
          return DefaultTabController(
            length: 3,
            child: Container(
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
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerHeight: 0,
                      indicator: BoxDecoration(
                        color: Style.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onTap: (index) async {
                        changeIndex(index);
                        _homeController.viewSelected.value =
                            _homeController.tabs[index];
                        switch (index) {
                          case 0:
                            _homeController.startDate =
                                _homeController.selectedDate.value;
                            _homeController.endDate =
                                _homeController.selectedDate.value;

                            break;
                          case 1:
                            _homeController.updateDatesByWeekly(
                                _homeController.selectedWeek.value);
                            break;
                          default:
                            int currentMonth =
                                _homeController.getCurrentMonth();
                            final dateRange = _homeController
                                .getFirstAndLastDayOfMonth(currentMonth);
                            _homeController.startDate = dateRange['start']!;
                            _homeController.endDate = dateRange['end']!;
                        }
                        _homeController.isFetching.value = true;
                        await _homeController.fetchDataForReports(
                            indexFilter: index);
                      },
                      tabs: List.generate(
                        3,
                        (index) => Tab(
                          child: Text(
                            _homeController.tabs[index].capitalizeFirst!,
                            style: Style.interNormal(
                              size: 11.sp,
                              color: _tabController.index == index
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
                          controller: _tabController,
                          children: [
                            DayViewComponent(
                              textSize: 10.sp,
                              widgetWidth: constraints.maxWidth - 310.w,
                            ),
                            WeeklyViewComponent(
                              textSize: 10.sp,
                              widgetWidth: constraints.maxWidth - 260.w,
                            ),
                            MonthlyViewComponent(
                              textSize: 10.sp,
                              widgetWidth: constraints.maxWidth - 315.w,
                            ),
                          ],
                        );
                      } else {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            DayViewComponent(
                              textSize: 10.sp,
                              widgetWidth: 50.w,
                            ),
                            WeeklyViewComponent(
                              textSize: 10.sp,
                              widgetWidth: 120.w,
                            ),
                            MonthlyViewComponent(
                              textSize: 14.sp,
                              widgetWidth: 50.w,
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
            child: Container(
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
                      controller: _tabController,
                      dividerHeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Style.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: (index) async {
                        //changeIndex(index);
                        _homeController.viewSelected.value =
                            _homeController.tabs[index];
                        switch (index) {
                          case 0:
                            _homeController.startDate =
                                _homeController.selectedDate.value;
                            _homeController.endDate =
                                _homeController.selectedDate.value;

                            break;
                          case 1:
                            _homeController.updateDatesByWeekly(
                                _homeController.selectedWeek.value);
                            break;
                          default:
                            final dateRange =
                                _homeController.getFirstAndLastDayOfMonth(
                                    _homeController.selectedMonth.value);
                            _homeController.startDate = dateRange['start']!;
                            _homeController.endDate = dateRange['end']!;
                        }
                        _homeController.isFetching.value = true;
                        await _homeController.fetchDataForReports();
                      },
                      tabs: List.generate(
                        3,
                        (index) => Tab(
                          child: Text(
                            _homeController.tabs[index].capitalizeFirst!,
                            style: Style.interNormal(
                              size: 11.sp,
                              color: _tabController.index == index
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
                          controller: _tabController,
                          children: [
                            DayViewComponent(
                              textSize: 10.sp,
                              widgetWidth: 45.w,
                            ),
                            WeeklyViewComponent(
                              textSize: 10.sp,
                              widgetWidth: 110.w,
                            ),
                            MonthlyViewComponent(
                              textSize: 10.sp,
                              widgetWidth: 45.w,
                            ),
                          ],
                        );
                      } else {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            DayViewComponent(
                              textSize: 10.sp,
                              widgetWidth: 50.w,
                            ),
                            WeeklyViewComponent(
                              textSize: 10.sp,
                              widgetWidth: 120.w,
                            ),
                            MonthlyViewComponent(
                              textSize: 14.sp,
                              widgetWidth: 50.w,
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
    });
  }
}
