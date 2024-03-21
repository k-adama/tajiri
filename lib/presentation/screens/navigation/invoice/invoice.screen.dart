import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_details.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/invoice/invoice.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/invoice_buttons.component.dart';

class InvoiceScreen extends StatefulWidget {
  final OrdersDataEntity? order;
  final bool? isPaid;
  const InvoiceScreen({super.key, this.order, this.isPaid});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    final OrdersDataEntity arguments = Get.arguments ?? widget.order;

    final user = controller.user;
    return Scaffold(
        backgroundColor: Style.lighter,
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Style.black),
            elevation: 0,
            backgroundColor: Style.white,
            leading: BackButton(
              onPressed: () {
                if (widget.isPaid == true) {
                  Get.offAllNamed(Routes.NAVIGATION,
                      arguments: {"selectIndex": 0});
                } else {
                  Get.back();
                }
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
                                  "${user?.firstname ?? ""} ${user?.lastname ?? ""}",
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
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
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
                                  left: controller.getTextWidth(
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
                  InvoiceButtonsComponent(
                    ordersData: arguments,
                    printButtonTap: () {
                      if (controller.connected.value == true) {
                        controller.printFactureByBluetooth(arguments);
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
                    Text("Qté ${orderDetail.quantity.toString()}",
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
}
