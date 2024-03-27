import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant_category.entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/modals/edit_food_variant.modal.dart';

class FoodVariantListComponent extends StatefulWidget {
  final FoodVariantCategoryEntity foodVariantCategory;
  const FoodVariantListComponent(
      {super.key, required this.foodVariantCategory});

  @override
  State<FoodVariantListComponent> createState() =>
      _FoodVariantListComponentState();
}

class _FoodVariantListComponentState extends State<FoodVariantListComponent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.foodVariantCategory.foodVariant!.length,
      itemBuilder: (BuildContext context, int index) {
        FoodVariantEntity foodVariant =
            widget.foodVariantCategory.foodVariant![index];
        return InkWell(
          onTap: () {
            AppHelpersCommon.showCustomModalBottomSheet(
              context: context,
              modal: EditFoodVariantModal(foodVariant: foodVariant),
              isDarkMode: false,
              isDrag: true,
              radius: 12.r,
            );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Style.lightBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${foodVariant.name}",
                          style: Style.interBold(
                            size: 14.sp,
                            color: Style.black,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          "${foodVariant.price}".currencyLong(),
                          style: Style.interNormal(
                            size: 12.sp,
                            color: Style.darker,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 24.w,
                      height: 24.h,
                      child: SvgPicture.asset("assets/svgs/Create.svg"),
                    )
                  ],
                ),
              ), // Adjust the height as needed
            ),
          ),
        );
      },
    );
  }
}
