import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/edit_variant.component.dart';

class EditFoodVariantModal extends StatefulWidget {
  FoodVariantEntity foodVariant;
  EditFoodVariantModal({super.key, required this.foodVariant});

  @override
  State<EditFoodVariantModal> createState() => _EditFoodVariantModalState();
}

class _EditFoodVariantModalState extends State<EditFoodVariantModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          )),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.verticalSpace,
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                          color: Style.dragElement,
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.r))),
                    ),
                  ),
                  EditVariantComponent(
                    foodVariant: widget.foodVariant,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
