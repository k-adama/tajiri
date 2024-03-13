import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/drawer_page.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/home.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';
import 'package:upgrader/upgrader.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final navigationController = Get.find<NavigationController>();
  late List<IndexedStackChild> list;
  void handleBottomNavBarTap(int index) {
    navigationController.selectIndexFunc(index);
  }

  @override
  void initState() {
    list = [
      IndexedStackChild(child: const HomeScreen()),
      IndexedStackChild(
        child: Container(),
      ),
      IndexedStackChild(
        child: Container(),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = AppHelpersCommon.getUserInLocalStorage();
    return GetBuilder<NavigationController>(
      builder: (navigationController) => UpgradeAlert(
        child: KeyboardDismisserUI(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(
                centerTitle: true,
                elevation: 0,
                title: Text(
                  "${user != null && user.restaurantUser != null ? user.restaurantUser![0].restaurant?.name : ""}",
                  style:
                      Style.interNormal(size: 16, color: Style.secondaryColor),
                ),
                iconTheme: const IconThemeData(color: Style.secondaryColor),
                backgroundColor: Style.white,
              ),
            ),
            drawer: const Drawer(
              backgroundColor: Style.white,
              child: DrawerPageComponent(),
            ),
            body: Column(
              children: [
                navigationController.selectIndex == 1 && user != null
                    ? Container() // const PosSearch()
                    : const SizedBox(),
                Expanded(
                  child: ProsteIndexedStack(
                    index: navigationController.selectIndex,
                    children: list,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Style.white,
              selectedItemColor: Style.secondaryColor,
              unselectedItemColor: Style.textGrey,
              type: BottomNavigationBarType.fixed,
              currentIndex: navigationController.selectIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              onTap: handleBottomNavBarTap,
              items: [
                BottomNavigationBarItem(
                    label: "Tableau de bord",
                    icon: SvgPicture.asset("assets/svgs/stats.svg"),
                    activeIcon:
                        SvgPicture.asset("assets/svgs/stats_active.svg")),
                BottomNavigationBarItem(
                    label: "POS",
                    icon: SvgPicture.asset("assets/svgs/POS.svg"),
                    activeIcon: SvgPicture.asset("assets/svgs/POS_active.svg")),
                BottomNavigationBarItem(
                    label: "Mes commandes",
                    icon: SvgPicture.asset("assets/svgs/Historic.svg"),
                    activeIcon:
                        SvgPicture.asset("assets/svgs/Historic_active.svg")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
