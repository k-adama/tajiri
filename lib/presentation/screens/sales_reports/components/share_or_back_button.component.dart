import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class SalesReportsShareOrBackButton extends StatelessWidget {
  final VoidCallback onTapShare;
  final VoidCallback onTapBack;
  const SalesReportsShareOrBackButton({
    super.key,
    required this.onTapShare,
    required this.onTapBack,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomButton(
                      title: 'Partager le rapport',
                      textColor: Style.secondaryColor,
                      weight: 20,
                      background: Style.primaryColor,
                      radius: 3,
                      onPressed: onTapShare,
                      /* () async {
                        /*final pdfFile = await PdfReportApi.generate(
                                    salesReportController.sales,
                                    salesReportController.total.value,
                                    salesReportController.startDate,
                                    salesReportController.endDate);
                                PdfApi.shareFile(pdfFile);*/
                      },*/
                    ),
                    InkWell(
                        onTap: onTapBack,
                        /* () {
                          Get.back();
                        },*/
                        child: SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Retour à la génération du rapport",
                              style: Style.interBold(
                                  size: 16,
                                  isUnderLine: true,
                                  color: Style.secondaryColor),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
