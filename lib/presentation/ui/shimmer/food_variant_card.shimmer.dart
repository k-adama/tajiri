import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class FoodVariantCardShimmer extends StatefulWidget {
  const FoodVariantCardShimmer({super.key});

  @override
  State<FoodVariantCardShimmer> createState() => _FoodVariantCardShimmerState();
}

class _FoodVariantCardShimmerState extends State<FoodVariantCardShimmer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
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
                    shimmerText(),
                    2.verticalSpace,
                    shimmerText(),
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
  }

  Widget shimmerText() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        height: 12.h,
        color: Colors.white,
      ),
    );
  }
}
