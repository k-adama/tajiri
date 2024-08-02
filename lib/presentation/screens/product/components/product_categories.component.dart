import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/category_tab_bar_item.component.dart';

class ProductCategoriesComponent extends StatefulWidget {
  const ProductCategoriesComponent({super.key});

  @override
  State<ProductCategoriesComponent> createState() =>
      _ProductCategoriesComponentState();
}

class _ProductCategoriesComponentState
    extends State<ProductCategoriesComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (productsController) => Column(
        children: [
          productsController.categories.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  padding: EdgeInsets.all(8.r),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                  height: 56.h,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: productsController.categories.length,
                      itemBuilder: (context, index) {
                        final selectedCategorie =
                            productsController.categories[index];
                        return CategoryTabBarItemComponent(
                          isActive: selectedCategorie.id ==
                              productsController.categoryId.value,
                          onTap: () {
                            productsController.handleFilter(
                                selectedCategorie.id, selectedCategorie.name);
                          },
                          title: selectedCategorie.name,
                        );
                      }),
                )
        ],
      ),
    );
  }
}
