import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_details.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/invoice/invoice.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/detail_content.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/information_invoice_component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/invoice_buttons.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/invoice_order_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/invoice_total.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/total_command.component.dart';

class InvoiceScreen extends StatefulWidget {
  final OrderEntity? order;
  final bool? isPaid;
  const InvoiceScreen({super.key, this.order, this.isPaid});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final controller = Get.put(InvoiceController());

  backInvoiceScreen() {
    if (widget.isPaid == true) {
      Get.offAllNamed(Routes.NAVIGATION, arguments: {"selectIndex": 0});
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderEntity arguments = Get.arguments ?? widget.order;

    final user = controller.user;

    return PopScope(
      canPop: widget.isPaid == true ? false : true,
      onPopInvoked: widget.isPaid == true
          ? (didPop) {
              backInvoiceScreen();
            }
          : null,
      child: Scaffold(
          backgroundColor: Style.lighter,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Style.black),
            elevation: 0,
            backgroundColor: Style.white,
            leading: BackButton(
              onPressed: () {
                backInvoiceScreen();
              },
            ),
          ),
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
                                InformationInvoiceComponent(
                                    title: "Date",
                                    body: DateFormat("MM/dd/yy HH:mm").format(
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
                                        "N°${arguments.orderNumber.toString()}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InformationInvoiceComponent(
                                    title: "Serveur:",
                                    body: userOrWaitressName(arguments, user),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: VerticalDivider(
                                      color: Style.light,
                                      thickness: 1,
                                      width: 40,
                                    ),
                                  ),
                                  InformationInvoiceComponent(
                                    title: "Client:",
                                    body: arguments.customerType == "SAVED"
                                        ? "${arguments.customer?.lastname ?? ""} ${arguments.customer?.firstname ?? ""}"
                                        : "Client de passage",
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            const Divider(
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
                                        controller.paymentMethodName(arguments),
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
                          children: const [
                            TableRow(children: [
                              OrderDetailStringContent(
                                  text: "PRODUIT", isBold: true, isEnd: false),
                              OrderDetailStringContent(
                                  text: "UNITÉ", isBold: true, isEnd: true),
                              OrderDetailStringContent(
                                  text: "TOTAL", isBold: true, isEnd: true),
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
                          return InvoiceOrderItemComponent(
                              orderDetail: orderDetail);
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
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 120,
                              child: Column(
                                children: [
                                  TotalCommandComponent(
                                    name: "Sous Total",
                                    price: arguments.subTotal ?? 0,
                                    isTotal: false,
                                  ),
                                  const TotalCommandComponent(
                                    name: "Réduction",
                                    price: 0,
                                    isTotal: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InvoiceTotalComponent(
                      order: arguments,
                    ),
                    5.verticalSpace,
                    InvoiceButtonsComponent(
                      ordersData: arguments,
                      printButtonTap: () {
                        if (controller.connected.value == true) {
                          //   controller.printFactureByBluetooth(arguments);
                          controller.printNewModelFactureByBluetooth(arguments);
                        } else {
                          controller.notConnectedPrint(context);
                        }
                      },
                      shareButtonTap: () {
                        controller.shareFacture(arguments);
                      },
                      returnToOrderButtonTap: () {
                        if (widget.isPaid == true) {
                          Get.offAllNamed(Routes.NAVIGATION,
                              arguments: {"selectIndex": 0});
                        } else {
                          Get.back();
                        }
                      },
                    ),
                  ],
                )),
          )),
    );
  }
}
