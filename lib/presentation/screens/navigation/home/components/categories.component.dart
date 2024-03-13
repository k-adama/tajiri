import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/categorie_amount.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class CategoriesComponent extends StatefulWidget {
  final HomeController homeController;
  const CategoriesComponent({super.key, required this.homeController});

  @override
  State<CategoriesComponent> createState() => _CategoriesComponentState();
}

class _CategoriesComponentState extends State<CategoriesComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.homeController.categoriesAmount.isEmpty
          ? 100.h
          : widget.homeController.calculateContainerHeight(
              widget.homeController.categoriesAmount.length),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.h,
              child: Text(
                "Catégories ",
                style: Style.interBold(size: 18.sp, color: Style.titleDark),
              ),
            ),
            20.verticalSpace,
            SizedBox(
              height: widget.homeController.categoriesAmount.isEmpty
                  ? 10.h
                  : widget.homeController.calculateContainerHeight(
                          widget.homeController.categoriesAmount.length) -
                      50.h,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                itemCount: widget.homeController.categoriesAmount.length,
                itemBuilder: (context, index) {
                  final categoryAmount =
                      widget.homeController.categoriesAmount[index];
                  return CategorieAmountCard(
                    categoryAmountEntity: categoryAmount,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorieAmountCard extends StatelessWidget {
  final CategoryAmountEntity categoryAmountEntity;
  const CategorieAmountCard({super.key, required this.categoryAmountEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Style.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 30.w,
              height: 50.h,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Style.lightBlue),
              child: Center(
                child: Text(categoryAmountEntity.icon,
                    style: Style.interNormal(
                        size: 15.sp, color: Style.secondaryColor)),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70.w,
                  child: Text(
                    categoryAmountEntity.name,
                    style: Style.interBold(
                      size: 10.sp,
                      color: Style.dark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "${categoryAmountEntity.total}".notCurrency(),
                    style: Style.interBold(size: 10.sp, color: Style.darker),
                    children: const <TextSpan>[
                      TextSpan(
                          text: TrKeysConstant.splashFcfa,
                          style: TextStyle(color: Style.dark)),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
