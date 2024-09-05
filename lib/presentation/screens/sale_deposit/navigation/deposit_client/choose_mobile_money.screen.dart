import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/means_paiement_entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/amount_to_paid.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/enter_receveid_amount.screen.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class ChooseMobileMoneyScreen extends StatefulWidget {
  final Order? order;
  final MeansOfPaymentEntity mobileMeansOfPayment;

  const ChooseMobileMoneyScreen(
      {super.key, required this.order, required this.mobileMeansOfPayment});

  @override
  State<ChooseMobileMoneyScreen> createState() =>
      _ChooseMobileMoneyScreenState();
}

class _ChooseMobileMoneyScreenState extends State<ChooseMobileMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: widget.mobileMeansOfPayment.items!.map((e) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        EnterReceveidAmountScreen(meansOfPaymentEntity: e),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Style.grey100,
                            ),
                          ),
                          child: Center(
                            child: AppHelpersCommon.checkIsSvg(e.icon)
                                ? SvgPicture.asset(
                                    e.icon,
                                    width: 40,
                                    height: 40,
                                  )
                                : Image.asset(
                                    e.icon,
                                    width: 40,
                                    height: 40,
                                  ),
                          ),
                        ),
                        Text(
                          e.name,
                          style: Style.interNormal(),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 160),
              TotalAmountToPaidComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
