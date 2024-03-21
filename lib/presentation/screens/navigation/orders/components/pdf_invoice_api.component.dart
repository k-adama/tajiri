import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/app/services/pdf_api.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';

class PdfInvoiceApiComponent {
  static final dynamic user = LocalStorageService.instance.get(UserConstant.keyUser);

  static Future<File> generate(OrderEntity ordersData) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
          build: (context) => [
                buildAppBar(user, ordersData),
                SizedBox(height: 29),
                buildHeader(ordersData),
                SizedBox(height: 15),
                buildInvoice(ordersData),
                SizedBox(height: 15),
                subTotalAndReduction(ordersData),
                buildTotal(ordersData)
              ]),
    );
    // TODO : make a function to generate name with date or ...
    return PdfApi.saveDocument(name: 'facture.pdf', pdf: pdf);
  }

  static Widget buildAppBar(dynamic user, OrderEntity ordersData) => Container(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            "${user?['restaurantUser'] != null ? user?['restaurantUser'][0]['restaurant']?['name'] : ""}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        Text(
            "${user?['restaurantUser'] != null ? user?['restaurantUser'][0]?['restaurant']?['contactPhone'] : ""}",
            style: TextStyle(fontSize: 13))
      ]));

  static Widget buildHeader(OrderEntity ordersData) => Container(
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
                                DateTime.tryParse(ordersData.createdAt ?? "")
                                        ?.toLocal() ??
                                    DateTime.now())),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "N°${ordersData.orderNumber.toString() ?? ""}",
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
                          "${user['firstname']} ${user['lastname']}",
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        information(
                          "Client:",
                          ordersData.customerType == "SAVED"
                              ? "${ordersData.customer?.lastname ?? ""} ${ordersData.customer?.firstname ?? ""}"
                              : "Client de passe",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  static Widget buildInvoice(OrderEntity ordersData) {
    final headers = [
      'PRODUIT',
      'QUANTITÉ',
      'UNITÉ',
      'TOTAL',
    ];

    final data = ordersData.orderDetails?.map((item) {
      int calculate = (item.price ?? 0) * (item.quantity ?? 0);
      final food = item.food == null ? item.bundle['name'] : item.food?.name;
      print(food);
      return [food, '${item.quantity ?? 0}', '${item.price ?? 0}', calculate];
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

  static Widget subTotalAndReduction(OrderEntity ordersData) {
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
                  totalCommand("Sous-Total", ordersData.subTotal ?? 0, false),
                  totalCommand("Réduction", 0, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTotal(OrderEntity ordersData) {
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
