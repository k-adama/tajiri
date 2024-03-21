import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sales_reports/sales_reports.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/sales_reports_header.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/select_date_time_picker.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/title_widget.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/product_in_cart.widget.dart';

class SalesReportsDateTimePickerComponent extends StatefulWidget {
  const SalesReportsDateTimePickerComponent({super.key});

  @override
  State<SalesReportsDateTimePickerComponent> createState() =>
      _SalesReportsDateTimePickerComponentState();
}

class _SalesReportsDateTimePickerComponentState
    extends State<SalesReportsDateTimePickerComponent> {
  final PosController posController = Get.find();
  final NavigationController navigationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Style.black),
          backgroundColor: Style.white,
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (posController.cartItemList.isEmpty ||
                  navigationController.selectIndex != 1) {
                AppHelpersCommon.showBottomSnackBar(
                    context,
                    const ProductInCartWidget(),
                    const Duration(milliseconds: 500),
                    false);
              } else {
                AppHelpersCommon.showBottomSnackBar(
                  context,
                  const ProductInCartWidget(),
                  const Duration(days: 6000000000000000),
                  true,
                );
              }
            },
          ),
        ),
        body: GetBuilder<SalesReportController>(
            builder: (salesReportController) => SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SalesReportHeaderComponent(
                      title: "Rapport de vente",
                      style: Style.interBold(size: 30.sp),
                    ),
                    SalesReportHeaderComponent(
                      title:
                          "Générer un rapport de vente sur une période définie.",
                      style: Style.interBold(size: 14.sp),
                    ),
                    20.verticalSpace,
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: SalesTitleWidgetComponent(
                            radius: 5,
                            height: 90.h,
                            width: double.infinity,
                            title: 'Début',
                            component: Row(
                              children: [
                                SelectDateTimePickerComponent(
                                  padding: const EdgeInsets.all(10),
                                  labelText: "Date de début",
                                  iconData: Icons.calendar_today,
                                  dateTimeController:
                                      salesReportController.pickStartDate,
                                  onTap: () async {
                                    DateTime? pickedDate =
                                        await salesReportController
                                            .pickDate(context);
                                    String formattedDate = salesReportController
                                        .pickDateFormatted(pickedDate);
                                    salesReportController.pickStartDate.text =
                                        formattedDate;
                                  },
                                ),
                                SelectDateTimePickerComponent(
                                  padding: const EdgeInsets.all(15),
                                  labelText: "Heure de début",
                                  iconData: Icons.watch_later_outlined,
                                  dateTimeController:
                                      salesReportController.pickStartTime,
                                  onTap: () async {
                                    TimeOfDay? pickedDateTime =
                                        await salesReportController
                                            .pickTime(context);
                                    String formattedDate = salesReportController
                                        .pickTimeFormatted(pickedDateTime);
                                    salesReportController.pickStartTime.text =
                                        formattedDate;
                                  },
                                ),
                              ],
                            ))),
                    20.verticalSpace,
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: SalesTitleWidgetComponent(
                            radius: 5,
                            height: 90.h,
                            width: double.infinity,
                            title: 'Fin',
                            component: Row(
                              children: [
                                SelectDateTimePickerComponent(
                                  padding: const EdgeInsets.all(10),
                                  labelText: "Date de fin",
                                  iconData: Icons.calendar_today,
                                  dateTimeController:
                                      salesReportController.pickEndDate,
                                  onTap: () async {
                                    DateTime? pickedDate =
                                        await salesReportController
                                            .pickDate(context);
                                    String formattedDate = salesReportController
                                        .pickDateFormatted(pickedDate);
                                    salesReportController.pickEndDate.text =
                                        formattedDate;
                                  },
                                ),
                                SelectDateTimePickerComponent(
                                  padding: const EdgeInsets.all(15),
                                  labelText: "Heure de fin",
                                  iconData: Icons.watch_later_outlined,
                                  dateTimeController:
                                      salesReportController.pickEndTime,
                                  onTap: () async {
                                    TimeOfDay? pickedDateTime =
                                        await salesReportController
                                            .pickTime(context);
                                    String formattedDate = salesReportController
                                        .pickTimeFormatted(pickedDateTime);
                                    salesReportController.pickEndTime.text =
                                        formattedDate;
                                  },
                                ),
                              ],
                            ))),
                    20.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: CustomButton(
                        title: 'Générer le rapport',
                        textColor: Style.secondaryColor,
                        weight: 20,
                        background: Style.primaryColor,
                        radius: 3,
                        isLoading: salesReportController.isLoadingReport,
                        onPressed: () async {
                          // Get.toNamed(Routes.SALES_REPORT);
                          salesReportController.fetchOrdersReports();
                        },
                      ),
                    ),
                  ],
                ))));
  }
}
