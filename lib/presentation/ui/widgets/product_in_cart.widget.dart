import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/cart.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class ProductInCartWidget extends StatelessWidget {
  const ProductInCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(posController.quantityProduct()),
              Text("${posController.totalCartValue}".splashCurrency())
            ],
          ),
          CustomButton(
              isLoading: false,
              title: "Valider commande",
              textColor: Style.secondaryColor,
              background: Style.primaryColor,
              radius: 5,
              onPressed: () {
                AppHelpersCommon.showCustomModalBottomSheet(
                  context: context,
                  modal: const CartScreen(),
                  isDarkMode: false,
                  isDrag: true,
                  radius: 12,
                );
              }),
        ],
      ),
    );
  }
}
