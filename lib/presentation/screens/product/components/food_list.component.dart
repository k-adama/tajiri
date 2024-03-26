import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';

class FoodListComponent extends StatelessWidget {
  final String url;
  final VoidCallback onTap;
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
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              productInformation("Stock $foodQuantity", 13.sp),
                              separator(),
                              productInformation(
                                "$foodCategorieName ",
                                12.sp,
                                isDescription: true,
                              ),
                              separator(),
                              productInformation(
                                isDescription: true,
                                foodPrice.currencyLong(),
                                12.sp,
                              ),
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
      ),
    );
  }

  Widget productInformation(String title, double size,
      {bool isDescription = false}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 80.w),
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: isDescription
            ? Style.interBold(color: Style.dark, size: size).copyWith(
                fontWeight: FontWeight.w400,
              )
            : Style.interBold(color: Style.dark, size: size),
      ),
    );
  }

  Widget separator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Text(
        "| ",
        style: Style.interNormal(color: Style.light, size: 13.sp),
      ),
    );
  }
}
