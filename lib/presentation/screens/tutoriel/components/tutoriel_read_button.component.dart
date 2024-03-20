import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class TutorielReadButton extends StatelessWidget {
  final double bottom;
  final double right;
  final double containerWidth;
  final double containerHeight;
  final String svgAsset;
  final String buttonText;

  const TutorielReadButton({
    Key? key,
    required this.bottom,
    required this.right,
    required this.containerWidth,
    required this.containerHeight,
    required this.svgAsset,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
       final screenSize = MediaQuery.of(context).size;
    return Positioned(
      bottom: bottom.h,
      right: right.w,
      child: Container(
        width: containerWidth.w,
        height: containerHeight.h,
        decoration: BoxDecoration(
          color: Style.darker.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: Style.interBold(
                  color: Style.white,
                  isUnderLine: true,
                  underLineColor: Style.white,
                ),
              ),
              Container(
                width: (screenSize.width / 2) - 150.w,
                height: (screenSize.height / 2) - 10.h,
                child: SvgPicture.asset(svgAsset),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
