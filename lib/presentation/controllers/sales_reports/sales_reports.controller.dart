import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'dart:ui' as ui;
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/data/repositories/orders/orders.repository.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_reports.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';

class SalesReportController extends GetxController {
  TextEditingController pickStartDate = TextEditingController(
      text: customFormatForRequest.format(DateTime.now()));
  TextEditingController pickEndDate = TextEditingController(
      text: customFormatForRequest.format(DateTime.now()));
  TextEditingController pickStartTime =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
  TextEditingController pickEndTime =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));

  final user = AppHelpersCommon.getUserInLocalStorage();
  final OrdersRepository _ordersRepository = OrdersRepository();
  RxList<SalesDataEntity> sales = List<SalesDataEntity>.empty().obs;
  final PosController posController = Get.find();
  final total = 0.obs;
  bool isLoadingReport = false;
  String startDate = "";
  String endDate = "";

  Future<void> fetchOrdersReports() async {
    String? ownerId =
        user?.role?.permissions![0].dashboardUnique == true ? user?.id : null;
    startDate = "${pickStartDate.text} ${pickStartTime.text}";
    endDate = "${pickEndDate.text} ${pickEndTime.text}";
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingReport = true;
      update();

      final response =
          await _ordersRepository.getOrdersReports(startDate, endDate, ownerId);
      response.when(
        success: (data) async {
          final json = response.data['sales'] as List<dynamic>;
          final salesData =
              json.map((item) => SalesDataEntity.fromJson(item)).toList();

          total.value = response.data['total'];

          for (int i = 0; i < salesData.length; i++) {
            final currentSalesData = salesData.toList()[i];
            final productData = posController.bundlePacks.firstWhere(
                (item) => item['id'] == currentSalesData.id,
                orElse: () => null);
            if (productData != null) {
              if (currentSalesData.productQtyStart == null) {
                int productPrice = productData?['price'];
                int productPriceTotal =
                    (currentSalesData.productQtySales ?? 0) *
                        (productPrice ?? 0);
                salesData[i] = currentSalesData.copyWith(
                    productQtyStart: 0, productPriceTotal: productPriceTotal);
              }
            } else {}
          }

          sales.assignAll(salesData);
          isLoadingReport = false;
          update();
          Get.toNamed(Routes.SALES_REPORT);
        },
        failure: (failure, status) {
          isLoadingReport = false;
          update();
        },
      );
    }
  }

  pickDate(BuildContext context) async {
    Locale myLocale = const Locale('fr', 'FR');
    DateTime? pickedDate = await showRoundedDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2100),
        locale: myLocale,
        theme: ThemeData(
          primaryColor: Style.secondaryColor,
          primaryTextTheme: const TextTheme(
            displayMedium: TextStyle(color: Style.black),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Style.white),
          ),
          colorScheme: const ColorScheme.light(primary: Style.secondaryColor),
          buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.accent),
        ),
        styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleDayButton:
              const TextStyle(fontSize: 16, color: Colors.white),
          textStyleYearButton: const TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
          textStyleDayHeader: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ));

    return pickedDate;
  }

  pickTime(BuildContext context) async {
    TimeOfDay? picked = await showRoundedTimePicker(
      context: context,
      theme: ThemeData(
        primaryColor: Style.secondaryColor,
        colorScheme: const ColorScheme.light(primary: Style.secondaryColor),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.accent),
      ),
      initialTime: TimeOfDay.now(),
      locale: const Locale("fr", "FR"),
    );
    if (picked == null) return null;
    return picked;
  }

  pickDateFormatted(DateTime? pickedDate) {
    if (pickedDate != null) {
      debugPrint('$pickedDate');
      String formattedDate = customFormatForRequest.format(pickedDate);
      debugPrint(formattedDate);

      return formattedDate;
    } else {
      debugPrint("pickedDate is null");
    }
  }

  pickTimeFormatted(TimeOfDay? timeOfDay) {
    if (timeOfDay != null) {
      DateTime now = DateTime.now();
      DateTime date = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      String formattedTime = DateFormat('HH:mm').format(date);
      debugPrint(formattedTime);

      return formattedTime;
    } else {}
  }

  double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    if (text.length <= 2) return textPainter.width + 100;
    if (text.length <= 6) return textPainter.width + 80;
    return textPainter.width + 70;
  }
}
