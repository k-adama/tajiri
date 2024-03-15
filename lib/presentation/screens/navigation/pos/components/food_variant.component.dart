import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/instance_manager.dart';

import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/update_count_product_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class FoodVariantComponent extends StatefulWidget {
  final List<FoodVariantEntity>? foodVariant;
  final FoodDataEntity food;
  const FoodVariantComponent({
    super.key,
    required this.foodVariant,
    required this.food,
  });

  @override
  State<FoodVariantComponent> createState() => _FoodVariantComponentState();
}

class _FoodVariantComponentState extends State<FoodVariantComponent> {
  final posController = Get.find<PosController>();
  addCart(FoodDataEntity food, FoodVariantEntity foodVariant) {
    if (food.quantity == 0) {
      return;
    }

    posController.addCart(context, food, foodVariant, 1, 0, false);
  }

  addCount(FoodDataEntity food, FoodVariantEntity foodVariant) {
    if (posController.cartItemList
            .firstWhereOrNull((item) =>
                item.variant != null && item.variant!.id == foodVariant.id)
            ?.quantity ==
        food.quantity) return;
    posController.addCount(
        context: context,
        foodId: food.id.toString(),
        foodVariantId: foodVariant.id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0.h,
      child: ListView.builder(
        itemCount: widget.foodVariant?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          FoodVariantEntity foodVariant = widget.foodVariant![index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200.w,
                      height: 50.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                foodVariant.name ?? '',
                                style: Style.interNormal(
                                  size: 13.sp,
                                  color: Style.titleDark,
                                ),
                              ),
                              Text(
                                "${foodVariant.price ?? ''}".currencyShort(),
                                style: Style.interNormal(
                                  size: 13.sp,
                                  color: Style.titleDark,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.food.quantity != 0
                                ? widget.food.quantity != 0
                                    ? '${widget.food.quantity ?? widget.food.type}  en stock'
                                    : 'Rupture'
                                : 'Rupture',
                            style: Style.interNormal(
                              size: 11.sp,
                              color: Style.dark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    (posController.cartItemList
                            .where((item) =>
                                item.variant != null &&
                                item.variant!.id == foodVariant.id)
                            .isNotEmpty)
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.r),
                              ),
                              color: Style.white,
                              border: Border.all(
                                color: Style.white,
                                width: 4.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                UpdateCountProductButton(
                                  iconData: Icons.remove,
                                  onTap: () {
                                    posController.removeCount(
                                      context: context,
                                      foodId: widget.food.id.toString(),
                                      foodVariantId: foodVariant.id,
                                    );
                                  },
                                ),
                                12.horizontalSpace,
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.w, left: 10.h),
                                  child: Text(
                                    '${posController.cartItemList.firstWhereOrNull((item) => item.variant != null && item.variant!.id == foodVariant.id)?.quantity ?? 0}',
                                    style: Style.interBold(
                                      size: 14.sp,
                                      color: Style.black,
                                    ),
                                  ),
                                ),
                                12.horizontalSpace,
                                UpdateCountProductButton(
                                  iconData: Icons.remove,
                                  onTap: () {
                                    addCount(widget.food, foodVariant);
                                  },
                                ),
                              ],
                            ),
                          )
                        : CustomButton(
                            background: Style.primaryColor,
                            title: "Ajouter",
                            radius: 3,
                            textColor: Style.secondaryColor,
                            onPressed: () {
                              addCart(widget.food, foodVariant);
                            },
                          ),
                  ],
                ),
                const Divider(),
                30.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
