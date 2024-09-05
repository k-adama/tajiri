import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/categorie_client.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/search.text_field.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

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
          ],
        ),
      )),
    );
  }
}
