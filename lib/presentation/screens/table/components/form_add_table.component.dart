import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/custom_field.text_field.dart';

class FormAddTableComponent extends StatefulWidget {
  const FormAddTableComponent({super.key});

  @override
  State<FormAddTableComponent> createState() => _FormAddTableComponentState();
}

class _FormAddTableComponentState extends State<FormAddTableComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableController>(
      builder: (tableController) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          headerText(),
          15.verticalSpace,
          CustomTextField(
            label: 'Nom',
            optionalLabel: null,
            hint: 'Nom de la table',
            onChange: (text) {
              tableController.setTableName(text);
            },
            keyboardType: TextInputType.text,
          ),
          CustomTextField(
            label: 'Description',
            optionalLabel: null,
            hint: 'Description',
            onChange: (text) {
              tableController.setTableDescription(text);
            },
            keyboardType: TextInputType.multiline,
          ),
          CustomTextField(
            label: 'Nombre de siège',
            optionalLabel: null,
            hint: 'Nombre de place',
            onChange: (text) {
              tableController.setTableNumberPlace(text);
            },
            keyboardType: TextInputType.number,
          ),
          24.verticalSpace,
          Container(
            height: 45.h,
            margin: const EdgeInsets.only(bottom: 30),
            child: CustomButton(
              isLoading: tableController.isLoadingTable,
              background: Style.primaryColor,
              title: "Créer et ajouter la table",
              textColor: Style.secondaryColor,
              isLoadingColor: Style.secondaryColor,
              radius: 5,
              onPressed: () {
                tableController.saveTable(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget headerText() {
    String headerText = "Nouvelle table";
    String descriptionText = "Enregistrer une nouvelle table";

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
