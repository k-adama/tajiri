import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_details.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/order_invoice_button.component.dart';

class OrderInvoicePdfComponent extends StatefulWidget {
  const OrderInvoicePdfComponent({super.key});

  @override
  State<OrderInvoicePdfComponent> createState() => _OrderInvoicePdfComponentState();
}

class _OrderInvoicePdfComponentState extends State<OrderInvoicePdfComponent> {
  final OrderEntity arguments = Get.arguments;
  final UserEntity? user = AppHelpersCommon.getUserInLocalStorage();
  //final PosController posController = Get.find();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  List<BluetoothDevice> _selectedPrinter = [];
  BluetoothDevice? _device;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.lighter,
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Style.black),
            elevation: 0,
            backgroundColor: Style.white,
            leading: BackButton(
              onPressed: () {
                /*if (posController.isPaid.value) {
                  Get.offAllNamed(Routes.MAIN, arguments: {"selectIndex": 0});
                } else {
                  Get.back();
                }
                posController.isPaid.value = false;*/
              },
            )),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Style.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            arguments.status == "PAID"
                                ? "Reçu de paiement"
                                : "Facture",
                            style: Style.interBold(
                                color: Style.titleDark, size: 24),
                          ),
                          20.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              information(
                                  context,
                                  "Date",
                                  DateFormat("MM/dd/yy HH:mm").format(
                                      DateTime.tryParse(
                                                  arguments.createdAt ?? "")
                                              ?.toLocal() ??
                                          DateTime.now())),
                              Container(
                                decoration: BoxDecoration(
                                  color: Style.lightBlue100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "N°${arguments.orderNumber.toString() ?? ""}",
                                      style: Style.interBold(
                                          color: Style.secondaryColor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                information(
                                  context,
                                  "Serveur:",
                                  "${user?.firstname} ${user?.lastname}",
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const VerticalDivider(
                                  color: Style.light,
                                  thickness: 1,
                                  width: 40,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                information(
                                  context,
                                  "Client:",
                                  arguments.customerType == "SAVED"
                                      ? "${arguments.customer?.lastname != null ? arguments.customer?.lastname : ""} ${arguments.customer?.firstname != null ? arguments.customer?.firstname : ""}"
                                      : "Client de passage",
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          Divider(
                            color: Style.light,
                            thickness: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              arguments.status == "PAID"
                                  ? Text("Moyen de paiment".toUpperCase())
                                  : Text("Statut".toUpperCase()),
                              4.verticalSpace,
                              arguments.status == "PAID"
                                  ? Text(
                                      "${paymentMethodName()}",
                                      style: Style.interBold(),
                                    )
                                  : Text(
                                      "Non payé",
                                      style: Style.interBold(),
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Style.light,
                    width: double.infinity,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Table(
                        children: [
                          TableRow(children: [
                            orderDetailStringContent("PRODUIT", true, false),
                            orderDetailStringContent("UNITÉ", true, true),
                            orderDetailStringContent("TOTAL", true, true),
                          ])
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: arguments.orderDetails == null
                        ? 0
                        : arguments.orderDetails?.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (arguments.orderDetails != null) {
                        OrderDetailsEntity orderDetail =
                            arguments.orderDetails![index];
                        return commandList(orderDetail);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  20.verticalSpace,
                  const Divider(
                    color: Style.black,
                    height: 2,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            child: Column(
                              children: [
                                totalCommand("Sous Total",
                                    arguments.subTotal ?? 0, false),
                                totalCommand("Réduction", 0, false),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL",
                            style: TextStyle(
                              color: Style.dark,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 30,
                            child: Stack(
                              children: [
                                Text(
                                  "${arguments.grandTotal}".notCurrency(),
                                  style: Style.interBold(
                                    size: 20.sp,
                                    color: Style.black,
                                  ),
                                ),
                                Positioned(
                                  left: AppHelpersCommon.getTextWidth(
                                    arguments.grandTotal.toString(),
                                    Style.interNormal(
                                      size: 20,
                                      color: Style.darker,
                                    ),
                                  ),
                                  bottom: 2,
                                  child: SizedBox(
                                    width: 40,
                                    height: 14,
                                    child: Text(
                                      TrKeysConstant.splashFcfa,
                                      style: Style.interNormal(
                                          size: 8, color: Style.darker),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  5.verticalSpace,
                  OrderInvoiceButtonComponent(ordersData: arguments),
                ],
              )),
        ));
  }

  Widget information(BuildContext context, String title, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Style.interBold(size: 14, color: Style.dark),
          ),
          Text(
            body,
            style: Style.interBold(
              size: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget totalCommand(String name, int price, bool isTotal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Style.interNormal(
                  size: 16,
                ),
              ),
              Text(
                '$price'.currencyLong(),
                style: isTotal == true
                    ? Style.interBold(
                        size: 16,
                      )
                    : Style.interBold(
                        size: 16,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget commandList(OrderDetailsEntity orderDetail) {
    int calculate = (orderDetail.price ?? 0) * (orderDetail.quantity ?? 0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: SizedBox(
          width: double.infinity,
          child: Table(
            children: [
              TableRow(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    orderDetailStringContent(
                        orderDetail.food == null
                            ? orderDetail.bundle['name']
                            : orderDetail.food!.name,
                        false,
                        false),
                    Text("Qté ${orderDetail.quantity.toString() ?? "0"}",
                        style: Style.interNormal(size: 10)),
                  ],
                ),
                orderDetailNumberContent(orderDetail.price ?? 0),
                orderDetailNumberContent(calculate),
              ]),
            ],
          )),
    );
  }

  Widget orderDetailStringContent(String text, bool isBool, isEnd) {
    return Text(
      text,
      textAlign: isEnd ? TextAlign.end : TextAlign.start,
      style: isBool
          ? Style.interBold(
              size: 12,
            )
          : Style.interNormal(
              size: 12,
            ),
    );
  }

  Widget orderDetailNumberContent(int value) {
    return Text(
      "$value".currencyLong(),
      textAlign: TextAlign.end,
      style: Style.interNormal(
        size: 10,
      ),
    );
  }

  String paymentMethodName() {
    if (arguments.paymentMethod == null) {
      final payment = PAIEMENTS.firstWhere(
            (item) => item['id'] == arguments.paymentMethodId,
        orElse: () => Map<String, dynamic>(),
      );
      return payment['name'] ?? "";
    }
    return arguments.paymentMethod?.name ?? "";
  }

}
