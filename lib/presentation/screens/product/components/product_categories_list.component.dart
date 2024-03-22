import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/product_categories.component.dart';

class ProductCategorieListComponent extends StatelessWidget {
  const ProductCategorieListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Text(
            "Liste des produits",
            style: Style.interBold(color: Style.darker),
          ),
        ),
        const ProductCategoriesComponent(),
      ],
    );
  }
}
