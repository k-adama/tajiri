import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_client/deposit_client.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/client_order_tab.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/client_paiement_tab.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/recap_info.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/deposit_add_paiement.screen.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class DepositClientDetailScreen extends StatefulWidget {
  const DepositClientDetailScreen({super.key});

  @override
  State<DepositClientDetailScreen> createState() =>
      _DepositClientDetailScreenState();
}

class _DepositClientDetailScreenState extends State<DepositClientDetailScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<DepositClientController>();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   Get.to(TabBarPaginationExample());
          // }),
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
                          Text(
                            "Historique",
                            style: Style.interBold(size: 20),
                          ),
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
                            controller: _tabController,
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
                  controller: _tabController,
                  children: [
                    ClientOrdersTabComponent(
                      tabController: _tabController,
                    ),
                    ClientPaiementTabComponent(
                      tabController: _tabController,
                    )
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
    );
  }
}
