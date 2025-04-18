import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/data_point_chart.entity.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

enum ListingType {
  table,
  waitress;
}

final customFormatForView = DateFormat('dd-MM-yyyy');
final customFormatForRequest = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');

String convertTofrenchDate(String originalDate) {
  // Parse la date d'entrée
  DateTime parsedDate = customFormatForRequest.parse(originalDate);
  // Formate la date dans le format de sortie
  String formattedDate = customFormatForView.format(parsedDate);

  return formattedDate;
}

ListingType? checkListingType(Staff? user) {
  // ON PREN EN COMPTE LES 2;
  return ListingType.waitress;
}

getInitialName(String fullName) {
  List<String> nameParts = fullName.split(" ");
  String initials = "";

  for (String name in nameParts) {
    if (name.isNotEmpty) {
      initials += name[0];
    }
  }

  return initials.toUpperCase();
}

String getNameFromOrderProduct(OrderProduct? orderProduct) {
  if (orderProduct == null) {
    return 'N/A';
  }

  return orderProduct.variant?.name ?? orderProduct.product.name;
}

String paymentMethodNameByOrder(Order order) {
  final payment = PAIEMENTS.firstWhereOrNull(
    (item) => item['id'] == order.payments[0].paymentMethodId,
  );
  return payment != null ? payment['name'] : "";
}

String? paymentMethodNameById(String? id) {
  final payment = PAIEMENTS.firstWhereOrNull(
    (item) => item['id'] == id,
  );
  return payment?['name'];
}

// sales_calculator.dart
class SalesCalculator {
  static Map<String, Map<String, dynamic>> calculateTotalSalesByDayOfWeek(
      List<Order> orders) {
    Map<String, Map<String, dynamic>> dayOfWeekTotals = {
      "lun": {"grandTotal": 0},
      "mar": {"grandTotal": 0},
      "mer": {"grandTotal": 0},
      "jeu": {"grandTotal": 0},
      "ven": {"grandTotal": 0},
      "sam": {"grandTotal": 0},
      "dim": {"grandTotal": 0},
    };

    List<String> days = ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];

    for (Order order in orders) {
      DateTime createdAtDate = order.createdAt!;
      String dayOfWeek = days[createdAtDate.weekday - 1];

      if (dayOfWeekTotals.containsKey(dayOfWeek)) {
        dayOfWeekTotals[dayOfWeek]!["grandTotal"] += order.grandTotal;
      }
    }

    return dayOfWeekTotals;
  }

  static Map<String, Map<String, dynamic>> calculateClassAndGrandTotalByWeek(
      List<Order> orders) {
    Map<String, Map<String, dynamic>> result = {};

    for (Order order in orders) {
      DateTime createdAt = order.createdAt!;
      String weekNumber = 'Sem ${getWeekNumber(createdAt).toString()}';
      int grandTotal = order.grandTotal;

      if (!result.containsKey(weekNumber)) {
        result[weekNumber] = {"grandTotal": grandTotal};
      } else {
        result[weekNumber]!["grandTotal"] += grandTotal;
      }
    }

    return result;
  }

  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    const millisecondsInWeek = 604800000;
    return ((date.millisecondsSinceEpoch -
                firstDayOfYear.millisecondsSinceEpoch +
                1) /
            millisecondsInWeek)
        .ceil();
  }
}

// chart_utils.dart

class ChartUtils {
  static List<LineChartBarData> getFlatSpot(
      List<Order> orders, String viewSelected) {
    final List<Map<String, dynamic>> ordersForChart =
        getReportChart(orders, viewSelected);
    List<Color> gradientColors = [
      Style.white,
      Style.lightBlue500,
    ];

    final List<DataPointChartEntity> dataPoints = ordersForChart.map((item) {
      int index = ordersForChart.indexOf(item);

      return DataPointChartEntity(
          index.toDouble(), (item["y"] as int).toDouble());
    }).toList();

    final List<FlSpot> flSpots = dataPoints.map((dataPoint) {
      return FlSpot(dataPoint.x, dataPoint.y);
    }).toList();

    List<LineChartBarData> lineChartBarData = [
      LineChartBarData(
        color: Style.lightBlue500,
        isCurved: false,
        spots: flSpots,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ),
    ];
    debugPrint(ordersForChart.toString());
    return lineChartBarData;
  }

  static getReportChart(List<Order> orders, String viewSelected) {
    List<Map<String, dynamic>> ordersForChart;

    if (viewSelected == "Jour") {
      Map<int, Map<String, dynamic>> ordersByHours = orders.fold(
        {},
        (Map<int, Map<String, dynamic>> acc, Order order) {
          DateTime createdAt = order.createdAt!;

          int hour = createdAt.hour;

          acc[hour] = acc[hour] ?? {"count": 0, "grandTotal": 0};
          acc[hour]?["count"]++;
          acc[hour]?["grandTotal"] += order.grandTotal;

          return acc;
        },
      );

      ordersForChart = ordersByHours.entries.map(
        (MapEntry<int, Map<String, dynamic>> entry) {
          int hour = entry.key;
          int grandTotal = entry.value["grandTotal"];
          return {"x": "${hour}:00", "y": grandTotal};
        },
      ).toList();
      ordersForChart.sort((a, b) {
        final int hourA = int.parse(a['x'].split(':')[0]);
        final int hourB = int.parse(b['x'].split(':')[0]);
        return hourA.compareTo(hourB);
      });
    } else {
      Map<String, Map<String, dynamic>> ordersByTime = {
        "x": {"time": "0", "total": 45},
      };
      if (viewSelected == "Semaine") {
        ordersByTime = SalesCalculator.calculateTotalSalesByDayOfWeek(orders);
      } else if (viewSelected == "Mois") {
        ordersByTime =
            SalesCalculator.calculateClassAndGrandTotalByWeek(orders);
        List<String> sortedKeys = ordersByTime.keys.toList()..sort();
        Map<String, Map<String, dynamic>> sortedData = {};
        for (String key in sortedKeys) {
          sortedData[key] = ordersByTime[key]!;
        }

        ordersByTime = sortedData;
      }
      ordersForChart = ordersByTime.entries.map((entry) {
        return {"x": entry.key, "y": entry.value["grandTotal"]};
      }).toList();
    }

    return ordersForChart;
  }

  static getTextChart(List<Order> orders, double value, String viewSelected) {
    final List<Map<String, dynamic>> ordersForChart =
        getReportChart(orders, viewSelected);
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value >= 0 && value < ordersForChart.length) {
      String formattedTime =
          ordersForChart[value.toInt()]['x'].replaceAll(":", "h");
      String splitTime = formattedTime.replaceAll("00", "");
      return Text(splitTime, style: style);
    }
    return const Text("error", style: style);
  }

  static int getMaxItemChart(List<Order> orders, String viewSelected) {
    final List<Map<String, dynamic>> ordersForChart =
        getReportChart(orders, viewSelected);
    return ordersForChart.length - 1;
  }

  static double getMaxYChart(List<Order> orders, String viewSelected) {
    final List<Map<String, dynamic>> ordersForChart =
        getReportChart(orders, viewSelected);
    double maxY = ordersForChart
        .map((entry) => entry['y'].toDouble())
        .reduce((max, current) => max > current ? max : current);

    return maxY + 10.0;
  }

  static double getMinYChart(List<Order> orders, String viewSelected) {
    final List<Map<String, dynamic>> ordersForChart =
        getReportChart(orders, viewSelected);
    double minY = ordersForChart
        .map((entry) => entry['y'].toDouble())
        .reduce((min, current) => min < current ? min : current);

    return minY;
  }
}
