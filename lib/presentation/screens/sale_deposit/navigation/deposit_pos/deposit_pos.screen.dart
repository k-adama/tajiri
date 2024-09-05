import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_pos/deposit_pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/shop_product_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/components/deposit_categorie_food.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/shimmer_product_list.widget.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

class DepositPosScreen extends StatefulWidget {
  const DepositPosScreen({super.key});

  @override
  State<DepositPosScreen> createState() => _DepositPosScreenState();
}

class _DepositPosScreenState extends State<DepositPosScreen> {
  final RefreshController _controller = RefreshController();

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      body:
          GetBuilder<DepositPosController>(builder: (saleDepositposController) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  primary: false,
                  scrollDirection: Axis.vertical,
                  child: Stack(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DepositCategorieFoodComponent(
                          saleDepositPosController: saleDepositposController,
                        ),
                        Divider(
                          thickness: 1,
                          color: tajiriDesignSystem.appColors.mainGrey100,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 10.w),
                          child: Text(
                            "Tous les articles",
                            style: Style.interBold(size: 20),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
                Obx(() {
                  return saleDepositposController.productIsLoad.value
                      ? const Expanded(child: ShimmerProductListWidget())
                      : Expanded(
                          child: false
                              ? SvgPicture.asset(
                                  "assets/svgs/empty.svg",
                                  height: 300.h,
                                )
                              : AnimationLimiter(
                                  child: SmartRefresher(
                                    controller: _controller,
                                    enablePullDown: true,
                                    enablePullUp: false,
                                    onLoading: () {
                                      // _onLoading(saleDepositposController);
                                    },
                                    onRefresh: () {
                                      // _onRefresh(saleDepositposController);
                                    },
                                    child: GridView.builder(
                                      padding: EdgeInsets.only(
                                          right: 12.w,
                                          left: 12.w,
                                          bottom: 96.h,
                                          top: 24.r),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 0.66.r,
                                              crossAxisCount: 2,
                                              mainAxisExtent: 280.r),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return AnimationConfiguration
                                            .staggeredGrid(
                                          columnCount: 5,
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 375),
                                          child: ScaleAnimation(
                                            scale: 0.5,
                                            child: FadeInAnimation(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: ShopProductItemComponent(
                                                  product: null,
                                                  count: 5,
                                                  cardColor: Colors.transparent,
                                                  isAdd: false,
                                                  addCount: () {},
                                                  removeCount: () {},
                                                  addCart: () {},
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        );
                })
              ],
            ),
            // if (saleDepositposController.cartItemList.isNotEmpty)
            //   Positioned(
            //     bottom: 22,
            //     right: 15,
            //     left: 15,
            //     child: Container(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //       decoration: BoxDecoration(
            //           color: Style.secondaryColor,
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.2),
            //               spreadRadius: 0.5,
            //               blurRadius: 4,
            //               offset: const Offset(2.0, 2.0),
            //             ),
            //           ],
            //           borderRadius: BorderRadius.circular(5)),
            //     ),
            //   )
          ],
        );
      }),
    );
  }
}
