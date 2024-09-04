import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/sale_deposit_client/components/categorie_client.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/sale_deposit_client/components/client_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/search.text_field.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

class SaleDepositClientScreen extends StatefulWidget {
  const SaleDepositClientScreen({super.key});

  @override
  State<SaleDepositClientScreen> createState() =>
      _SaleDepositClientScreenState();
}

class _SaleDepositClientScreenState extends State<SaleDepositClientScreen> {
  String selectedCategory = 'Tous';
  final List<String> categorieNames = [
    'Tous',
    'Small business',
    'Middle Business',
    'Big Business',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFF0F7),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gestion des clients",
              style: Style.interBold(size: 20),
            ),
            16.verticalSpace,
            SearchTextField(
              hintText: "Rechercher un client",
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
                  return CategorieClientComponent(
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
            const ClientItemComponent(
              asset: "🥩",
              title: "Le comptoir Bar - Restaurant",
              description: "Cocody Ivoire Trade Center - 07 00 00 00 00",
            ),
            const ClientItemComponent(
              asset: "🍾",
              title: "Maquis la Luna",
              description: "Cocody Village Blockhauss - 07 00 00 00 00",
            ),
            const ClientItemComponent(
              asset: "🍕",
              title: "Maquis du Val",
              description: "Cocody Ivoire Trade Center - 07 00 00 00 00",
            ),
            const ClientItemComponent(
              asset: "🥩",
              title: "Le comptoir Bar - Restaurant",
              description: "Cocody Ivoire Trade Center - 07 00 00 00 00",
            ),
            const ClientItemComponent(
              asset: "🥩",
              title: "Le comptoir Bar - Restaurant",
              description: "Cocody Ivoire Trade Center - 07 00 00 00 00",
            ),
          ],
        ),
      )),
    );
  }
}
