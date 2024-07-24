import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_card_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_filter.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_list_empty.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/orders_search.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_tab_bar.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/loading.ui.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 3, vsync: this);
  final OrdersController _ordersController = Get.find();
  //final UserEntity? user = AppHelpersCommon.getUserInLocalStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.white, //lighter
        body: GetBuilder<OrdersController>(
            builder: (ordersController) => Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            const OrdersSearchComponent(),
                            CustomTabBarUi(
                              tabController: _tabController,
                              tabs: tabs,
                            ),
                          /*  Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ordersController.isProductLoading == true
                                      ? const LoadingUi()
                                      : ordersController.orders.isEmpty
                                          ? OrderListEmptyComponent()
                                          : OrderCardItemComponent(
                                              orders:ordersController.orders,
                                              isRestaurant :user != null &&
                                                  user?.restaurantUser !=
                                                      null &&
                                                  user?.restaurantUser![0]
                                                              .restaurant
                                                          ?.type ==
                                                      AppConstants
                                                          .clientTypeRestaurant,
                                              //widget.mainController,
                                            ),
                                  ordersController.isProductLoading == true ?  const LoadingUi() : ordersController.orders
                                          .where((item) => AppConstants
                                              .getStatusOrderInProgressOrDone(
                                                  item, "IN_PROGRESS"))
                                          .isEmpty
                                      ? OrderListEmptyComponent()
                                      : OrderCardItemComponent(
                                          orders:ordersController.orders
                                              .where((item) => AppConstants
                                                  .getStatusOrderInProgressOrDone(
                                                      item, "IN_PROGRESS"))
                                              .toList(),
                                          isRestaurant :user != null &&
                                              user?.restaurantUser!= null &&
                                              user?.restaurantUser![0]
                                                      .restaurant?.type ==
                                                  AppConstants
                                                      .clientTypeRestaurant,
                                          //widget.mainController,
                                        ),
                                  ordersController.isProductLoading == true ?  const LoadingUi() : ordersController.orders
                                          .where((item) => AppConstants
                                              .getStatusOrderInProgressOrDone(
                                                  item, "DONE"))
                                          .isEmpty
                                      ? OrderListEmptyComponent()
                                      : OrderCardItemComponent(
                                          orders: ordersController.orders
                                              .where((item) => AppConstants
                                                  .getStatusOrderInProgressOrDone(
                                                      item, "DONE"))
                                              .toList(),
                                          isRestaurant :user != null &&
                                              user?.restaurantUser != null &&
                                              user?.restaurantUser![0]
                                                      .restaurant?.type ==
                                                  AppConstants
                                                      .clientTypeRestaurant,
                                          //widget.mainController,
                                        ),
                                ],
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Style.transparent,
          onPressed: () {
            AppHelpersCommon.showCustomModalBottomSheet(
              paddingTop: MediaQuery.of(context).padding.top,
              context: context,
              radius: 12,
              modal: OrderFilterComponent(
                onChangeDay: (rangeDatePicker) async {
                  await _ordersController.fetchOrders();
                },
              ),
              isDarkMode: true,
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Style.secondaryColor,
            ),
            padding: REdgeInsets.all(16),
            child: const Icon(
              FlutterRemix.calendar_todo_fill,
              color: Style.white,
            ),
          ),
        ));
  }
}