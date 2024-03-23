import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/components/gender_selection_component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class FormAddWaitressComponent extends StatefulWidget {
  const FormAddWaitressComponent({super.key});

  @override
  State<FormAddWaitressComponent> createState() =>
      _FormAddWaitressComponentState();
}

class _FormAddWaitressComponentState extends State<FormAddWaitressComponent> {
  WaitressController waitressController = Get.find();
  void selectGender(String gender) {
    setState(() {
      waitressController.selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WaitressController>(
        builder: (_waitressController) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                headerText(),
                24.verticalSpace,
                Text(
                  "Sexe",
                  style: Style.interBold(size: 16.sp, color: Style.darker),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    GenderSelectionComponent(
                        text: 'Homme',
                        iconPath: 'assets/svgs/noto_man.svg',
                        onTap: () => selectGender('MALE'),
                        isSelected:
                            _waitressController.selectedGender == 'MALE'),
                    SizedBox(width: 16.0.w),
                    GenderSelectionComponent(
                        text: 'Femme',
                        iconPath: 'assets/svgs/noto_woman.svg',
                        onTap: () => selectGender('FEMALE'),
                        isSelected:
                            _waitressController.selectedGender == 'FEMALE'),
                  ],
                ),
                textField("Nom", null, "Nom du serveur",
                    nameValue: _waitressController.waitressName.text),
                24.verticalSpace,
                Container(
                  height: 45.h,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: CustomButton(
                    isLoading: waitressController.isLoadingCreateWaitress,
                    background: Style.primaryColor,
                    title: "Créer et ajouter le serveur",
                    textColor: Style.secondaryColor,
                    isLoadingColor: Style.secondaryColor,
                    radius: 5,
                    onPressed: () {
                      waitressController.handleCreateWaitress(context);
                    },
                  ),
                ),
              ],
            ));
  }

  Widget textField(String label, String? optionalLabel, String? hint,
      {String? nameValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Text(
          "$label ${optionalLabel != null ? '($optionalLabel)' : ''}",
          style: Style.interBold(size: 16.sp),
        ),
        4.verticalSpace,
        OutlinedBorderTextFormField(
          labelText: hint,
          textController: waitressController.waitressName,
          onTap: () {},
          label: "",
          obscure: true,
          isFillColor: true,
          fillColor: Style.lightBlueT,
          differBorderColor: Style.lightBlueT,
          hintColor: Style.black,
          haveBorder: true,
          isInterNormal: false,
          borderRaduis: BorderRadius.circular(10),
          isCenterText: false,
          // onChanged: onChange,
        ),
      ],
    );
  }

  Widget headerText() {
    String headerText = "Nouveau serveur";
    String descriptionText = "Enregistrer un nouveau serveur";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerText,
          style: Style.interBold(size: 20.sp, color: Style.darker),
        ),
        SizedBox(height: 8.h),
        Text(
          descriptionText,
          style: Style.interNormal(size: 16.sp, color: Style.darker),
        ),
      ],
    );
  }
}
