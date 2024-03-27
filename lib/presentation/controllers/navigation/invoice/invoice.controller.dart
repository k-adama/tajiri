import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf.service.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf_invoice.service.dart';

import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';

class InvoiceController extends GetxController {
  final user = AppHelpersCommon.getUserInLocalStorage();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final devices = Rx<List<BluetoothDevice>>([]);
  List<BluetoothDevice> selectedPrinter = [];
  BluetoothDevice? device;
  final connected = false.obs;

  @override
  void onInit() {
    initPlatformState();

    super.onInit();
  }

  Future<void> initPlatformState() async {
    print("============INIT bluetooth==========");
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> _devices = [];

    try {
      _devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("===PlatformException===");
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          connected.value = true;
          break;
        case BlueThermalPrinter.DISCONNECTED:
          connected.value = false;
          break;
        default:
          break;
      }
    });

    devices.value = _devices;

    if (isConnected == true) {
      connected.value = true;
    }
  }

  String paymentMethodName(OrderEntity order) {
    if (order.paymentMethod == null) {
      final payment = PAIEMENTS.firstWhere(
        (item) => item['id'] == order.paymentMethodId,
        orElse: () => <String, dynamic>{},
      );
      return payment['name'] ?? "";
    }
    return order.paymentMethod?.name ?? "";
  }

  void printFactureByBluetooth(OrderEntity order) async {
    ByteData bytesAsset = await rootBundle.load("assets/images/logo_taj.png");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    Mixpanel.instance.track('Print Invoice');

    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printCustom(
        "${user != null && user?.restaurantUser != null ? user?.restaurantUser![0].restaurant?.name : ""}",
        10,
        30);

    bluetooth.printNewLine();
    bluetooth.printNewLine();
    var dateFormat = DateFormat("dd/MM/yyyy HH:mm", 'fr_FR');
    bluetooth.printLeftRight(
        dateFormat.format(
            DateTime.tryParse(order.createdAt.toString())?.toLocal() ??
                DateTime.now()),
        "",
        30);
    bluetooth.printNewLine();
    bluetooth.printLeftRight(
        "Client: ${order.customer?.firstname?.toString() ?? "Client"} ${order.customer?.lastname?.toString() ?? "invite"}",
        "",
        30);
    bluetooth.printLeftRight(
        "Serveur:  ${userOrWaitressName(order, user)}", "", 30);
    bluetooth.printLeftRight("N.#: ${order.orderNumber}", "", 30);
    bluetooth.printNewLine();
    order.status == "PAID"
        ? bluetooth.printLeftRight(
            "MOYEN DE PAIMENT: ${order.paymentMethod?.name ?? ""}", "", 30)
        : bluetooth.printLeftRight("STATUT: Non paye", "", 30);
    bluetooth.printNewLine();
    bluetooth.printCustom("--------------------------------", 10, 10);
    bluetooth.printNewLine();
    int itemCount = order.orderDetails?.length ?? 0;
    for (int index = 0; index < itemCount; index++) {
      final orderDetail = order.orderDetails?[index];
      if (orderDetail != null) {
        final foodName = orderDetail.food?.name ?? orderDetail.bundle?['name'];
        final quantity = orderDetail.quantity ?? 0;
        final price = orderDetail.price ?? 0;
        final calculatePrice = quantity * price;
        bluetooth.printCustom("$quantity $foodName $calculatePrice F", 6, 0);
        bluetooth.printNewLine();
      }
    }
    bluetooth.printNewLine();
    bluetooth.printCustom("--------------------------------", 10, 10);
    bluetooth.printNewLine();
    bluetooth.printLeftRight("Total", "${order.grandTotal ?? 0} F", 15);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printCustom("Merci d'etre passe", 10, 20);
    bluetooth.printNewLine();
    bluetooth.printImageBytes(imageBytesFromAsset);
    bluetooth.paperCut();
    bluetooth.drawerPin5();
  }

  void notConnectedPrint(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return LayoutBuilder(builder: (context, constraints) {
            return SimpleDialog(
              title: SizedBox(
                  height: constraints.maxHeight * 0.7,
                  width: 300.r,
                  child: ListView.builder(
                    itemCount: devices.value.length,
                    itemBuilder: (c, i) {
                      return ListTile(
                        leading: const Icon(Icons.print),
                        title: Text(devices.value[i].name ?? "Pas de nom"),
                        subtitle:
                            Text(devices.value[i].address ?? "Pas d'adresse"),
                        onTap: () async {
                          selectedPrinter.add(devices.value[i]);
                          bluetooth.connect(devices.value[i]);
                          connected.value = true;
                          Navigator.pop(context);
                        },
                      );
                    },
                  )),
            );
          });
        });
  }

  void shareFacture(OrderEntity order) async {
    Mixpanel.instance.track("Share Ticket to customer", properties: {
      "Order Status": order.status,
      "Customer type": order.customerType,
      "Total Price": order.grandTotal,
      "Payment method":
          order.paymentMethod != null ? order.paymentMethod?.name : ""
    });

    final pdfFile = await ApiPdfInvoiceService.generate(order);

    ApiPdfService.shareFile(pdfFile);
  }
}
