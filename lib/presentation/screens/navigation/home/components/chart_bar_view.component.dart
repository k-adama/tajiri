import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class ChartBarViewComponent extends StatefulWidget {
  final HomeController homeController;
  const ChartBarViewComponent({super.key, required this.homeController});

  @override
  State<ChartBarViewComponent> createState() => _ChartBarViewComponentState();
}

class _ChartBarViewComponentState extends State<ChartBarViewComponent> {
  List<Color> gradientColors = [
    Style.primaryColor,
    Style.secondaryColor,
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 30,
          left: 30,
          top: 0.2,
          bottom: 25,
        ),
        child: SizedBox(
          width: (size.width - 20),
          height: 160,
          child: Obx(
            () => widget.homeController.isFetching.isFalse &&
                    widget.homeController.orders.isNotEmpty
                ? LineChart(
                    mainData(
                      widget.homeController.orders,
                      widget.homeController.viewSelected.value,
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  LineChartData mainData(List<Order> orders, String viewSelected) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = Style.interNormal(color: Style.white, size: 10);
              return LineTooltipItem(
                  "${touchedSpot.y}".currencyShort(), textStyle);
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            if (spot.x == 0 || spot.x == 6) {
              return null;
            }
            return TouchedSpotIndicatorData(
              const FlLine(
                color: Style.secondaryColor,
                strokeWidth: 4,
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  if (index.isEven) {
                    return FlDotCirclePainter(
                      radius: 8,
                      color: Colors.white,
                      strokeWidth: 5,
                      strokeColor: Style.secondaryColor,
                    );
                  } else {
                    return FlDotSquarePainter(
                      size: 16,
                      color: Colors.white,
                      strokeWidth: 5,
                      strokeColor: Style.secondaryColor,
                    );
                  }
                },
              ),
            );
          }).toList();
        },
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Style.black,
            strokeWidth: 0.6,
            dashArray: [3, 3],
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Style.primaryColor,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Style.secondaryColor),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 0.5,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              return bottomTitleWidgets(value, meta, orders, viewSelected);
            },
          ),
        ),
      ),
      minX: 0,
      maxX: ChartUtils.getMaxItemChart(orders, viewSelected).toDouble(),
      minY: ChartUtils.getMinYChart(orders, viewSelected).toDouble(),
      maxY: ChartUtils.getMaxYChart(orders, viewSelected).toDouble(),
      lineBarsData: ChartUtils.getFlatSpot(orders, viewSelected),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta,
      List<Order> orders, String viewSelected) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: ChartUtils.getTextChart(orders, value, viewSelected),
    );
  }
}
