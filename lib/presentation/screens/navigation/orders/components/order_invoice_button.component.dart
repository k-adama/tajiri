import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/pdf_api.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/components/pdf_invoice_api.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class OrderInvoiceButtonComponent extends StatefulWidget {
  final OrderEntity ordersData;
  OrderInvoiceButtonComponent({super.key, required this.ordersData});

  @override
  State<OrderInvoiceButtonComponent> createState() => _OrderInvoiceButtonComponentState();
}

class _OrderInvoiceButtonComponentState extends State<OrderInvoiceButtonComponent> {
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.ordersData.status == "PAID" ? 10.0 : 10.0, vertical: 1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  title: widget.ordersData.status == "PAID" ? 'Imprimer le reçu' : 'Imprimer la facture',
                  textColor: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  weight: 20,
                  background: Style.primaryColor,
                  radius: 5,
                  isUnderline: false,
                  onPressed: () async {
                    if (_connected == true) {
                      printFactureByBluetooth();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return LayoutBuilder(
                                builder: (context, constraints) {
                                  return SimpleDialog(
                                    title: SizedBox(
                                        height:
                                        constraints.maxHeight *
                                            0.7,
                                        width: 300.r,
                                        child: ListView.builder(
                                          itemCount: _devices.length,
                                          itemBuilder: (c, i) {
                                            return ListTile(
                                              leading: const Icon(
                                                  Icons.print),
                                              title: Text(
                                                  _devices[i].name ??
                                                      "Pas de nom"),
                                              subtitle: Text(_devices[
                                              i]
                                                  .address ??
                                                  "Pas d'adresse"),
                                              onTap: () async {
                                                setState(() {
                                                  _selectedPrinter
                                                      .add(_devices[
                                                  i]);
                                                  bluetooth.connect(
                                                      _devices[i]);
                                                  _connected = true;
                                                });
                                                Navigator.pop(
                                                    context);
                                              },
                                            );
                                          },
                                        )),
                                  );
                                });
                          });
                    }
                  },
                ),
                CustomButton(
                  title: widget.ordersData.status == "PAID" ? 'Partager le reçu' : 'Imprimer la facture',
                  textColor: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  weight: 20,
                  background: Style.white,
                  radius: 5,
                  haveBorder: true,
                  isUnderline: false,
                  borderColor: Style.secondaryColor,
                  onPressed: () async {
                    Mixpanel.instance.track(
                        "Share Ticket to customer",
                        properties: {
                          "Order Status": widget.ordersData.status,
                          "Customer type": widget.ordersData.customerType,
                          "Total Price": widget.ordersData.grandTotal,
                          "Payment method":
                          widget.ordersData.paymentMethod != null
                              ? widget.ordersData.paymentMethod?.name
                              : ""
                        });

                    final pdfFile =
                    await PdfInvoiceApiComponent.generate(widget.ordersData);

                    PdfApi.shareFile(pdfFile);
                  },
                ),
              ],
            ),
            5.verticalSpace,
            CustomButton(
              title: "Retour à la prise de commande",
              textColor: Style.secondaryColor,
              isLoadingColor: Style.secondaryColor,
              weight: 20,
              background: Style.white,
              radius: 5,
              haveBorder: false,
              isUnderline: true,
              onPressed: () {
                /*if (posController.isPaid.value) {
                  Get.offAllNamed(Routes.MAIN,
                      arguments: {"selectIndex": 0});
                } else {
                  Get.back();
                }*/
                //posController.isPaid.value = false;
              },
            ),
          ],
        ),
      ),
    );
  }

  void printFactureByBluetooth() async {
    ByteData bytesAsset = await rootBundle.load("assets/images/logo_taj.png");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

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
            DateTime.tryParse(widget.ordersData.createdAt.toString())?.toLocal() ??
                DateTime.now()),
        "",
        30);
    bluetooth.printNewLine();
    bluetooth.printLeftRight(
        "Client: ${widget.ordersData.customer?.firstname?.toString() ?? "Client"} ${widget.ordersData.customer?.lastname?.toString() ?? "invite"}",
        "",
        30);
    bluetooth.printLeftRight(
        "Serveur: ${user?.firstname} ${user?.lastname}", "", 30);
    bluetooth.printLeftRight("N.#: ${widget.ordersData.orderNumber}", "", 30);
    bluetooth.printNewLine();
    widget.ordersData.status == "PAID" ? bluetooth.printLeftRight("MOYEN DE PAIMENT: ${widget.ordersData.paymentMethod?.name ?? ""}", "", 30) : bluetooth.printLeftRight("STATUT: Non paye", "", 30);
    bluetooth.printNewLine();
    bluetooth.printCustom("--------------------------------", 10, 10);
    bluetooth.printNewLine();
    int itemCount = widget.ordersData.orderDetails!.length ?? 0;
    for (int index = 0; index < itemCount; index++) {
      final orderDetail = widget.ordersData.orderDetails?[index];
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
    bluetooth.printLeftRight("Total", "${widget.ordersData.grandTotal ?? 0} F", 15);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printCustom("Merci d'etre passe", 10, 20);
    bluetooth.printNewLine();
    bluetooth.printImageBytes(imageBytesFromAsset);
    bluetooth.paperCut();
    bluetooth.drawerPin5();
  }
}
