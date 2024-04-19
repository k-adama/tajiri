import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';

class BluetoothSettingController extends GetxController {
  final connected = false.obs;
  final progress = false.obs;
  final user = AppHelpersCommon.getUserInLocalStorage();

  final encodeCharset = "CP437";

  String msj = '';
  String msjprogress = "";

  final macConnected = Rx<String?>(null);
  final items = Rx<List<BluetoothInfo>>([]);

  @override
  void onInit() {
    print("=============INIT BLUE CONTROLLER");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _requestPermissions();
      await Get.find<BluetoothSettingController>().getBluetoothDevices();
      disconnect();
    });

    // initPlatformState();
    super.onInit();
  }

  Future<void> _requestPermissions() async {
    // Liste des permissions à demander
    List<Permission> permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      // Ajoutez d'autres permissions ici si nécessaire
    ];

    // Demander chaque permission successivement
    for (Permission permission in permissions) {
      if (!await permission.status.isGranted) {
        await permission.request();
      }
    }
  }

  Future<void> getBluetoothDevices() async {
    try {
      await _requestPermissions();
    } catch (e) {
      print(e);
    }
    progress.value = true;
    msjprogress = "En attente...";
    items.value = [];
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    progress.value = false;

    if (listResult.isEmpty) {
      msj =
          "Il n'y a pas de Bluetooth lié, allez dans les paramètres et associez l'imprimante";
    } else {
      msj = "Touchez un élément de la liste pour vous connecter";
    }

    items.value = listResult;
  }

  Future<void> connect(String mac, String name) async {
    print('===================connect');
    progress.value = true;
    msjprogress = "Connecting...";
    connected.value = false;
    macConnected.value = null;
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) {
      macConnected.value = mac;
      connected.value = true;
    } else {
      disconnect();
      // AppHelpersCommon.showBottomSnackBar(
      //     Get.context!,
      //     Text(
      //         "Impossible de vous connecter à $name ,  Vérifié si l'imprimante n'est pas connecté à un autre device"),
      //     const Duration(seconds: 3),
      //     true);
    }
    progress.value = false;
  }

  Future<void> disconnect() async {
    // if (connected.value == true) {
    try {
      if (Platform.isIOS) {
        if (connected.value == true) {
          final bool status = await PrintBluetoothThermal.disconnect;
          print("status disconnect $status");
        }
      } else {
        final bool status = await PrintBluetoothThermal.disconnect;
        print("status disconnect $status");
      }

      connected.value = false;
      macConnected.value = null;
    } catch (e) {
      print(e);
    }

    // AppHelpersCommon.showBottomSnackBar(
    //     Get.context!,
    //     const Text("Déconnection effectué avec succès"),
    //     const Duration(seconds: 3),
    //     true);
    // }
  }

  Future<void> initPlatformState() async {
    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    print("bluetooth enabled: $result");
    if (result) {
      msj = "Bluetooth activé, veuillez rechercher et vous connecter";
    } else {
      msj = "Bluetooth non activé";
    }
  }

  printDemo() async {
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    List<int> ticket = await demoOneLine(paper, profile);
    final result = await PrintBluetoothThermal.writeBytes(ticket);
    print("PRINTER RESULT : $result");
  }

  Future<void> printReceipt(OrderEntity order) async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      bool result = false;

      const PaperSize paper = PaperSize.mm58;
      final profile = await CapabilityProfile.load();
      List<int> ticket = await demoReceipt(paper, profile, order);
      result = await PrintBluetoothThermal.writeBytes(ticket);
      print("print Receipt result:  $result");
    } else {
      print("print Receipt conexionStatus: $conexionStatus");
      disconnect();
    }
  }

  String addMilleSeparator(dynamic number) {
    return NumberFormat("#,###").format(number).replaceAll(',', '.');
  }

  Future<List<int>> demoReceipt(
      PaperSize paper, CapabilityProfile profile, OrderEntity order) async {
    final Generator ticket = Generator(paper, profile);
    final formattedOrderGrandTotal = addMilleSeparator(order.grandTotal ?? 0);

    final leftToPay =
        order.status == "PAID" ? "0 F" : "$formattedOrderGrandTotal F";

    List<int> bytes = [];
    bytes += ticket.reset();

    // bytes += await printImageFromUrl(ticket,
    //     "https://firebasestorage.googleapis.com/v0/b/parcmanager-87bbd.appspot.com/o/logo_taj.png?alt=media&token=36817d62-03e3-4fa5-a645-6c39522cecff");

    bytes += await getTitleReceipt(ticket, order);

    // get columns
    bytes += getHeaderItem(ticket);
    int itemCount = order.orderDetails?.length ?? 0;
    for (int index = 0; index < itemCount; index++) {
      final orderDetail = order.orderDetails?[index];
      if (orderDetail != null) {
        final foodName = orderDetail.food?.name ?? orderDetail.bundle?['name'];
        final quantity = orderDetail.quantity ?? 0;
        final price = orderDetail.price ?? 0;
        final calculatePrice = quantity * price;

        final formattedPrice = addMilleSeparator(calculatePrice);

        List<String> productLines = splitText(foodName, 15);
        bytes += await getColumItem(
          productLines,
          "$formattedPrice F",
          ticket,
          quantity,
        );
      }
    }
    bytes += ticket.hr(linesAfter: 1);

    bytes += ticket.row(
      await getColumns("TOTAL FACTURE", "$formattedOrderGrandTotal F", false),
    );
    bytes += ticket.row(
      await getColumns("RESTE A PAYER", leftToPay, true),
    );
    bytes += ticket.emptyLines(1);
    bytes += ticket.hr(linesAfter: 1);

    final encodedRenerciment =
        await CharsetConverter.encode(encodeCharset, 'Merci de votre visite');
    final encodedEndRenerciment =
        await CharsetConverter.encode(encodeCharset, 'A très bientôt.');

    bytes += ticket.textEncoded(encodedRenerciment,
        styles: const PosStyles(align: PosAlign.center));
    bytes += ticket.textEncoded(encodedEndRenerciment,
        styles: const PosStyles(align: PosAlign.center));

    // Print image
    // final ByteData data = await rootBundle.load('assets/images/logo_taj.png');
    // final imageBytes = data.buffer.asUint8List();

    // final image = decodeImage(imageBytes);

    // bytes += ticket.image(image!);

    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  Future<List<int>> demoOneLine(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    bytes += ticket.reset();

    final encoded = await CharsetConverter.encode(
        encodeCharset, "Bienvenue chez Tajiri , à très bientôt");

    bytes += ticket.textEncoded(encoded);

    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  // Receipt refactoring

  Future<List<int>> getTitleReceipt(Generator ticket, OrderEntity order) async {
    print("-----getTitleReceipt--------");
    var dateFormat = DateFormat("dd/MM/yyyy HH:mm", 'fr_FR');
    final date = dateFormat.format(
        DateTime.tryParse(order.createdAt.toString())?.toLocal() ??
            DateTime.now());
    final restoName =
        "${user != null && user?.restaurantUser != null ? user?.restaurantUser![0].restaurant?.name : ""}";
    final restoPhone =
        "${user != null && user?.restaurantUser != null ? user?.restaurantUser![0].restaurant?.contactPhone : user?.phone ?? ""}";
    final client = order.customer?.firstname?.toString() ?? "Client invité";

    final payementMethod = order.status == "PAID"
        ? "Via ${order.paymentMethod?.name ?? ""}"
        : "Non payé";

    print("payementMethod  $payementMethod  ${order.orderNumber}");

    List<int> bytes = [];

    Uint8List encodedTitle =
        await CharsetConverter.encode(encodeCharset, restoName);

    Uint8List encodedDate = await CharsetConverter.encode(encodeCharset, date);
    Uint8List encodedPhone =
        await CharsetConverter.encode(encodeCharset, restoPhone);

    bytes += ticket.textEncoded(
      encodedTitle,
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size1,
      ),
    );

    bytes += ticket.textEncoded(encodedPhone,
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += ticket.textEncoded(encodedDate,
        styles: const PosStyles(align: PosAlign.center, bold: false));
    bytes += ticket.emptyLines(1);
    bytes += ticket.row(
      await getColumns("N°: ${order.orderNumber}", payementMethod, true),
    );

    bytes += ticket.row(
      await getColumns("Serveur:", userOrWaitressName(order, user), false),
    );
    bytes += ticket.row(
      await getColumns("Cient:", client, false),
    );

    bytes += ticket.emptyLines(1);
    return bytes;
  }

  List<int> getHeaderItem(Generator ticket) {
    print("-----getHeaderItem--------");
    List<int> bytes = [];

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(
        text: 'Qte',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: 'Produit',
        width: 5,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: 'Prix TTC',
        width: 5,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += ticket.hr(linesAfter: 1);
    return bytes;
  }

  Future<List<int>> getColumItem(List<String> productLines, String priceText,
      Generator ticket, int qte) async {
    print("-----getColumItem--------");
    List<int> bytes = [];
    Uint8List encodedNameProduct = await CharsetConverter.encode(
        encodeCharset, productLines.isNotEmpty ? productLines[0] : '');
    bytes += ticket.row([
      PosColumn(
        text: '$qte',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        textEncoded: encodedNameProduct,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: priceText,
        width: 4,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    for (int i = 1; i < productLines.length; i++) {
      Uint8List encodedNameProductLine =
          await CharsetConverter.encode(encodeCharset, productLines[i]);
      bytes += ticket.row([
        PosColumn(
          text: '',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          textEncoded: encodedNameProductLine,
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '',
          width: 5,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }
    bytes += ticket.emptyLines(1);
    return bytes;
  }

  Future<List<PosColumn>> getColumns(
      String title, String description, bool bold) async {
    Uint8List encodedTilte =
        await CharsetConverter.encode(encodeCharset, title);
    Uint8List encodedDescription =
        await CharsetConverter.encode(encodeCharset, description);

    return [
      PosColumn(
          textEncoded: encodedTilte,
          width: 6,
          styles: PosStyles(align: PosAlign.left, bold: bold)),
      PosColumn(
        textEncoded: encodedDescription,
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: bold),
      ),
    ];
  }

  //

  List<String> splitText(String text, int maxLength) {
    List<String> lines = [];
    for (int i = 0; i < text.length; i += maxLength) {
      lines.add(text.substring(
          i, i + maxLength < text.length ? i + maxLength : text.length));
    }
    return lines;
  }
}
