import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/means_paiement_entity.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/choose_mobile_money.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/enter_receveid_amount.screen.dart';

class DepositAddPaimentScreen extends StatefulWidget {
  const DepositAddPaimentScreen({super.key});

  @override
  State<DepositAddPaimentScreen> createState() =>
      _DepositAddPaimentScreenState();
}

class _DepositAddPaimentScreenState extends State<DepositAddPaimentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Moyens de Paiement",
                    style: Style.interBold(size: 23),
                  ),
                  8.verticalSpace,
                  Text(
                    "Veuillez sélectionner un moyen de paiement.",
                    style: Style.interNormal(size: 16),
                  ),
                ],
              ),
              20.verticalSpace,
              ...MEANS_OF_PAYEMENT
                  .map((e) => GestureDetector(
                        onTap: () {
                          selectPaiement(e);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: tajiriDesignSystem.appColors.mainGrey50,
                            border: Border.all(
                              color: tajiriDesignSystem.appColors.mainGrey100,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: AppHelpersCommon.checkIsSvg(e.icon)
                                      ? SvgPicture.asset(
                                          e.icon,
                                          width: 30,
                                          height: 30,
                                          color: Colors.black,
                                        )
                                      : Image.asset(
                                          e.icon,
                                          width: 30,
                                          height: 30,
                                          color: Colors.black,
                                        ),
                                ),
                              ),
                              Text(
                                e.name,
                                style: Style.interNormal(size: 13),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.keyboard_arrow_right_rounded,
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  selectPaiement(MeansOfPaymentEntity e) {
    print("select Paiement $e");
    if (e.name == "Cash") {
      Get.to(
        EnterReceveidAmountScreen(meansOfPaymentEntity: e),
      );
    } else if (e.name == "TPE") {
      Get.to(
        EnterReceveidAmountScreen(meansOfPaymentEntity: e),
      );
    } else if (e.name == "Mobile") {
      Get.to(
        ChooseMobileMoneyScreen(
          order: null,
          mobileMeansOfPayment: e,
        ),
      );
    }
  }
}
