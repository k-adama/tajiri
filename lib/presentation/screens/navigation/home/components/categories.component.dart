import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/category_amount_card.component.dart';

class CategoriesComponent extends StatefulWidget {
  const CategoriesComponent({super.key});

  @override
  State<CategoriesComponent> createState() => _CategoriesComponentState();
}

class _CategoriesComponentState extends State<CategoriesComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Catégories",
                style: Style.interBold(size: 18.sp, color: Style.titleDark),
              ),
              20.verticalSpace,
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3,
                  ),
                  itemCount: homeController.categoriesAmount.length,
                  itemBuilder: (context, index) {
                    final categoryAmount =
                        homeController.categoriesAmount[index];
                    return CategorieAmountCardComponent(
                      categoryAmountEntity: categoryAmount,
                    );
                  },
                );
              }),
              20.verticalSpace,
            ],
          ),
        ),
      );
    });
  }
}
