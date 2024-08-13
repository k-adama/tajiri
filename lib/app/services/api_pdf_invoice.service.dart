import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf.service.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class ApiPdfInvoiceService {
  static Future<File> generate(
    Order order,
    String customerName,
    String waitressName,
  ) async {
    final pdf = Document();
    final user = AppHelpersCommon.getUserInLocalStorage();

    pdf.addPage(
      MultiPage(
          build: (context) => [
                buildAppBar(user),
                SizedBox(height: 29),
                buildHeader(order, customerName, waitressName),
                SizedBox(height: 15),
                buildInvoice(order),
                SizedBox(height: 15),
                subTotalAndReduction(order),
                buildTotal(order)
              ]),
    );
    return ApiPdfService.saveDocument(name: 'facture.pdf', pdf: pdf);
  }

  static Widget buildAppBar(Staff? user) {
    final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${restaurant?.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          Text("${restaurant?.phone}", style: const TextStyle(fontSize: 13))
        ],
      ),
    );
  }

  static Widget buildHeader(
    Order order,
    String customerName,
    String waitressName,
  ) =>
      Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        information(
                            "Date",
                            DateFormat("MM/dd/yy HH:mm").format(
                                order.createdAt?.toLocal() ?? DateTime.now())),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "N°${order.orderNumber.toString()}",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        information(
                          "Serveur:",
                          waitressName,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        information("Client:", customerName),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  static Widget buildInvoice(Order ordersData) {
    final headers = [
      'PRODUIT',
      'QUANTITÉ',
      'UNITÉ',
      'TOTAL',
    ];

    final data = ordersData.orderProducts.map((item) {
      int calculate = (item.price) * (item.quantity);
      final productName = getNameFromOrderProduct(item);
      print(productName);
      return [productName, '${item.quantity}', '${item.price}', calculate];
    }).toList();

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

  static Widget subTotalAndReduction(Order ordersData) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 350,
              child: Column(
                children: [
                  Divider(),
                  totalCommand("Sous-Total", ordersData.subTotal, false),
                  totalCommand("Réduction", 0, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTotal(Order ordersData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TOTAL",
            ),
            Text(
              "${ordersData.grandTotal}".currencyLong(),
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
            Text("$price".currencyLong(),
                style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ],
    );
  }

  static Widget information(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          body,
        )
      ],
    );
  }

  static Widget orderDetailStringContent(String text, bool isBool) {
    return Text(
      text,
      style: isBool
          ? Style.interBold(
              size: 12,
            )
          : Style.interNormal(
              size: 12,
            ),
    );
  }

  static Widget orderDetailNumberContent(int value) {
    return Text(
      "$value".currencyLong(),
      style: Style.interNormal(
        size: 10,
      ),
    );
  }
}
