import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/orders_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/deposit_add_paiement.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

TajiriDesignSystem tajiriDesignSystem = TajiriDesignSystem.instance;

class DepositClientDetailScreen extends StatefulWidget {
  const DepositClientDetailScreen({super.key});

  @override
  State<DepositClientDetailScreen> createState() =>
      _DepositClientDetailScreenState();
}

class _DepositClientDetailScreenState extends State<DepositClientDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            backgroundColor: Style.bgColor,
            body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Le Comptoir Bar & Restaurant",
                                  style: Style.interBold(size: 23),
                                ),
                                8.verticalSpace,
                                Text(
                                  "Middle Business",
                                  style: Style.interNormal(size: 16),
                                ),
                              ],
                            ),
                            36.verticalSpace,
                            IntrinsicHeight(
                              child: Wrap(
                                children: [
                                  const InfoClientCard(
                                    title: "Adresse",
                                    value: "Ivoire Trade Center",
                                  ),
                                  Container(
                                    height: 40,
                                    child: const VerticalDivider(
                                      thickness: 1,
                                    ),
                                  ),
                                  const InfoClientCard(
                                    title: "Contact",
                                    value: "07 98 97 46 07",
                                  ),
                                ],
                              ),
                            ),
                            24.verticalSpace,
                            const Divider(),
                            24.verticalSpace,
                            Row(
                              children: [
                                const Expanded(
                                  child: RecapInfoComponent(
                                    title: "commandes",
                                    value: "1485",
                                    description: "NBRE",
                                  ),
                                ),
                                16.horizontalSpace,
                                const Expanded(
                                  child: RecapInfoComponent(
                                    title: "A payer",
                                    value: "1485",
                                    description: "F CFA",
                                  ),
                                ),
                              ],
                            ),
                            30.verticalSpace,
                            const Text("Historique"),
                          ],
                        ),
                      ),
                    ),
                    SliverPinnedHeader(
                      child: Container(
                        color: Style.bgColor,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                              isScrollable: true,
                              indicator: const UnderlineTabIndicator(
                                borderSide: BorderSide(width: 2.5),
                                insets: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              labelStyle: Style.interNormal(),
                              tabs: const [
                                Tab(text: "Commande"),
                                Tab(text: "Paiement"),
                              ],
                            ),
                            const Divider(
                              height: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TabBarView(
                    children: [
                      ListView(
                        children: const [
                          ClientOrdersItemComponent(),
                          ClientOrdersItemComponent(),
                          ClientOrdersItemComponent(),
                          ClientOrdersItemComponent(),
                          ClientOrdersItemComponent(),
                        ],
                      ),
                      ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                              color: Style.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const OrderInfoHeaderComponent(),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                              color: Style.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const OrderInfoHeaderComponent(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          Positioned(
            bottom: 22,
            right: 70,
            left: 70,
            child: CustomButton(
              height: 48,
              background: tajiriDesignSystem.appColors.mainBlue500,
              title: "Enregistrer un paiement",
              onPressed: () {
                Get.to(const DepositAddPaimentScreen());
              },
            ),
          )
        ],
      ),
    );
  }
}

class RecapInfoComponent extends StatelessWidget {
  final String title;
  final String value;
  final String description;

  const RecapInfoComponent(
      {super.key,
      required this.title,
      required this.value,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Style.white,
          borderRadius: tajiriDesignSystem.appBorderRadius.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Style.interRegular(),
          ),
          16.verticalSpace,
          Text(
            value,
            style: Style.interBold(size: 26),
          ),
          8.verticalSpace,
          Text(
            description,
            style: Style.interRegular(
                color: tajiriDesignSystem.appColors.mainGrey400),
          ),
        ],
      ),
    );
  }
}

class InfoClientCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoClientCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Style.interNormal(
              color: tajiriDesignSystem.appColors.mainGrey400,
            ),
          ),
          Text(
            value,
            style: Style.interBold(),
          ),
        ],
      ),
    );
  }
}
