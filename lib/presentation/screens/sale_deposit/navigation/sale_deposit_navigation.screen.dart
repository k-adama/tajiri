import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/sale_deposit_navigation/sale_deposit_navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/sale_deposit_client/sale_deposit_client.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/sale_deposit_pos/sale_deposit_pos.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/sale_deposit_product/sale_deposit_product.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';
import 'package:upgrader/upgrader.dart';

TajiriDesignSystem tajiriDesignSystem = TajiriDesignSystem.instance;

class SaleDepositNavigationScreen extends StatefulWidget {
  const SaleDepositNavigationScreen({super.key});

  @override
  State<SaleDepositNavigationScreen> createState() =>
      _SaleDepositNavigationScreenState();
}

class _SaleDepositNavigationScreenState
    extends State<SaleDepositNavigationScreen> {
  late List<IndexedStackChild> list;

  @override
  void initState() {
    list = [
      IndexedStackChild(child: const SaleDepositClientScreen()),
      IndexedStackChild(
        child: const SaleDepositPosScreen(),
      ),
      IndexedStackChild(
        child: const SaleDepositProductScreen(),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaleDepositNavigationController>(
      builder: (saleDepositNavigationController) => UpgradeAlert(
        child: KeyboardDismisserUi(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(
                centerTitle: true,
                elevation: 0,
                iconTheme: const IconThemeData(color: Style.secondaryColor),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            drawer: Drawer(
              backgroundColor: Style.white,
              child: Container(),
            ),
            body: ProsteIndexedStack(
              index: saleDepositNavigationController.selectIndex,
              children: list,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Style.white,
              selectedItemColor: Style.secondaryColor,
              unselectedItemColor: Style.textGrey,
              type: BottomNavigationBarType.fixed,
              currentIndex: saleDepositNavigationController.selectIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              onTap: (index) {
                saleDepositNavigationController.selectIndexFunc(index);
              },
              items: [
                BottomNavigationBarItem(
                  label: "Clients",
                  icon: SvgPicture.asset("assets/svgs/choose_role_client.svg"),
                  activeIcon: SvgPicture.asset(
                    "assets/svgs/choose_role_client.svg",
                    color: tajiriDesignSystem.appColors.mainBlue500,
                  ),
                ),
                BottomNavigationBarItem(
                    label: "POS",
                    icon: SvgPicture.asset(
                      "assets/svgs/sale_deposit_pos.svg",
                    ),
                    activeIcon: SvgPicture.asset(
                      "assets/svgs/sale_deposit_pos.svg",
                      color: tajiriDesignSystem.appColors.mainBlue500,
                    )),
                BottomNavigationBarItem(
                  label: "Produits",
                  icon: SvgPicture.asset(
                    "assets/svgs/sale_deposit_product.svg",
                  ),
                  activeIcon: SvgPicture.asset(
                    "assets/svgs/sale_deposit_product.svg",
                    color: tajiriDesignSystem.appColors.mainBlue500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
