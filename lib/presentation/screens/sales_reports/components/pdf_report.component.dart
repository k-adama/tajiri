import 'package:get/instance_manager.dart';
import 'package:pdf/widgets.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf.service.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sales_reports/sales_reports.controller.dart';
import 'dart:io';
import 'package:tajiri_sdk/src/models/sales-report.model.dart';
import 'package:tajiri_sdk/src/models/staff.model.dart';
import 'package:tajiri_sdk/src/models/restaurant.model.dart';

class PdfReportComponent {
  static final user = AppHelpersCommon.getUserInLocalStorage();
  static final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  static SalesReportController salesReportsController = Get.find();
  static Future<File> generate(List<SaleItem> salesData, int total,
      String startDate, String endDate) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
          build: (context) => [
                buildAppBar(user, restaurant),
                SizedBox(height: 29),
                buildHeader(salesReportsController.getStartDateInFrench(),
                    salesReportsController.getEndDateInFrench(), user),
                SizedBox(height: 15),
                buildInvoice(salesData),
                SizedBox(height: 15),
                buildTotal(total)
              ]),
    );
    return ApiPdfService.saveDocument(name: 'my_order_report.pdf', pdf: pdf);
  }

  static Widget buildAppBar(Staff? user, Restaurant? restaurant) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            Text(
              "${restaurant?.name}",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              "${user?.phone}",
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  static Widget buildHeader(String startDate, String endDate, Staff? user) =>
      Container(
        width: double.infinity,
        child: Center(
            child: Column(
          children: [
            information("Date de début: ", startDate),
            information("Date de fin: ", endDate),
            information("Personne : ", "${user?.firstname} ${user?.lastname}"),
          ],
        )),
      );

  static Widget buildInvoice(List<SaleItem> salesData) {
    final headers = [
      'DÉSI',
      'INITIAL',
      'ENTRÉE',
      'SORTIE',
      'TOTAL',
    ];

    final data = salesData.map((item) {
      return [
        item.itemName,
        item.productQtyStart ?? 0,
        item.productQtySupply ?? 0,
        item.qty,
        item.totalAmount,
      ];
    }).toList();

    if (data == null) {
      return Container();
    } else {
      return TableHelper.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
          5: Alignment.centerRight,
        },
      );
    }
  }

  static Widget buildTotal(int total) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  totalCommand("Total", total ?? 0, true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget totalCommand(String name, int price, bool isBold) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text("$price".currencyShort(),
                style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
        Divider(),
      ],
    );
  }

  static Widget information(String title, String body) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
          body,
        )
      ],
    );
  }
}
