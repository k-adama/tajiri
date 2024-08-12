import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/invoice/invoice.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/detail_content.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/information_invoice_component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/invoice_buttons.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/invoice_order_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/invoice_total.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/components/total_command.component.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart' as taj;

class InvoiceScreen extends StatefulWidget {
  final taj.Order? order;
  final bool? isPaid;
  const InvoiceScreen({super.key, this.order, this.isPaid});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late final taj.Order arguments;

  bool backInvoiceScreen() {
    if (widget.isPaid == true) {
      Navigator.popUntil(context, ModalRoute.withName(Routes.NAVIGATION));
      return true;
    } else {
      Get.back();
      return true;
    }
  }

  @override
  void initState() {
    arguments = Get.arguments ?? widget.order;
    if (mounted) {
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isPaid == true) {
          return backInvoiceScreen();
        }
        return true;
      },
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
          body: GetBuilder<InvoiceController>(builder: (controller) {
            return SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InformationInvoiceComponent(
                                      title: "Date",
                                      body: DateFormat("MM/dd/yy HH:mm").format(
                                          arguments.createdAt?.toLocal() ??
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
                                      body: controller
                                          .tableOrWaitressName(arguments),
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
                                      body: controller.customerName(arguments),
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
                                          paymentMethodNameByOrder(arguments),
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
                                    text: "PRODUIT",
                                    isBold: true,
                                    isEnd: false),
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
                        itemCount: arguments.orderProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          taj.OrderProduct orderDetail =
                              arguments.orderProducts[index];
                          return InvoiceOrderItemComponent(
                            orderProduct: orderDetail,
                          );
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
                                      price: arguments.subTotal,
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
                      Obx(() {
                        return InvoiceButtonsComponent(
                          ordersData: arguments,
                          isLoading:
                              controller.bluetoothController.isLoading.value,
                          printButtonTap: () {
                            controller.printButtonTap(arguments);
                          },
                          shareButtonTap: () {
                            controller.shareFacture(arguments);
                          },
                          returnToOrderButtonTap: () {
                            Get.find<NavigationController>().selectIndexFunc(1);
                            if (widget.isPaid == true) {
                              Navigator.popUntil(context,
                                  ModalRoute.withName(Routes.NAVIGATION));
                            } else {
                              Get.back();
                            }
                          },
                        );
                      }),
                    ],
                  )),
            );
          })),
    );
  }
}
