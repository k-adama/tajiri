import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/components/tutoriel_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/product_in_cart.widget.dart';

class TutorielScreen extends StatefulWidget {
  const TutorielScreen({super.key});

  @override
  State<TutorielScreen> createState() => _TutorielScreenState();
}

class _TutorielScreenState extends State<TutorielScreen> {
  final PosController posController = Get.find();
  final NavigationController navigationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (posController.cartItemList.isEmpty ||
                navigationController.selectIndex != 1) {
              AppHelpersCommon.showBottomSnackBar(
                  context,
                  const ProductInCartWidget(),
                  const Duration(milliseconds: 500),
                  false);
            } else {
              AppHelpersCommon.showBottomSnackBar(
                context,
                const ProductInCartWidget(),
                const Duration(days: 6000000000000000),
                true,
              );
            }
          },
        ),
      ),
      body: const TutorielListComponent(),
    );
  }
}
