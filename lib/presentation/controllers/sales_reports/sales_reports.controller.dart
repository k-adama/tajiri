import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'dart:ui' as ui;
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/app/extensions/staff.extension.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class SalesReportController extends GetxController {
  TextEditingController pickStartDate = TextEditingController(
      text: customFormatForRequest.format(DateTime.now()));
  TextEditingController pickEndDate = TextEditingController(
      text: customFormatForRequest.format(DateTime.now()));
  TextEditingController pickStartTime =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
  TextEditingController pickEndTime =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
  RxList<SaleItem> sales = List<SaleItem>.empty().obs;
  final total = 0.obs;
  bool isLoadingReport = false;
  String startDate = "";
  String endDate = "";

  Staff? get user => AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  String? get restaurantId => user?.restaurantId;

  final tajiriSdk = TajiriSDK.instance;

  Future<void> fetchOrdersReports() async {
    startDate = "${pickStartDate.text} ${pickStartTime.text}";
    endDate = "${pickEndDate.text} ${pickEndTime.text}";
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingReport = true;
      update();

      DateTime formattedStartDate = convertToDateTime(startDate);
      DateTime formattedSendDate = convertToDateTime(endDate);
      try {
        final GetOrdersDto dto = GetOrdersDto(
          startDate: formattedStartDate,
          endDate: formattedSendDate,
          ownerId: user.idOwnerForGetOrder,
        );
        SalesReport reportsData = await tajiriSdk.ordersService.getReports(dto);

        List<SaleItem> salesData = reportsData.sales;
        total.value = reportsData.total.toInt();
        sales.assignAll(salesData);

        isLoadingReport = false;
        update();
        Get.toNamed(Routes.SALES_REPORT);
      } catch (e) {
        isLoadingReport = false;
        update();
      }
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

  TextEditingController getTextEditingControllerFormatted(
      TextEditingController controller) {
    return TextEditingController(
      text: convertTofrenchDate(controller.text),
    );
  }

  String getStartDateInFrench() {
    return "${convertTofrenchDate(pickStartDate.text)} ${pickStartTime.text}";
  }

  String getEndDateInFrench() {
    return "${convertTofrenchDate(pickEndDate.text)} ${pickEndTime.text}";
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

  DateTime convertToDateTime(String dateTimeString) {
    List<String> parts = dateTimeString.split(' ');
    if (parts.length < 3) {
      throw const FormatException("Invalid date time format");
    }

    String datePart = parts[0];
    String timePart = parts[2];

    String combinedDateTimeString = "$datePart $timePart:00";

    DateTime dateTime = DateTime.parse(combinedDateTimeString);
    return dateTime;
  }
}
