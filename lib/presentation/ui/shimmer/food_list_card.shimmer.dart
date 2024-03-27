import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class FoodListCardShimmer extends StatelessWidget {
  const FoodListCardShimmer({
    super.key,
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
                child: Row(
                  children: [
                    SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 150.w,
                            height: 13.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            shimmerText(),
                            separator(),
                            shimmerText(),
                            separator(),
                            shimmerText(),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  Widget shimmerText() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        constraints: BoxConstraints(maxWidth: 80.w),
        height: 10.h,
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
