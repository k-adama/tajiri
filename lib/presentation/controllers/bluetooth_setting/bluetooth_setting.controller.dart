import 'dart:io';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
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
  final isLoading = false.obs;

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
    ];

    // Demander chaque permission successivement
    for (Permission permission in permissions) {
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
      try {
        bool result = false;
        isLoading.value = true;
        Mixpanel.instance.track('Print Invoice');
        const PaperSize paper = PaperSize.mm58;
        final profile = await CapabilityProfile.load();
        List<int> ticket = await demoReceipt(paper, profile, order);
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

  Future<List<int>> demoReceipt(
      PaperSize paper, CapabilityProfile profile, OrderEntity order) async {
    final Generator ticket = Generator(paper, profile);
    final formattedOrderGrandTotal = addMilleSeparator(order.grandTotal ?? 0);

    final leftToPay =
        order.status == "PAID" ? "0 F" : "$formattedOrderGrandTotal F";

    List<int> bytes = [];
    bytes += ticket.reset();

    final logoURL = user?.restaurantUser?[0].restaurant?.logoUrl;
    // add logo restaurant
    if (logoURL != null) {
      bytes += await printImageFromUrl(
        ticket,
        logoURL,
      );
    }
    bytes += await getTitleReceipt(ticket, order);

    // get columns
    bytes += getHeaderItem(ticket);
    int itemCount = order.orderDetails?.length ?? 0;
    for (int index = 0; index < itemCount; index++) {
      final orderDetail = order.orderDetails?[index];
      if (orderDetail != null) {
        FoodDataEntity? food = orderDetail.food ?? orderDetail.bundle;
        FoodVariantEntity? foodVariant;
        if (food != null) {
          if (food.price != orderDetail.price &&
              food.foodVariantCategory != null &&
              food.foodVariantCategory!.isNotEmpty) {
            foodVariant =
                food.foodVariantCategory![0].foodVariant!.firstWhereOrNull(
              (element) => element.price == orderDetail.price,
            );
          }
        }

        final foodName =
            foodVariant?.name ?? getNameFromOrderDetail(orderDetail);
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
        await CharsetConverter.encode(encodeCharset, 'A tres bientot.');

    bytes += ticket.textEncoded(encodedRenerciment,
        styles: const PosStyles(align: PosAlign.center));
    bytes += ticket.textEncoded(encodedEndRenerciment,
        styles: const PosStyles(
          align: PosAlign.center,
        ));

    bytes += ticket.text('', styles: const PosStyles(align: PosAlign.center));
    bytes += ticket.text('', styles: const PosStyles(align: PosAlign.center));

    // Print image
    // final ByteData data = await rootBundle.load('assets/images/logo_taj.png');
    // final imageBytes = data.buffer.asUint8List();

    // final image = decodeImage(imageBytes);

    // bytes += ticket.image(image!);

    ticket.emptyLines(4);
    ticket.cut();
    return bytes;
  }

  Future<List<int>> demoOneLine(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    bytes += ticket.reset();

    final encoded = await CharsetConverter.encode(
        encodeCharset, "Bienvenue chez Tajiri , a tres bientot");

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
    final client = order.customer?.firstname?.toString() ?? "Client invite";

    final payementMethod = order.status == "PAID"
        ? paymentMethodNameByOrder(order).isEmpty
            ? "Cash"
            : paymentMethodNameByOrder(order)
        : "Non paye";

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

    bytes += ticket.text("Serveur: ${userOrWaitressName(order, user)}");

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
}
