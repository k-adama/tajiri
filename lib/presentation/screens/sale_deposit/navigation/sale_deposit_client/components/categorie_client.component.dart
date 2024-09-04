import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/effects/animation_button.effect.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

class CategorieClientComponent extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final String name;
  const CategorieClientComponent(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimationButtonEffect(
        child: UnconstrainedBox(
          child: Container(
            constraints: const BoxConstraints(minWidth: 110),
            padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.r),
            margin: EdgeInsets.only(right: 8.r),
            decoration: BoxDecoration(
                borderRadius: tajiriDesignSystem.appBorderRadius.lg,
                color: isSelected
                    ? tajiriDesignSystem.appColors.mainBlue500
                    : tajiriDesignSystem.appColors.mainGrey100),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected
                      ? Style.white
                      : tajiriDesignSystem.appColors.mainGrey600,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategorieProductShimerComponent extends StatelessWidget {
  const CategorieProductShimerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: Container(
        constraints: const BoxConstraints(minWidth: 110),
        padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.r),
        margin: EdgeInsets.only(right: 8.r),
        decoration: BoxDecoration(
          borderRadius: tajiriDesignSystem.appBorderRadius.lg,
          color: Style.grey100,
        ),
      ),
    );
  }
}
