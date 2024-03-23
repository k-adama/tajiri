import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/edit_product_price.dart';

class ProductPriceModalComponent extends StatefulWidget {
  FoodDataEntity foodData;
  ProductPriceModalComponent({super.key, required this.foodData});

  @override
  State<ProductPriceModalComponent> createState() =>
      _ProductPriceModalComponentState();
}

class _ProductPriceModalComponentState
    extends State<ProductPriceModalComponent> {
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
                  EditProductPriceComponent(
                    foodData: widget.foodData,
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
