import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mt;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/extensions/staff.extension.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_sdk/src/models/table.model.dart' as taj_sdk;

class OrdersController extends GetxController {
  bool isProductLoading = true;
  bool isLoadingCreateWaitress = false;
  bool isLoadingTable = false;
  RxList<taj_sdk.Table> tableListData = List<taj_sdk.Table>.empty().obs;
  bool isExpanded = false;
  bool isAddAndRemoveLoading = false;
  DateTime? startRangeDate;
  DateTime? endRangeDate;
  List<Order> orders = List<Order>.empty().obs;
  List<Order> ordersInit = List<Order>.empty().obs;
  Rx<bool> isLoadingOrder = false.obs;
  RxString currentOrderId = "".obs;
  double? amount;
  final waitress = List<Waitress>.empty().obs;
  RxString currentOrderNo = "".obs;
  DateTime dateTime = DateTime.now();
  bool monuted = false;
  final Staff? user = AppHelpersCommon.getUserInLocalStorage();
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() {
    streamOrdersChange();
    Future.wait([
      fetchOrders(),
      fetchWaitresses(),
      fetchTables(),
    ]);
    super.onReady();
  }

  streamOrdersChange() async {
    final supabase = Supabase.instance.client;

    supabase
        .channel("orderUpdate")
        .onPostgresChanges(
            table: 'orders',
            event: PostgresChangeEvent.all,
            schema: 'public',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'restaurantId',
                value: user?.restaurantId ?? ""),
            callback: (value) async {
              final newOrderReceveid = value.newRecord;
              final player = AudioPlayer();
              await player.play(UrlSource(urlSound),
                  mode: PlayerMode.mediaPlayer);

              if (newOrderReceveid['status'] == AppConstants.orderNew) {
                final player = AudioPlayer();
                await player.play(UrlSource(urlSound),
                    mode: PlayerMode.mediaPlayer);
              }
              try {
                final idOrder = newOrderReceveid['id'];
                if (idOrder == null) {
                  throw "ID NULL";
                }
                fetchOrderById(idOrder);
              } catch (e) {
                fetchOrders();
              }

              update();
            })
        .subscribe();
  }

  setRangeDate(DateTime startDate, DateTime endDate) {
    startRangeDate = startDate;
    endRangeDate = endDate;
    update();
  }

  Future<void> fetchOrders() async {
    final DateTime today = DateTime.now();
    final DateTime sevenDaysAgo = today.subtract(const Duration(days: 2));
    String? ownerId = user?.idOwnerForGetOrder;
    final GetOrdersDto dto = GetOrdersDto(
      startDate: startRangeDate ?? sevenDaysAgo,
      endDate: endRangeDate ?? today,
      ownerId: ownerId,
    );
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();

      try {
        final result = await tajiriSdk.ordersService.getOrders(dto);
        orders.assignAll(result);
        ordersInit.assignAll(result);
      } catch (e) {
        isProductLoading = false;
        update();
      }
      isProductLoading = false;
      update();
    }
  }

  Future<void> updateOrder(BuildContext context, String paymentMethodId) async {
    if (currentOrderId.isEmpty) return;
    isLoadingOrder.value = true;
    update();
    String status = "PAID";
    final paymentValues = PaymentValueDto(
      paymentMethodId: paymentMethodId,
      amount: amount!.toInt(),
    );
    final updateDto = UpdateOrderDto(
      status: status,
      paymentValues: [paymentValues],
    );
    try {
      await tajiriSdk.ordersService
          .updateOrder(currentOrderId.value, updateDto);
      isLoadingOrder.value = false;
      currentOrderId.value = "";
      currentOrderNo.value = "";
      update();
    } catch (e) {
      isLoadingOrder.value = false;
      currentOrderId.value = "";
      update();
    }
  }

  Future<void> updateOrderStatus(
      BuildContext context, String currentOrderId, String status) async {
    if (currentOrderId.isEmpty) return;
    final UpdateOrderDto updateOrderDto = UpdateOrderDto(status: status);
    isLoadingOrder.value = true;
    try {
      await tajiriSdk.ordersService.updateOrder(currentOrderId, updateOrderDto);
      await fetchOrders();
    } catch (e) {
      AppHelpersCommon.showBottomSnackBar(
        Get.context!,
        mt.Text(e.toString()),
        const Duration(seconds: 2),
        true,
      );
    }
    isLoadingOrder.value = false;
    currentOrderId = "";
    update();
  }

  Future<void> filterByWaitress(String? selectedWaitressId) async {
    isProductLoading = true;
    update();
    if (selectedWaitressId == null) {
      orders.assignAll(ordersInit);
    } else {
      orders.assignAll(ordersInit
          .where((order) => order.waitressId == selectedWaitressId)
          .toList());
    }
    isProductLoading = false;
    update();
  }

  Future<void> filterByTable(String? selectedTableId) async {
    isProductLoading = true;
    update();
    if (selectedTableId == null) {
      orders.assignAll(ordersInit);
    } else {
      orders.assignAll(ordersInit
          .where((order) => order.tableId == selectedTableId)
          .toList());
    }

    isProductLoading = false;
    update();
  }

  void searchFilter(search) {
    orders.clear();
    update();
    if (search.isEmpty) {
      orders.addAll(ordersInit);
      update();
    } else {
      final nameRecherch = search.toLowerCase();
      orders.addAll(ordersInit.where((item) {
        final String orderNotes = item.orderNotes?.toLowerCase() ?? "";
        final String orderNumber = item.orderNumber.toString().toLowerCase();

        return orderNotes.startsWith(nameRecherch) ||
            orderNumber.startsWith(nameRecherch);
      }).toList());
      update();
    }
  }

  Future<void> fetchOrderById(String idOrder) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        final order = await tajiriSdk.ordersService.getOrder(idOrder);

        updateOrderList(order);
        update();
      } catch (e) {
        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          mt.Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );
      }
    }
  }

  void updateOrderList(Order newOrder) {
    final indexInit = ordersInit.indexWhere((order) => order.id == newOrder.id);
    print("update order list $indexInit");
    if (indexInit != -1) {
      // Replace the old order with the new order in ordersInit
      ordersInit[indexInit] = newOrder;
    } else {
      // Add the new order to ordersInit if it doesn't exist
      ordersInit.insert(0, newOrder);
    }

    orders.assignAll(ordersInit);
  }

  String tableOrWaitressName(Order order) {
    if (order.waitressId != null) {
      return getNameWaitressById(order.waitressId, waitress);
    } else if (order.tableId != null) {
      return getNameTableById(order.waitressId, tableListData);
    } else {
      return "Aucun";
    }
  }

  Future<void> fetchWaitresses() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        isLoadingCreateWaitress = true;
        update();
        final result = await tajiriSdk.waitressesService.getWaitresses();
        waitress.assignAll(result);
        isLoadingCreateWaitress = false;
        update();
      } catch (e) {
        isLoadingCreateWaitress = false;
        update();
      }
    }
  }

  Future<void> fetchTables() async {
    final restaurantId = user?.restaurantId;

    if (restaurantId == null) {
      return;
    }

    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        isLoadingTable = true;
        update();
        final result = await tajiriSdk.tablesService.getTables(restaurantId);
        tableListData.assignAll(result);
        isLoadingTable = false;
        update();
      } catch (e) {
        isLoadingTable = false;
        update();
      }
    }
  }
}
