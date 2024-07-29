import 'package:flutter/material.dart' as material;
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_reports.entity.dart';
import 'package:tajiri_pos_mobile/data/repositories/orders/orders.repository.dart';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class OrdersController extends GetxController {
  final OrdersRepository _ordersRepository = OrdersRepository();
  bool isProductLoading = true;
  bool isExpanded = false;
  bool isAddAndRemoveLoading = false;
  List<Order> orders = List<Order>.empty().obs;
  List<Order> ordersInit = List<Order>.empty().obs;

  List<Order> ordersPending = List<Order>.empty().obs;
  List<Order> ordersPaid = List<Order>.empty().obs;

  List<OrdersReportsEntity> ordersReports =
      List<OrdersReportsEntity>.empty().obs;
  Rx<bool> isLoadingOrder = false.obs;
  RxString currentOrderId = "".obs;
  RxString currentOrderNo = "".obs;

  DateTime? startRangeDate;
  DateTime? endRangeDate;

  DateTime dateTime = DateTime.now();
  final user = AppHelpersCommon.getUserInLocalStorage();
  bool monuted = false;

  final posController = Get.find<PosController>();

  final waitress = List<Waitress>.empty().obs;
  RxList<Table> tableListData = List<Table>.empty().obs;
  final tajiriSdk = TajiriSDK.instance;

  bool isLoadingCreateWaitress = false;
  bool isLoadingTable = false;

  @override
  void onInit() {
    super.onInit();
  }

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
    final channel = supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        // .eq('restaurantId', user?.role?.restaurantId ?? "")
        .order('createdAt')
        .limit(1);
    channel.listen((eventList) async {
      if (monuted) {
        if (eventList[0]['status'] == AppConstants.orderNew) {
          final player = AudioPlayer();
          await player.play(
              UrlSource(
                  'https://xuyfavsmxnbbaefzkdam.supabase.co/storage/v1/object/public/tajiri-foods/core/mixkit-arabian-mystery-harp-notification-2489.wav'),
              mode: PlayerMode.mediaPlayer);
        }
        fetchOrders();
      }
      monuted = true;
      update();
    });
  }

  setRangeDate(DateTime startDate, DateTime endDate) {
    startRangeDate = startDate;
    endRangeDate = endDate;
    update();
  }

  Future<void> fetchOrders() async {
    final DateTime today = DateTime.now();
    final DateTime sevenDaysAgo = today.subtract(const Duration(days: 2));
    String startDate =
        DateFormat("yyyy-MM-dd").format(startRangeDate ?? sevenDaysAgo);
    String endDate = DateFormat("yyyy-MM-dd").format(endRangeDate ?? today);
    /* String? ownerId = (user?.role?.permissions![0].dashboardUnique ?? false)
        ? user?.id
        : null;*/
    final connected = await AppConnectivityService.connectivity();

    if (connected) {
      isProductLoading = true;
      update();
      /*  final response =
          await _ordersRepository.getOrders(startDate, endDate, ownerId);
      response.when(
        success: (data) async {
          final json = data as List<dynamic>;
          final orderData =
              json.map((item) => OrderEntity.fromJson(item)).toList();

          ordersInit.assignAll(orderData);
          if (checkListingType(user) == ListingType.waitress) {
            filterByWaitress(posController.waitressCurrentId);
          } else if (checkListingType(user) == ListingType.table) {
            filterByTable(posController.tableCurrentId);
          } else {
            orders.assignAll(orderData);
          }

          isProductLoading = false;
          update();
        },
        failure: (failure, status) {},
      );*/
    }
  }

  Future<void> fetchOrdersReports(
      String startDate, String endDate, String ownerId) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();

      final response =
          await _ordersRepository.getOrdersReports(startDate, endDate, ownerId);
      response.when(
        success: (data) async {
          final json = response as List<dynamic>;
          final orderData =
              json.map((item) => OrdersReportsEntity.fromJson(item)).toList();
          ordersReports.assignAll(orderData);
          isProductLoading = false;
          update();
        },
        failure: (failure, status) {},
      );
    }
  }

  bool isToday(DateTime orderDate) {
    DateTime today = DateTime.now();
    return orderDate.day == today.day &&
        orderDate.month == today.month &&
        orderDate.year == today.year;
  }

  bool isYesterday(DateTime orderDate) {
    DateTime today = DateTime.now();
    DateTime yesterday = DateTime(today.year, today.month, today.day - 1);
    return orderDate.day == yesterday.day &&
        orderDate.month == yesterday.month &&
        orderDate.year == yesterday.year;
  }

  List<Order> getOrdersByDate(String date, List<Order> orders) {
    return orders.where((order) {
      DateTime orderDate = order.createdAt!;
      if (date == "Aujourd'hui") {
        return isToday(orderDate);
      } else if (date == "Hier") {
        return isYesterday(orderDate);
      }
      return !isYesterday(orderDate) && !isToday(orderDate);
    }).toList();
  }

  getPayment(Order order) {
    final payment = PAIEMENTS.firstWhere(
      (item) => item['id'] == order.payments[0].paymentMethodId,
      orElse: () => <String,
          String>{}, // Provide an empty Map<String, String> as the default value
    );

    return payment;
  }

  Future<void> updateOrder(
      material.BuildContext context, String paymentMethodId) async {
    if (currentOrderId.isEmpty) return;
    isLoadingOrder.value = true;
    update();
    final Map<String, dynamic> params = {
      'status': "PAID",
      'paymentMethodId': paymentMethodId
    };

    final response =
        await _ordersRepository.updateOrder(params, currentOrderId.value);

    /* response.when(success: (data) {
      Mixpanel.instance.track("Order PAID", properties: {
        'user': '${user?.lastname ?? ""} ${user?.firstname ?? ""}',
        'restaurant': user!.restaurantUser![0].restaurant?.name ?? "",
        'orderNo': currentOrderNo.value
      });

      isLoadingOrder.value = false;
      currentOrderId.value = "";
      currentOrderNo.value = "";
      update();

      Get.back();
    }, failure: (failure, status) {
      AppHelpersCommon.showCheckTopSnackBar(
        context,
        status.toString(),
      );
      isLoadingOrder.value = false;
      currentOrderId.value = "";
      update();
    });*/
  }

  Future<void> updateOrderStatus(material.BuildContext context,
      String currentOrderId, String status) async {
    if (currentOrderId.isEmpty) return;
    isLoadingOrder.value = true;
    final response =
        await _ordersRepository.updateOrder({'status': status}, currentOrderId);

    response.when(success: (data) {
      isLoadingOrder.value = false;
      update();
      fetchOrders();
    }, failure: (failure, status) {
      AppHelpersCommon.showCheckTopSnackBar(
        context,
        status.toString(),
      );
      isLoadingOrder.value = false;
      currentOrderId = "";
      update();
    });
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
