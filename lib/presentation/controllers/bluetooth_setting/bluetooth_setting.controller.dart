import 'dart:io';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' as mt;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionhandler;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';

import 'package:tajiri_pos_mobile/domain/entities/printer_model.entity.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class BluetoothSettingController extends GetxController {
  final connected = false.obs;
  final progress = false.obs;
  final user = AppHelpersCommon.getUserInLocalStorage();
  String? get restaurantId => user?.restaurantId;

  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();

  final encodeCharset = "CP437";

  String msj = '';
  String msjprogress = "";

  final macConnected = Rx<String?>(null);
  final items = Rx<List<BluetoothInfo>>([]);
  final isLoading = false.obs;

  final selectPaperSize = Rx<PaperSize?>(null);

  //
  final tableList = List<Table>.empty().obs;
  final waitressList = List<Waitress>.empty().obs;
  final customersList = List<Customer>.empty().obs;
  final tajiriSdk = TajiriSDK.instance;

  getSelectSizePaper() async {
    selectPaperSize.value = await AppHelpersCommon.getPaperSize();
    print("==selectPaperSize : ${selectPaperSize.value?.value}===");
  }

  setSelectSizePaper(PaperSize paperSize) async {
    selectPaperSize.value = paperSize;
    AppHelpersCommon.setPaperSize(paperSize.value);
    print("==selectPaperSize : ${selectPaperSize.value?.value}===");
  }

  @override
  void onInit() {
    print("=============INIT BLUE CONTROLLER");
    mt.WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getSelectSizePaper();
      await _requestPermissions();
      await Get.find<BluetoothSettingController>().getBluetoothDevices();
    });
    super.onInit();
  }

  @override
  void onReady() async {
    Future.wait([
      fetchCustomers(),
      fetchWaitress(),
      fetchTables(),
    ]);
    super.onReady();
  }

  Future<void> _requestPermissions() async {
    // Liste des permissions à demander
    List<permissionhandler.Permission> permissions = [
      permissionhandler.Permission.bluetooth,
      permissionhandler.Permission.bluetoothConnect,
      permissionhandler.Permission.bluetoothScan,
      permissionhandler.Permission.location,
    ];

    // Demander chaque permission successivement
    for (permissionhandler.Permission permission in permissions) {
      if (!await permission.status.isGranted) {
        try {
          await permission.request();
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<void> getBluetoothDevices() async {
    try {
      await _requestPermissions();
    } catch (e) {
      print("Erreur getBluetoothDevices $e");
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
    print('========oldconnect ${connected.value}===========connect to $mac');
    progress.value = true;
    msjprogress = "Connecting...";
    connected.value = false;
    macConnected.value = null;
    // disconnect before connect otherwise if a device was connected it will be impossible to connect
    await PrintBluetoothThermal.disconnect;
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("========state conected $result");
    if (result) {
      macConnected.value = mac;
      connected.value = true;
      AppHelpersCommon.setPrinterMacAdress(mac);
    } else {
      disconnect();
    }
    progress.value = false;
  }

  Future<void> disconnect() async {
    try {
      if (Platform.isIOS) {
        if (connected.value == true) {
          final status = await PrintBluetoothThermal.disconnect;
          print("status disconnect $status");
          if (status) {
            AppHelpersCommon.deletePrinterMacAdress();
          }
        }
      } else {
        final status = await PrintBluetoothThermal.disconnect;
        print("status disconnect $status");
        if (status) {
          AppHelpersCommon.deletePrinterMacAdress();
        }
      }

      connected.value = false;
      macConnected.value = null;
    } catch (e) {
      print(e);
    }
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
    if (selectPaperSize.value == null) {
      return;
    }
    final profile = await CapabilityProfile.load();
    List<int> ticket = await demoOneLine(selectPaperSize.value!, profile);
    final result = await PrintBluetoothThermal.writeBytes(ticket);
    print("PRINTER DEMO RESULT : $result");
  }

  Future<void> printReceipt(PrinterModelEntity printerModel) async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      try {
        if (selectPaperSize.value == null) {
          return;
        }

        bool result = false;
        isLoading.value = true;
        Mixpanel.instance.track('Print Invoice');
        final profile = await CapabilityProfile.load();
        List<int> ticket =
            await demoReceipt(selectPaperSize.value!, profile, printerModel);
        result = await PrintBluetoothThermal.writeBytes(ticket);
        print("print Receipt result:  $result");
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
      }
    } else {
      print("print Receipt conexionStatus: $conexionStatus");
      disconnect();
    }
  }

  String addMilleSeparator(dynamic number) {
    return NumberFormat("#,###").format(number).replaceAll(',', '.');
  }

  Future<List<int>> demoReceipt(PaperSize paper, CapabilityProfile profile,
      PrinterModelEntity printerModel) async {
    final Generator ticket = Generator(paper, profile);
    final formattedOrderGrandTotal = addMilleSeparator(printerModel.grandTotal);

    final leftToPay = printerModel.statusOrder == "PAID"
        ? "0 F"
        : "$formattedOrderGrandTotal F";

    List<int> bytes = [];
    bytes += ticket.reset();

    final logoURL = restaurant?.logoUrl;
    // add logo restaurant
    if (logoURL != null) {
      try {
        bytes += await printImageFromUrl(
          ticket,
          logoURL,
        );
      } catch (e) {
        print(e);
      }
    }
    bytes += await getTitleReceipt(ticket, printerModel);

    // get columns
    bytes += getHeaderItem(ticket);
    int itemCount = printerModel.orderPrinterProducts.length;
    for (int index = 0; index < itemCount; index++) {
      final orderProduct = printerModel.orderPrinterProducts[index];

      ProductVariant? foodVariant;
      if (orderProduct.variantId != null) {
        print("order prod variant ${orderProduct.variantId}");
      }
      // TODO : TO UPDATE
      final foodName = foodVariant?.name ?? orderProduct.productName;
      final quantity = orderProduct.quantity;
      final calculatePrice = orderProduct.totalPrice;

      final formattedPrice = addMilleSeparator(calculatePrice);

      List<String> productLines =
          splitText(foodName, getMaxCharactersPerLine(selectPaperSize.value));
      bytes += await getColumItem(
        productLines,
        "$formattedPrice F",
        ticket,
        quantity,
      );
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
        await CharsetConverter.encode(encodeCharset, 'A tres bientot.');

    bytes += ticket.textEncoded(encodedRenerciment,
        styles: const PosStyles(align: PosAlign.center));
    bytes += ticket.textEncoded(encodedEndRenerciment,
        styles: const PosStyles(
          align: PosAlign.center,
        ));

    bytes += ticket.cut();
    return bytes;
  }

  int getMaxCharactersPerLine(PaperSize? paperSize, {int columnWidth = 5}) {
    if (paperSize == null) {
      return 15;
    }
    int totalWidth = paperSize.width;
    // Estimation de caractères par ligne selon la largeur
    double charPerPixel = 1; // Ajuste cette valeur en fonction des tests
    int maxCharacters = (totalWidth * charPerPixel).toInt();
    final result = maxCharacters *
        columnWidth ~/
        12; // Ajustement basé sur la largeur de la colonne
    return result;
  }

  Future<List<int>> demoOneLine(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    bytes += ticket.reset();

    final encoded = await CharsetConverter.encode(
        encodeCharset, "Bienvenue chez Tajiri , a tres bientot");

    bytes += ticket.textEncoded(encoded);
    bytes += ticket.cut();
    return bytes;
  }

  // Receipt refactoring

  Future<List<int>> getTitleReceipt(
      Generator ticket, PrinterModelEntity printerModel) async {
    print("-----getTitleReceipt--------");
    var dateFormat = DateFormat("dd/MM/yyyy HH:mm", 'fr_FR');
    final date = dateFormat
        .format(printerModel.createdOrder?.toLocal() ?? DateTime.now());
    final restoName = restaurant?.name ?? "";
    final restoPhone = user?.phone ?? restaurant?.phone ?? "";
    final client =
        getNameCustomerById(printerModel.orderCustomerId, customersList);

    final currentUserName = "${user?.firstname ?? ""} ${user?.lastname ?? ""}";

    final userOrWaitressName = printerModel.orderWaitressId != null
        ? getNameWaitressById(printerModel.orderWaitressId, waitressList)
        : currentUserName;

    final payementMethod = printerModel.statusOrder == "PAID"
        ? getNamePaiementById(printerModel.orderPaymentMethodId) ?? "Cash"
        : "Non paye";

    print("payementMethod  $payementMethod  ${printerModel.orderNumber}");

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
      await getColumns("N°: ${printerModel.orderNumber}", payementMethod, true),
    );

    bytes += ticket.text("Serveur: $userOrWaitressName");

    bytes += ticket.text("Client: $client");

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
          align: PosAlign.center,
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
          align: PosAlign.center,
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

  Future<List<int>> printImageFromUrl(Generator ticket, String imageUrl) async {
    print("------printImageFromUrl----$imageUrl--");
    // Télécharger l'image à partir de l'URL
    List<int> bytes = [];

    final response = await http.get(Uri.parse(imageUrl));

    print(response.statusCode);

    if (response.statusCode == 200) {
      // Convertir l'image téléchargée en bytes
      final imageBytes = response.bodyBytes;

      // Décodez l'image pour obtenir les informations de l'image
      var image = decodeImage(imageBytes);
      print(image);
      // Vérifier si l'image est valide
      if (image != null) {
        const maxWidth = 200;
        const maxHeight = 100;
        if (image.width > maxWidth || image.height > maxHeight) {
          // Redimensionner l'image tout en conservant le ratio hauteur/largeur
          Uint8List compressedImage =
              await FlutterImageCompress.compressWithList(
            imageBytes,
            minWidth: maxWidth,
            minHeight: maxHeight,
          );

          image = decodeImage(compressedImage);
        }
        // Imprimer l'image sur le ticket
        if (image != null) {
          bytes += ticket.image(image);
        }
      } else {
        print('Failed to decode image');
      }
    } else {
      print('Failed to load image from URL');
    }
    return bytes;
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

  Future<void> fetchCustomers() async {
    if (restaurantId == null) {
      print("===restaurantId null");
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        final result =
            await tajiriSdk.customersService.getCustomers(restaurantId!);
        customersList.assignAll(result);
        update();
      } catch (e) {
        print("======Error fetch Custommer : $e");
        update();
      }
    }
  }

  Future<void> fetchWaitress() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        final result = await tajiriSdk.waitressesService.getWaitresses();
        waitressList.assignAll(result);
        update();
      } catch (e) {
        print("======Error fetch Waitress : $e");
        update();
      }
    }
  }

  Future<void> fetchTables() async {
    if (restaurantId == null) {
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        update();
        final result = await tajiriSdk.tablesService.getTables(restaurantId!);
        tableList.assignAll(result);
        update();
      } catch (e) {
        update();
      }
    }
  }
}
