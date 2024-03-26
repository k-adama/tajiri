import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf.service.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sales_reports/sales_reports.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/dat_picker_information.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/pdf_report.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/price_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/sales_reports_expansion_panel_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/share_or_back_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/user_or_restaurant_informations.component.dart';

class SalesReportsScreen extends StatefulWidget {
  const SalesReportsScreen({super.key});

  @override
  State<SalesReportsScreen> createState() => _SalesReportsScreenState();
}

class _SalesReportsScreenState extends State<SalesReportsScreen> {
  final SalesReportController salesReportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Style.black),
        title: Text(
          "Rapport de vente",
          style: Style.interNormal(size: 14, color: Style.secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: Style.white,
      ),
      body: GetBuilder<SalesReportController>(
        builder: (salesReportController) => Column(
          children: [
            Expanded(
                flex: 5,
                child: SizedBox(
                    width: double.infinity,
                    child: ListView(
                      children: [
                        UserOrRestaurantInformationComponent(
                          restaurantName:
                              "${salesReportController.user!.restaurantUser != null ? salesReportController.user!.restaurantUser![0].restaurant?.name : ""}",
                          contactPhone:
                              "${salesReportController.user!.restaurantUser != null ? salesReportController.user!.restaurantUser![0].restaurant?.contactPhone : ""}",
                          userName:
                              "${salesReportController.user!.lastname ?? ""} ${salesReportController.user!.firstname ?? ""}",
                        ),
                        SalesReportsDatePickerInformationComponent(
                          startDate:
                              salesReportController.getStartDateInFrench(),
                          endDate: salesReportController.getEndDateInFrench(),
                        ),
                        SalesPricesComponent(
                          total: "${salesReportController.total.value ?? 0}"
                              .notCurrency(),
                          component: Positioned(
                            left: salesReportController.getTextWidth(
                                salesReportController.total.value.toString(),
                                Style.interNormal(
                                  size: 20.sp,
                                  color: Style.darker,
                                )),
                            top: 6,
                            child: SizedBox(
                              width: 40.w,
                              height: 14.h,
                              child: Text(
                                TrKeysConstant.splashFcfa,
                                style: Style.interNormal(
                                    size: 8.sp, color: Style.darker),
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        salesReportController.sales.isNotEmpty
                            ? SalesReportsExpansionPanelListComponent(
                                salesData: salesReportController.sales,
                              )
                            : const SizedBox(),
                        20.verticalSpace,
                      ],
                    ))),
            SalesReportsShareOrBackButton(
              onTapShare: () async {
                final pdfFile = await PdfReportComponent.generate(
                    salesReportController.sales,
                    salesReportController.total.value,
                    salesReportController.startDate,
                    salesReportController.endDate);
                ApiPdfService.shareFile(pdfFile);
              },
              onTapBack: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
