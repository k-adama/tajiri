import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';

class ClientItemComponent extends StatelessWidget {
  final String asset;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const ClientItemComponent(
      {super.key,
      required this.asset,
      required this.title,
      required this.description,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Style.white,
            borderRadius: tajiriDesignSystem.appBorderRadius.sm,
          ),
          child: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  asset,
                  style: Style.interBold(size: 30),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Style.interBold(size: 16),
                    ),
                    5.verticalSpace,
                    Text(
                      description,
                      style: Style.interRegular(
                        color: tajiriDesignSystem.appColors.mainGrey500,
                      ),
                    ),
                  ],
                ),
              ),
              5.horizontalSpace,
              const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
