import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class AddCustomerModalComponent extends StatefulWidget {
  const AddCustomerModalComponent({super.key});

  @override
  State<AddCustomerModalComponent> createState() =>
      _AddCustomerModalComponentState();
}

class _AddCustomerModalComponentState extends State<AddCustomerModalComponent> {
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<PosController>(
        builder: (posController) => ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Style.white,
                      spreadRadius: 0,
                      blurRadius: 40,
                      offset: Offset(0, -2),
                    ),
                  ],
                  color: Style.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                width: double.infinity,
                child: KeyboardDismisserUI(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      8.verticalSpace,
                      Center(
                        child: Container(
                          height: 4.0,
                          width: 48.0,
                          decoration: const BoxDecoration(
                            color: Style.dragElement,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0), // Adjust radius as needed
                            ),
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nouveau client",
                              style: Style.interBold(size: 24.sp),
                            ),
                            Text(
                              "Ajouter un nouveau client",
                              style: Style.interNormal(
                                  size: 13.sp, color: Style.dark),
                            )
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      textField("Nom client ", null, "Entrez le nom",
                          customerNameController),
                      textField(
                        "Numéro de téléphone",
                        null,
                        "Entrez le Numéro de téléphone du client",
                        customerPhoneController,
                        inputType: TextInputType.number,
                      ),
                      10.verticalSpace,
                      CustomButton(
                        isLoading: posController.isLoadingCreateCustomer,
                        background: Style.primaryColor,
                        title: "Ajouter le client",
                        radius: 3,
                        textColor: Style.secondaryColor,
                        isLoadingColor: Style.secondaryColor,
                        onPressed: () async {
                          final customerLastname = customerNameController.text;
                          final customerPhone = customerPhoneController.text;

                          await posController.saveCustomers(
                            context,
                            customerLastname,
                            customerPhone,
                          );
                        },
                      ),
                      24.verticalSpace,
                    ],
                  ),
                )),
              )),
        ),
      ),
    );
  }

  Widget textField(String label, String? optionalLabel, String? hint,
      TextEditingController? controller,
      {TextInputType inputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "$label ${optionalLabel != null ? '($optionalLabel)' : ''}",
          style: Style.interBold(size: 18.sp),
        ),
        OutlinedBorderTextFormField(
          textController: controller,
          inputType: inputType,
          labelText: hint,
          onTap: () {},
          label: "",
          obscure: true,
          isFillColor: true,
          fillColor: Style.lightBlueT,
          differBorderColor: Style.lightBlueT,
          hintColor: Style.black,
          haveBorder: true,
          isInterNormal: false,
          borderRaduis: BorderRadius.circular(15),
          isCenterText: false,
        ),
      ],
    );
  }
}
