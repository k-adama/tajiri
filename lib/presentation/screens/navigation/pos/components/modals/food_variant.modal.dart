import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/food_variant.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class FoodVariantModal extends StatefulWidget {
  final Product food;
  const FoodVariantModal({super.key, required this.food});

  @override
  State<FoodVariantModal> createState() => _FoodVariantModalState();
}

class _FoodVariantModalState extends State<FoodVariantModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Style.bgGrey.withOpacity(0.96),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CustomNetworkImageUi(
                      url: widget.food.imageUrl!,
                      height: 300.h,
                      width: double.infinity,
                      radius: 10.r,
                      isRaduisTopLef: true,
                    ),
                    Positioned(
                      top: 10.0,
                      left: 0.0,
                      right: 0.0,
                      child: Center(
                        child: Container(
                          height: 4.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                              color: Style.dragElement,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.r))),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 15,
                        left: 10,
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                              color: Style.white,
                              borderRadius: BorderRadius.circular(3)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                '${widget.food.price!}'.currencyLong(),
                                style: Style.interNormal(size: 11),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
                24.verticalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.food.variants![0].name!,
                            style: Style.interBold(size: 20.sp),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    FoodVariantComponent(
                      foodVariant: widget.food.variants,
                      food: widget.food,
                    ),
                  ],
                ),
                10.verticalSpace,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
