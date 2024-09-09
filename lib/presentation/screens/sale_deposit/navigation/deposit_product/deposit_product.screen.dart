import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/categorie_client.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_product/deposit_details_product.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/search.text_field.dart';

class DepositProductScreen extends StatefulWidget {
  const DepositProductScreen({super.key});

  @override
  State<DepositProductScreen> createState() => _DepositProductScreenState();
}

class _DepositProductScreenState extends State<DepositProductScreen> {
  String selectedCategory = 'Tous';
  final List<String> categorieNames = [
    'Tous',
    'Vin',
    'Champagne',
    'Whisky',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.bgColor,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gestion des produits",
              style: Style.interBold(size: 20),
            ),
            16.verticalSpace,
            SearchTextField(
              hintText: "Rechercher un produit",
              borderColor: tajiriDesignSystem.appColors.mainGrey200,
              backgroundColor: Colors.transparent,
              searchController: TextEditingController(),
            ),
            16.verticalSpace,
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categorieNames.length,
                itemBuilder: (context, index) {
                  final categoryName = categorieNames[index];
                  return CategorieCardDepositComponent(
                    onTap: () {
                      setState(() {
                        selectedCategory = categoryName;
                      });
                    },
                    isSelected: selectedCategory == categoryName,
                    name: categoryName,
                  );
                },
              ),
            ),
            16.verticalSpace,
            const DepositProductComponent(),
            8.verticalSpace,
            const DepositProductComponent(),
          ],
        ),
      )),
    );
  }
}

class DepositProductComponent extends StatelessWidget {
  const DepositProductComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(const DepositDetailsProduct());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/product_picture.jpg",
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Product name"),
                  5.verticalSpace,
                  Wrap(
                    children: [
                      ProductChips(
                        title: "12.000 FCFA",
                        color: tajiriDesignSystem.appColors.mainYellow500,
                        isbold: true,
                      ),
                      5.horizontalSpace,
                      ProductChips(
                        title: "Stock 20",
                        color: tajiriDesignSystem.appColors.mainGrey100,
                        isbold: false,
                      ),
                      5.horizontalSpace,
                      ProductChips(
                        title: "Casier",
                        color: tajiriDesignSystem.appColors.mainGrey100,
                        isbold: false,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_right_rounded)
          ],
        ),
      ),
    );
  }
}

class ProductChips extends StatelessWidget {
  final String title;
  final Color color;

  final bool isbold;

  const ProductChips(
      {super.key,
      required this.title,
      required this.color,
      required this.isbold});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: tajiriDesignSystem.appBorderRadius.xs,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        title,
        style:
            TextStyle(fontWeight: isbold ? FontWeight.w700 : FontWeight.w400),
      ),
    );
  }
}
