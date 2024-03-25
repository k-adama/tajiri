import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';

class FoodListComponent extends StatelessWidget {
  final String url;
  final String foodName;
  final String foodQuantity;
  final String foodCategorieName;
  final String foodPrice;

  const FoodListComponent({
    super.key,
    required this.url,
    required this.foodName,
    required this.foodQuantity,
    required this.foodCategorieName,
    required this.foodPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 315.w,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: CustomNetworkImageUi(
                        url: url,
                        height: 120.h,
                        width: double.infinity,
                        radius: 10.r,
                      ),
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            foodName,
                            overflow: TextOverflow.ellipsis,
                            style: Style.interBold(
                              size: 15.sp,
                              color: Style.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            productInformation("Stock $foodQuantity", 13.sp),
                            Text(
                              "| ",
                              style: Style.interNormal(
                                  color: Style.light, size: 13.sp),
                            ),
                            productInformation("$foodCategorieName ", 13.sp),
                            Text(
                              "| ",
                              style: Style.interNormal(
                                  color: Style.light, size: 13.sp),
                            ),
                            productInformation(foodPrice.currencyLong(), 12.sp),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Style.dark,
                size: 20.sp,
              )
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  Widget productInformation(String title, double size) {
    return SizedBox(
      width: 80.w,
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: Style.interBold(color: Style.dark, size: size),
      ),
    );
  }
}
