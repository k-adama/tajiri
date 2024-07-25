import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/categories.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/chart_bar_view.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/method_of_payment.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/sales_pay_and_register.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/tab_view.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/top_10_products.component.dart';
import 'package:upgrader/upgrader.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _homeController = Get.find();

  late TabController _tabController;
  late RefreshController _storyController;
  late RefreshController _smartRefreshController;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _storyController = RefreshController();
    _smartRefreshController = RefreshController();
    // initializeDateFormatting('fr_FR', null);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _storyController.dispose();
    _smartRefreshController.dispose();
    super.dispose();
  }

  void _onLoading() async {
    await _homeController.fetchDataForReports();
    _smartRefreshController.loadComplete();
  }

  void _onRefresh() async {
    await _homeController.fetchDataForReports();
    _smartRefreshController.refreshCompleted();
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
          controller: _smartRefreshController,
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
                  10.verticalSpace,
                  TabViewComponent(
                    homeController: _homeController,
                    tabController: _tabController,
                    changeIndex: (index) => setState(() {
                      _tabController.index = index;
                    }),
                  ),
                  SizedBox(
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
                              child: ChartBarViewComponent(
                                homeController: _homeController,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 170.h,
                          left: 20,
                          right: 20,
                          child: SalesPayAndRegisterComponent(
                            homeController: _homeController,
                          ),
                        )
                      ],
                    ),
                  ),
                  const MethodOfPaymentComponent(),
                  const CategoriesComponent(),
                  const Top10ProductsComponent()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
