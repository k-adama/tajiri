import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/add_icon.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/deposit_client.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/deposit_pos.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_product/deposit_product.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';
import 'package:upgrader/upgrader.dart';

class DepositNavigationScreen extends StatefulWidget {
  const DepositNavigationScreen({super.key});

  @override
  State<DepositNavigationScreen> createState() =>
      _DepositNavigationScreenState();
}

class _DepositNavigationScreenState extends State<DepositNavigationScreen> {
  late List<IndexedStackChild> list;

  @override
  void initState() {
    list = [
      IndexedStackChild(child: const DepositClientScreen()),
      IndexedStackChild(
        child: const DepositPosScreen(),
      ),
      IndexedStackChild(
        child: const DepositProductScreen(),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositNavigationController>(
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
                actions: [
                  if (saleDepositNavigationController.selectIndex != 1)
                    Center(
                      child: AddIconComponent(
                        onTap: saleDepositNavigationController.addIconTap,
                      ),
                    ),
                ],
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
