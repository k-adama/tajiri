import 'package:flutter/material.dart' as material;
import 'package:get/get_instance/get_instance.dart';
import 'package:flutter/material.dart' as mt;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_pos_mobile/app/extensions/staff.extension.dart';

class OrdersController extends GetxController {
  bool isProductLoading = true;
  bool isLoadingCreateWaitress = false;
  bool isLoadingTable = false;
  bool isExpanded = false;
  bool isAddAndRemoveLoading = false;
  DateTime? startRangeDate;
  DateTime? endRangeDate;
  List<Order> orders = List<Order>.empty().obs;
  List<Order> ordersInit = List<Order>.empty().obs;
  Rx<bool> isLoadingOrder = false.obs;
  RxString currentOrderId = "".obs;
  double? amount;

  RxList<Table> tableListData = List<Table>.empty().obs;
  final waitress = List<Waitress>.empty().obs;
  final customers = List<Customer>.empty().obs;

  RxString currentOrderNo = "".obs;
  DateTime dateTime = DateTime.now();

  final user = AppHelpersCommon.getUserInLocalStorage();
  String? get restaurantId => user?.restaurantId;

  bool monuted = false;
  final posController = Get.find<PosController>();

  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() {
    streamOrdersChange();
    Future.wait([
      fetchOrders(),
      fetchWaitresses(),
      fetchTables(),
      fetchCustomers(),
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
                value: restaurantId ?? ""),
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

  Future<void> updateOrder(
      material.BuildContext context, String paymentMethodId) async {
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

  Future<void> updateOrderStatus(material.BuildContext context,
      String currentOrderId, String status) async {
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

  String tableOrWaitressName(Order order) {
    if (order.waitressId != null) {
      return getNameWaitressById(order.waitressId, waitress);
    } else if (order.tableId != null) {
      return getNameTableById(order.tableId, tableListData);
    } else {
      return "";
    }
  }

  String customerName(Order order) {
    return order.customerType == "SAVED"
        ? getNameCustomerById(order.customerId, customers)
        : "Client de passage";
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
    if (indexInit != -1) {
      // Replace the old order with the new order in ordersInit
      ordersInit[indexInit] = newOrder;
    } else {
      // Add the new order to ordersInit if it doesn't exist
      ordersInit.insert(0, newOrder);
    }
    orders.assignAll(ordersInit);
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
    if (restaurantId == null) {
      return;
    }

    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        isLoadingTable = true;
        update();
        final result = await tajiriSdk.tablesService.getTables(restaurantId!);
        tableListData.assignAll(result);
        isLoadingTable = false;
        update();
      } catch (e) {
        isLoadingTable = false;
        update();
      }
    }
  }

  Future<void> fetchCustomers() async {
    if (restaurantId == null) {
      print("===restaurantId null");
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      update();
      final result =
          await tajiriSdk.customersService.getCustomers(restaurantId!);
      customers.assignAll(result);
      customers.assignAll(result);
      update();
    }
  }

  double getTextWidth(String text, material.TextStyle style) {
    final material.TextPainter textPainter = material.TextPainter(
      text: material.TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection:
          ui.TextDirection.ltr, // Use TextDirection.ltr for left-to-right text
    )..layout(minWidth: 0, maxWidth: double.infinity);
    if (text.length <= 6) return textPainter.width + 20;
    if (text.length > 6 && text.length <= 10) return textPainter.width + 25;
    return textPainter.width + 80;
  }

  getPayment(Order order) {
    final payment = PAIEMENTS.firstWhere(
      (item) => item['id'] == order.payments[0].paymentMethodId,
      orElse: () => <String,
          String>{}, // Provide an empty Map<String, String> as the default value
    );

    return payment;
  }
}
