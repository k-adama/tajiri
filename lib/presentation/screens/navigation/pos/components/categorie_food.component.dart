import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/categorie_item.button.dart';

class CategorieFoodComponent extends StatelessWidget {
  final PosController posController;
  const CategorieFoodComponent({super.key, required this.posController});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final categories = posController.categories;
    return Container(
      width: double.infinity,
      color: Style.white,
      height: (screenSize.height / 3) - 150.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
        child: GetBuilder<PosController>(builder: (_) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, index) {
                print(
                    "${categories[index].name}  ${categories[index].imageUrl}");

                return CategorieItemButton(
                  onTap: () {
                    posController.handleFilter(
                        categories[index].id, categories[index].name);
                  },
                  isSelect:
                      categories[index].id == posController.categoryId.value,
                  asset: categories[index].imageUrl,
                  description: categories[index].name.toString(),
                );
              });
        }),
      ),
    );
  }
}
