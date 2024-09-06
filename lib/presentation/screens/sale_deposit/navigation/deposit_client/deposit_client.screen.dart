import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/categorie_client.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/client_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/search.text_field.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

class DepositClientScreen extends StatefulWidget {
  const DepositClientScreen({super.key});

  @override
  State<DepositClientScreen> createState() => _DepositClientScreenState();
}

class _DepositClientScreenState extends State<DepositClientScreen> {
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
      backgroundColor: Style.bgColor,
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
            ClientItemComponent(
              onTap: () {
                Get.toNamed(Routes.DEPOSIT_CLIENT_DETAILS);
              },
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
