import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_pos/sale_deposit_pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/categorie_item.button.dart';

class SaleDepositCategorieFoodComponent extends StatelessWidget {
  final SaleDepositPosController saleDepositPosController;
  const SaleDepositCategorieFoodComponent(
      {super.key, required this.saleDepositPosController});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: (screenSize.height / 3) - 180.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: GetBuilder<SaleDepositPosController>(builder: (_) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: saleDepositPosController.categories.length,
              itemBuilder: (BuildContext context, index) {
                final categorie = saleDepositPosController.categories[index];

                return CategorieItemButton(
                  onTap: () {
                    saleDepositPosController.handleFilter(
                      categorie.id,
                      categorie.description,
                    );
                  },
                  cardSelectedColor: Style.secondaryColor,
                  isSelect:
                      saleDepositPosController.categoryId.value == categorie.id,
                  asset: categorie.asset,
                  description: categorie.description,
                );
              });
        }),
      ),
    );
  }
}

class SaleDepositCategorieFood {
  final String id;
  final String asset;
  final String description;

  SaleDepositCategorieFood(
      {required this.asset, required this.description, required this.id});
// Override the equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SaleDepositCategorieFood) return false;
    return id == other.id;
  }

  // Override hashCode to be consistent with == operator
  @override
  int get hashCode => id.hashCode;
  static final categories = [
    SaleDepositCategorieFood(asset: "📄", description: "Tous", id: 'all'),
    SaleDepositCategorieFood(
        asset: "📄", description: "Poisson", id: 'Poisson'),
    SaleDepositCategorieFood(
        asset: "📄", description: "Garniture", id: 'Garniture'),
    SaleDepositCategorieFood(asset: "📄", description: "Viande", id: 'Viande'),
    SaleDepositCategorieFood(
        asset: "📄", description: "Boisson", id: 'Boisson'),
  ];
}
