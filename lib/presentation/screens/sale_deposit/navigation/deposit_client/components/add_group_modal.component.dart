import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/custom_field.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class AddGroupModalComponent extends StatelessWidget {
  const AddGroupModalComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 6.h,
                width: 180,
                decoration: BoxDecoration(
                  color: Style.black,
                  borderRadius: BorderRadius.all(Radius.circular(40.r)),
                ),
              ),
            ),
            20.verticalSpace,
            Text(
              "Nouveau groupe",
              style: Style.interBold(size: 20),
            ),
            Text(
              "Créer une nouvelle catégorie de client",
              style: Style.interNormal(size: 14),
            ),
            36.verticalSpace,
            const Divider(thickness: 1),
            16.verticalSpace,
            CustomFieldWidget(
              title: 'Nom du groupe',
              hintText: "ex. grand compte",
              controller: TextEditingController(),
            ),
            16.verticalSpace,
            CustomFieldWidget(
              title: 'Description',
              isDescription: true,
              hintText: "Décrivez le groupe en quelques lignes",
              controller: TextEditingController(),
            ),
            36.verticalSpace,
            const Divider(thickness: 1),
            20.verticalSpace,
            CustomButton(
              height: 48,
              background: tajiriDesignSystem.appColors.mainBlue500,
              title: "Enregistrer le groupe",
              onPressed: () {
                Get.back();
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
