import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/extensions/staff.extension.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/drawer_body_list_row.component.dart';

class DrawerPageBodyComponent extends StatelessWidget {
  const DrawerPageBodyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppHelpersCommon.getUserInLocalStorage();

    return Column(
      children: [
        ListTile(
          title: const DrawerBodyListRowComponent(
            name: "Rapport  de ventes",
            emoji: "assets/svgs/rapport de vente.svg",
          ),
          onTap: () {
            Mixpanel.instance.track("View Sales report",
                properties: {"Date": DateTime.now().toString()});
            Get.toNamed(Routes.SALES_REPORT_DATE_TIME_PICKER);
          },
        ),
        user.canViewInventory
            ? ListTile(
                title: const DrawerBodyListRowComponent(
                  name: "Stocks",
                  emoji: "assets/svgs/stock.svg",
                ),
                onTap: () {
                  Mixpanel.instance.track("View Stocks",
                      properties: {"Date": DateTime.now().toString()});
                  Get.toNamed(Routes.STOCK);
                },
              )
            : const SizedBox(),
        ListTile(
          title: const DrawerBodyListRowComponent(
            name: "Gestion des produits",
            emoji: "assets/svgs/Calque 1.svg",
          ),
          onTap: () {
            Mixpanel.instance.track("View Products",
                properties: {"Date": DateTime.now().toString()});
            Get.toNamed(Routes.PRODUCTS);
          },
        ),
        if (checkListingType(user) == ListingType.waitress)
          ListTile(
            title: const DrawerBodyListRowComponent(
              name: "Gestion des serveurs",
              emoji: "assets/svgs/waitress-gestion.svg",
            ),
            onTap: () {
              Mixpanel.instance.track("View Waitress",
                  properties: {"Date": DateTime.now().toString()});
              Get.toNamed(Routes.WAITRESS);
            },
          ),
        if (checkListingType(user) == ListingType.table)
          ListTile(
            title: const DrawerBodyListRowComponent(
              name: "Gestion des tables",
              emoji: "assets/svgs/waitress-gestion.svg",
            ),
            onTap: () {
              Mixpanel.instance.track("View Tables",
                  properties: {"Date": DateTime.now().toString()});
              Get.toNamed(Routes.TABLE);
            },
          ),
        ListTile(
          title: const DrawerBodyListRowComponent(
            name: "Réglages bluetooth",
            emoji: "assets/svgs/ic_bluetooth.svg",
          ),
          onTap: () {
            Mixpanel.instance.track("View Bluetooth",
                properties: {"Date": DateTime.now().toString()});
            Get.toNamed(Routes.SETTING_BLUETOOTH);
          },
        ),
        ListTile(
          title: const DrawerBodyListRowComponent(
            name: "Tutoriels",
            emoji: "assets/svgs/icon_tuto.svg",
          ),
          onTap: () {
            Mixpanel.instance.track("View Tutoriels",
                properties: {"Date": DateTime.now().toString()});
            Get.toNamed(Routes.TUTORIELS);
          },
        ),
      ],
    );
  }
}
