import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/drawer_page.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/select_waitress.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/home.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/orders/order.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/pos.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';
import 'package:upgrader/upgrader.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final navigationController = Get.find<NavigationController>();
  final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();

  late List<IndexedStackChild> list;
  void handleBottomNavBarTap(int index) {
    navigationController.selectIndexFunc(index);
  }

  @override
  void initState() {
    list = [
      IndexedStackChild(child: const HomeScreen()),
      IndexedStackChild(
        child: const PosScreen(),
      ),
      IndexedStackChild(
        child: const OrdersScreen(),
      ),
    ];
    super.initState();
  }

  Widget _buildUserDisplay() {
    final userType = checkListingType(user);
    final isWaitress = userType == ListingType.waitress;
    final isIndexValid = navigationController.selectIndex == 1 ||
        navigationController.selectIndex == 2;
    final hasUser = user != null;
    final restaurantName = restaurant?.name ?? "";

    if (hasUser) {
      if (isWaitress && isIndexValid) {
        return const SelectWaitressComponent();
      } else {
        return Text(
          restaurantName,
          style: Style.interNormal(size: 16, color: Style.secondaryColor),
        );
      }
    } else {
      return const SizedBox();
    }
  }
  /* Widget _buildUserDisplay() {
    // final isIndexValid = navigationController.selectIndex == 1 ||
    //     navigationController.selectIndex == 2;
    // final hasUser = user != null;
    final restaurantName = restaurant?.name ?? "";
    return Text(
      restaurantName,
      style: Style.interNormal(size: 16, color: Style.secondaryColor),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (navigationController) => UpgradeAlert(
        child: KeyboardDismisserUi(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(
                centerTitle: true,
                elevation: 0,
                title: _buildUserDisplay(),
                iconTheme: const IconThemeData(color: Style.secondaryColor),
                backgroundColor: Style.white,
              ),
            ),
            drawer: const Drawer(
              backgroundColor: Style.white,
              child: DrawerPageComponent(),
            ),
            body: ProsteIndexedStack(
              index: navigationController.selectIndex,
              children: list,
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
