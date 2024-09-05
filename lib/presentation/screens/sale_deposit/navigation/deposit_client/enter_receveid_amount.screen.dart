import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/means_paiement_entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/amount_to_paid.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class EnterReceveidAmountScreen extends StatefulWidget {
  final MeansOfPaymentEntity meansOfPaymentEntity;
  const EnterReceveidAmountScreen(
      {super.key, required this.meansOfPaymentEntity});

  @override
  State<EnterReceveidAmountScreen> createState() =>
      _EnterReceveidAmountScreenState();
}

class _EnterReceveidAmountScreenState extends State<EnterReceveidAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Saisir le montant reçu',
                      style: Style.interNormal(
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 150,
                        height: 40,
                        child: TextFormField(
                          controller: TextEditingController(),
                          cursorColor: Colors.black,
                          style: Style.interBold(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Style.brandColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TotalAmountToPaidComponent(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1.5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                title: "valider",
                textColor: Style.white,
                background: tajiriDesignSystem.appColors.mainBlue500,
                radius: 4,
                onPressed: () {},
              ),
            ),
            (MediaQuery.of(context).padding.bottom + 10).verticalSpace,
          ],
        ),
      ),
    );
  }
}
