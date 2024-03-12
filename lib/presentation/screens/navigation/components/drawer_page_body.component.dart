import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/common/utils.common.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/drawer_body_list_row.dart';

class DrawerPageBodyComponent extends StatelessWidget {
  const DrawerPageBodyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppHelpersCommon.getUserInLocalStorage();

    bool? isShowStock =
        user?.role?.permissions?[0].inventory == true ? true : false;
    return Column(
      children: [
        ListTile(
          title: const DrawerBodyListRow(
            name: "Rapport  de ventes",
            emoji: "assets/svgs/rapport de vente.svg",
          ),
          onTap: () {
            // AppHelpers.showBottomSnackBar(context, const ProductInCart(),
            //     const Duration(milliseconds: 500), false);
            // Mixpanel.instance.track("View Sales report",
            //     properties: {"Date": DateTime.now().toString()});
            // Get.toNamed(Routes.SALES_REPORT_DATE_TIME_PICKER);
          },
        ),
        isShowStock
            ? ListTile(
                title: const DrawerBodyListRow(
                  name: "Stocks",
                  emoji: "assets/svgs/stock.svg",
                ),
                onTap: () {
                  // AppHelpers.showBottomSnackBar(context, const ProductInCart(),
                  //     const Duration(milliseconds: 500), false);
                  // Mixpanel.instance.track("View Stocks",
                  //     properties: {"Date": DateTime.now().toString()});
                  // Get.toNamed(Routes.STOCK);
                },
              )
            : Container(),
        ListTile(
          title: const DrawerBodyListRow(
            name: "Gestion des produits",
            emoji: "assets/svgs/Calque 1.svg",
          ),
          onTap: () {
            // AppHelpers.showBottomSnackBar(context, const ProductInCart(),
            //     const Duration(milliseconds: 500), false);
            // Mixpanel.instance.track("View Products",
            //     properties: {"Date": DateTime.now().toString()});
            // Get.toNamed(Routes.PRODUCTS);
          },
        ),
        if (checkListingType(user) == ListingType.waitress)
          ListTile(
            title: const DrawerBodyListRow(
              name: "Gestion des serveurs",
              emoji: "assets/svgs/waitress-gestion.svg",
            ),
            onTap: () {
              // AppHelpers.showBottomSnackBar(context, const ProductInCart(),
              //     const Duration(milliseconds: 500), false);
              // Mixpanel.instance.track("View Waitress",
              //     properties: {"Date": DateTime.now().toString()});
              // Get.toNamed(Routes.WAITRESS);
            },
          ),
        if (checkListingType(user) == ListingType.table)
          ListTile(
            title: const DrawerBodyListRow(
              name: "Gestion des tables",
              emoji: "assets/svgs/waitress-gestion.svg",
            ),
            onTap: () {
              // AppHelpers.showBottomSnackBar(context, const ProductInCart(),
              //     const Duration(milliseconds: 500), false);
              // Mixpanel.instance.track("View Tables",
              //     properties: {"Date": DateTime.now().toString()});
              // Get.toNamed(Routes.TABLE);
            },
          ),
        ListTile(
          title: const DrawerBodyListRow(
            name: "Tutoriels",
            emoji: "assets/svgs/icon_tuto.svg",
          ),
          onTap: () {
            // AppHelpers.showBottomSnackBar(context, const ProductInCart(),
            //     const Duration(milliseconds: 500), false);
            // Mixpanel.instance.track("View Tutoriels",
            //     properties: {"Date": DateTime.now().toString()});
            // Get.toNamed(Routes.TUTORIELS);
          },
        ),
      ],
    );
  }
}
