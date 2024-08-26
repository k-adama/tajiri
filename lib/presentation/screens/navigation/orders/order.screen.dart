import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_card_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_filter.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_list_empty.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/orders_search.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_tab_bar.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/loading.ui.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 3, vsync: this);
  final OrdersController _ordersController = Get.put(OrdersController());
  final Staff? user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.white, //lighter
        body: Column(
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
                    Expanded(
                      child: Obx(() {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            _buildOrderTab(
                              isLoading:
                                  _ordersController.isProductLoading.value,
                              orders: _ordersController.orders,
                              filter: (order) =>
                                  true, // No filter for the first tab
                              restaurant: restaurant,
                            ),
                            _buildOrderTab(
                              isLoading:
                                  _ordersController.isProductLoading.value,
                              orders: _ordersController.orders,
                              filter: (order) =>
                                  AppConstants.getStatusOrderInProgressOrDone(
                                      order, "IN_PROGRESS"),
                              restaurant: restaurant,
                            ),
                            _buildOrderTab(
                              isLoading:
                                  _ordersController.isProductLoading.value,
                              orders: _ordersController.orders,
                              filter: (order) =>
                                  AppConstants.getStatusOrderInProgressOrDone(
                                      order, "DONE"),
                              restaurant: restaurant,
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  bool _isRestaurantUser(Restaurant? restaurant) {
    if (restaurant == null) {
      return false;
    }
    return restaurant.name.isNotEmpty &&
        restaurant.type == AppConstants.clientTypeRestaurant;
  }

  Widget _buildOrderTab({
    required bool isLoading,
    required List<Order> orders,
    required bool Function(Order) filter,
    required Restaurant? restaurant,
  }) {
    if (isLoading) {
      return const LoadingUi();
    }

    final filteredOrders = orders.where(filter).toList();
    if (filteredOrders.isEmpty) {
      return const OrderListEmptyComponent();
    }

    return OrderCardItemComponent(
      orders: filteredOrders,
      isRestaurant: _isRestaurantUser(restaurant),
    );
  }
}
