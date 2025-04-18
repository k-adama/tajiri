import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/extensions/staff.extension.dart';
import 'dart:ui' as ui;
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/categorie_amount.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/top_10_food.entity.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class HomeController extends GetxController {
  final user = AppHelpersCommon.getUserInLocalStorage();
  bool isScrolling = false;

  int selectIndex = 0;

  List<String> tabs = ['Jour', 'Semaine', 'Mois'].obs;
  RxList<Top10FoodEntity> top10Foods = List<Top10FoodEntity>.empty().obs;
  RxString viewSelected = "Jour".obs;
  RxString selectedWeek = "current".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<int> selectedMonth = 5.obs;
  RxString comparisonDate = "".obs;
  DateTime startDate = DateTime.now().obs.value;
  DateTime endDate = DateTime.now().obs.value;
  List<dynamic> weekDates = [];
  RxList<CategoryAmountEntity> categoriesAmount =
      List<CategoryAmountEntity>.empty().obs;
  Rx<int> ordersPaid = 0.obs;
  Rx<int> ordersSave = 0.obs;

  Rx<bool> isFetching = true.obs;
  Rx<int> totalAmount = 0.obs;
  RxString dayActiveText = "Aujourd'hui".obs;
  Rx<double> percentComparaison = 0.0.obs;
  String? storyGroup;

  RxList<Order> orders = List<Order>.empty().obs;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onInit() {
    super.onInit();
    getWeekDates();
    fetchDataForReports();
  }

  void getDayActive() {
    if (viewSelected.value == 'Semaine') {
      if (selectedWeek.value == "current") {
        dayActiveText.value = "Cette semaine";
      }
      if (selectedWeek.value == "last") {
        dayActiveText.value = "Semaine passée";
      }
      if (selectedWeek.value == "sur_last") {
        dayActiveText.value = "Sem. surpassée";
      }
    } else if (viewSelected.value == 'Mois') {
      if (selectedMonth.value == 5) {
        dayActiveText.value = "Ce mois";
      } else {
        dayActiveText.value = getLastMonths()[selectedMonth.value];
      }
    } else if (viewSelected.value == 'Jour') {
      if (isSameDay(selectedDate.value, DateTime.now())) {
        dayActiveText.value = "Aujourd'hui";
      } else {
        dayActiveText.value = weekdays[selectedDate.value.weekday];
      }
    } else {
      dayActiveText.value = "";
    }
    update();
  }

  fetchDataForReports({int? indexFilter}) async {
    final params = getDatesForComparison();

    DateTime startDateComparaison = params['startDate']!;
    DateTime endDateComparaison = params['endDate']!;
    String? ownerId = user?.idOwnerForGetOrder;
    final GetOrdersDto dto = GetOrdersDto(
        startDate: startDateComparaison,
        endDate: endDateComparaison,
        ownerId: ownerId);
    final GetOrdersDto dtoStart =
        GetOrdersDto(startDate: startDate, endDate: endDate, ownerId: ownerId);
    try {
      final [ordersResponse, comparaisonOders] = await Future.wait([
        tajiriSdk.ordersService.getOrders(dtoStart),
        tajiriSdk.ordersService.getOrders(dto),
      ]);

      var ordersData = ordersResponse;
      // Supprime les commandes annulees
      final newOrderData =
          ordersData.where((item) => item.status != 'CANCELLED').toList();
      totalAmount.value = getTotalAmount(newOrderData);
      ordersPaid.value = getTotalAmount(
          newOrderData.where((item) => item.status == 'PAID').toList());
      ordersSave.value = getTotalAmount(
          newOrderData.where((item) => item.status == "NEW").toList());
      final groupByCategoriesValue = groupByCategories(newOrderData);
      final ordersForCategoriesValue =
          ordersForCategories(groupByCategoriesValue);
      categoriesAmount.assignAll(ordersForCategoriesValue);
      final top10FoodsValue = getTop10Foods(ordersData);
      top10Foods.assignAll(top10FoodsValue);
      getDayActive();
      final int ordersComparaisonsAmount = getTotalAmount(comparaisonOders);
      percentComparaison.value =
          ((totalAmount.value - ordersComparaisonsAmount) /
                  ordersComparaisonsAmount) *
              100;

      isFetching.value = false;
      update();
      orders.assignAll(ordersData);
    } catch (e) {
      eventFilter(indexFilter: indexFilter ?? 0, status: "Failure");
      isFetching.value = false;
      update();
    }
    isFetching.value = false;
    update();
  }

  Map<String, DateTime> getFirstAndLastDayOfMonth(int monthIndex) {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    DateTime firstDay = DateTime(currentYear, monthIndex + 1, 1);
    DateTime lastDay = DateTime(currentYear, monthIndex + 2, 0);

    return {"start": firstDay, "end": lastDay};
  }

  List<String> getLastMonths() {
    DateTime now = DateTime.now();
    int currentMonth = now.month;

    List<String> lastMonths = [];

    for (int i = 6; i > 0; i--) {
      int prevMonthIndex = (currentMonth + 12 - i) % 12;
      lastMonths.add(monthNames[prevMonthIndex]);
    }

    return lastMonths;
  }

  bool isSelectedDate(DateTime date) {
    return isSameDate(selectedDate.value, date);
  }

  bool isSameDate(DateTime a, DateTime b) {
    return _removeTime(a).compareTo(_removeTime(b)) == 0;
  }

  DateTime _removeTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  formatDate(DateTime date) {
    String dateFormat;
    var formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss', 'fr_FR');
    dateFormat = formatter.format(date);
    return dateFormat;
  }

  void updateDatesByWeekly(String selectedWeek) {
    if (selectedWeek == "current") {
      final Map<String, DateTime> currentWeekDates = getCurrentWeekDates();
      final DateTime start = currentWeekDates['start']!;
      final DateTime end = currentWeekDates['end']!;
      startDate = start;
      endDate = end;
    } else if (selectedWeek == "last") {
      final Map<String, DateTime> lastWeekDates = getLastWeekDates();
      final DateTime start = lastWeekDates['start']!;
      final DateTime end = lastWeekDates['end']!;
      startDate = start;
      endDate = end;
    } else if (selectedWeek == "sur_last") {
      final Map<String, DateTime> beforeLastWeekDates =
          getBeforeLastWeekDates();
      final DateTime start = beforeLastWeekDates['start']!;
      final DateTime end = beforeLastWeekDates['end']!;
      startDate = start;
      endDate = end;
    }

    update();
  }

  Map<String, DateTime> getLastWeekDates() {
    DateTime currentDate = DateTime.now();
    int dayOfWeek = currentDate.weekday;

    DateTime startOfWeek = currentDate
        .subtract(Duration(days: dayOfWeek + 7 - (dayOfWeek == 7 ? 0 : 1)));
    DateTime endOfWeek = currentDate
        .subtract(Duration(days: dayOfWeek + 1 - (dayOfWeek == 7 ? 0 : 1)));

    return {"start": startOfWeek, "end": endOfWeek};
  }

  Map<String, DateTime> getCurrentWeekDates() {
    DateTime currentDate = DateTime.now();
    int dayOfWeek = currentDate.weekday;

    DateTime startOfWeek = currentDate.subtract(Duration(days: dayOfWeek - 1));
    DateTime endOfWeek = currentDate.add(Duration(days: 7 - dayOfWeek));

    return {"start": startOfWeek, "end": endOfWeek};
  }

  Map<String, DateTime> getBeforeLastWeekDates() {
    DateTime currentDate = DateTime.now();
    int dayOfWeek = currentDate.weekday;

    DateTime startOfWeek = currentDate
        .subtract(Duration(days: dayOfWeek + 13 - (dayOfWeek == 7 ? 0 : 1)));
    DateTime endOfWeek = currentDate
        .subtract(Duration(days: dayOfWeek + 7 - (dayOfWeek == 7 ? 0 : 1)));

    return {"start": startOfWeek, "end": endOfWeek};
  }

  int getCurrentMonth() {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    return currentMonth - 1;
  }

  void getWeekDates() {
    DateTime currentDate = DateTime.now();

    DateTime? startOfWeek = getCurrentWeekDates()['start'];
    DateTime? endOfWeek = getCurrentWeekDates()['end'];

    debugPrint(startOfWeek?.toIso8601String());

    startOfWeek ??= currentDate;
    endOfWeek ??= currentDate;

    for (int i = 0; i < 7; i++) {
      DateTime date = startOfWeek.add(Duration(days: i));
      if (isSameDate(currentDate, date)) {
        selectedDate.value = date;
        update();
      }
      weekDates.add(date);
      update();
    }
  }

  Map<String, DateTime> getDatesForComparison() {
    DateTime now = DateTime.now();
    Map<String, DateTime> params = {
      "startDate": now,
      "endDate": now,
    };

    if (viewSelected.value == 'Semaine') {
      if (selectedWeek.value == "current") {
        Map<String, DateTime> lastWeekDates = getLastWeekDates();
        params["startDate"] = lastWeekDates["start"]!;
        params["endDate"] = lastWeekDates["end"]!;
        comparisonDate.value = "Semaine passée";
      } else if (selectedWeek.value == "last") {
        Map<String, DateTime> beforeLastWeekDates = getBeforeLastWeekDates();
        params["startDate"] = beforeLastWeekDates["start"]!;
        params["endDate"] = beforeLastWeekDates["end"]!;
        comparisonDate.value = "Semaine surpassée";
      } else if (selectedWeek.value == "sur_last") {
        Map<String, DateTime> beforeBeforeLastWeekDates =
            getBeforeBeforeLastWeekDates();
        params["startDate"] = beforeBeforeLastWeekDates["start"]!;
        params["endDate"] = beforeBeforeLastWeekDates["end"]!;
        comparisonDate.value = "Semaine avant";
      }
    } else if (viewSelected.value == "Mois") {
      if (selectedMonth.value - 1 < 0) {
        String firstItem = getLastMonths()[0];
        int monthIndex = monthNames.indexOf(firstItem);
        if (monthIndex == 0) {
          Map<String, DateTime> firstMonthDates =
              getFirstAndLastDayOfMonth(monthIndex);
          comparisonDate.value = monthNames[monthIndex];
          params["startDate"] = firstMonthDates["start"]!;
          params["endDate"] = firstMonthDates["end"]!;
        } else {
          Map<String, DateTime> prevMonthDates =
              getFirstAndLastDayOfMonth(monthIndex - 1);
          params["startDate"] = prevMonthDates["start"]!;
          params["endDate"] = prevMonthDates["end"]!;
          comparisonDate.value = monthNames[monthIndex - 1];
        }
      } else {
        String item = getLastMonths()[selectedMonth.toInt() - 1];
        comparisonDate.value = item;
        int monthIndex = monthNames.indexOf(item);
        Map<String, DateTime> selectedMonthDates =
            getFirstAndLastDayOfMonth(monthIndex);
        params["startDate"] = selectedMonthDates["start"]!;
        params["endDate"] = selectedMonthDates["end"]!;
      }
    } else if (viewSelected.value == "Jour") {
      DateTime newDate = DateTime.parse(selectedDate.value.toIso8601String());

      newDate = newDate.subtract(const Duration(days: 7));

      params["startDate"] = newDate;
      params["endDate"] = newDate;

      debugPrint(weekdays[newDate.weekday - 1]);
      comparisonDate.value = "${weekdays[newDate.weekday - 1]} ${newDate.day}";
    }

    return params;
  }

  Map<String, DateTime> getBeforeBeforeLastWeekDates() {
    DateTime currentDate = DateTime.now();
    int dayOfWeek = currentDate.weekday;

    DateTime startOfWeek = currentDate
        .subtract(Duration(days: dayOfWeek + 20 - (dayOfWeek == 7 ? 0 : 1)));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 36));

    return {"start": startOfWeek, "end": endOfWeek};
  }

  List<Top10FoodEntity> getTop10Foods(List<Order> data) {
    Map<String, Map<String, dynamic>> groupedByFoods = {};

    for (var item in data) {
      for (var product in item.orderProducts) {
        String foodSelected = product.productId;

        if (!groupedByFoods.containsKey(foodSelected)) {
          String name = product.product.name;
          groupedByFoods[foodSelected] = {
            'name': name,
            'quantity': product.quantity,
          };
        } else {
          groupedByFoods[foodSelected]?['quantity'] += product.quantity;
        }
      }
    }

    List<Top10FoodEntity> foodsData = groupedByFoods.values.map((food) {
      return Top10FoodEntity.fromJson({
        'name': food['name'] ?? 'Unknown',
        'total': food['quantity'] ?? 0,
      });
    }).toList();

    foodsData.sort((a, b) => b.total - a.total);
    if (foodsData.length <= 10) {
      return foodsData;
    } else {
      return foodsData.sublist(0, 10);
    }
  }

  List<CategoryAmountEntity> ordersForCategories(
      Map<String, dynamic> groupByCategories) {
    return groupByCategories.entries.map((MapEntry<String, dynamic> entry) {
      String categoryId = entry.key;
      Map<String, dynamic> categoryData = entry.value;

      return CategoryAmountEntity.fromJson({
        'name': categoryId,
        'total': categoryData['total'],
        'icon': categoryData['icon'],
      });
    }).toList();
  }

  Map<String, dynamic> groupByCategories(List<Order> data) {
    Map<String, dynamic> acc = {};

    for (var order in data) {
      for (var orderProduct in order.orderProducts) {
        String categoryId = orderProduct.product.category.name;
        String categoryIcon = orderProduct.product.category.imageUrl;

        Map<String, dynamic> category = acc[categoryId] ??
            {
              'count': 0,
              'total': 0,
              'icon': categoryIcon,
            };

        category['count'] += 1;
        category['total'] += orderProduct.price * orderProduct.quantity;
        acc[categoryId] = category;
      }
    }

    return acc;
  }

  int getTotalAmount(List<Order> orders) {
    return orders.fold(
        0, (count, item) => count + (item.grandTotal as num).toInt());
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int checkPercentValue(double value) {
    if (value > 0) {
      return 2;
    } else if (value < 0) {
      return 1;
    } else {
      return 0;
    }
  }

  double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection:
          ui.TextDirection.ltr, // Use TextDirection.ltr for left-to-right text
    )..layout(minWidth: 0, maxWidth: double.infinity);
    if (text.length <= 6) return textPainter.width + 92;
    return textPainter.width + 80;
  }

  int calculateTotalAmountByPaymentMenthode(String paymentMethodId) {
    int totalAmount = 0;
    for (var order in orders) {
      for (var payment in order.payments) {
        if (payment.paymentMethodId == paymentMethodId) {
          totalAmount += payment.amount;
        }
      }
    }
    return totalAmount;
  }

  void eventFilter({int indexFilter = 0, required String status}) {
    switch (indexFilter) {
      case 0:
        Mixpanel.instance.track('Dashboard Reports filter',
            properties: {"Periode used": "Day", "Status": status});
        break;
      case 1:
        Mixpanel.instance.track('Dashboard Reports filter',
            properties: {"Periode used": "Week", "Status": status});
        break;
      default:
        Mixpanel.instance.track('Dashboard Reports filter',
            properties: {"Periode used": "Month", "Status": status});
    }
  }
}
