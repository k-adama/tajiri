import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class ProductApproShimmer extends StatelessWidget {
  const ProductApproShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        height: 100.h,
        width: double.infinity,
        color: Style.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width - 130,
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color:
                              Colors.white, // Background for image placeholder
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                    SizedBox(
                      width: (size.width - 130) * 0.70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: shimmerText(),
                          ),
                          8.verticalSpace,
                          shimmerText(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: (size.width - 125) / 4,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Style.lightBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Text(
                        "-",
                        style: Style.interBold(
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
      ),
    );
  }
}
