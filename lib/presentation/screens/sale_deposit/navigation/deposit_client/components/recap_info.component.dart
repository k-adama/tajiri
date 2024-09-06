import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

class RecapInfoComponent extends StatelessWidget {
  final String title;
  final String value;
  final String description;

  const RecapInfoComponent(
      {super.key,
      required this.title,
      required this.value,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Style.white,
          borderRadius: tajiriDesignSystem.appBorderRadius.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Style.interRegular(),
          ),
          16.verticalSpace,
          Text(
            value,
            style: Style.interBold(size: 26),
          ),
          8.verticalSpace,
          Text(
            description,
            style: Style.interRegular(
                color: tajiriDesignSystem.appColors.mainGrey400),
          ),
        ],
      ),
    );
  }
}

class InfoClientCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoClientCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Style.interNormal(
              color: tajiriDesignSystem.appColors.mainGrey400,
            ),
          ),
          Text(
            value,
            style: Style.interBold(),
          ),
        ],
      ),
    );
  }
}
