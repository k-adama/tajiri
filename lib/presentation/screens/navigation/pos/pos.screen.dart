import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/categorie_food.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/modals/food_variant.modal.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/pos_search_bar.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/shimmer_product_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/shop_product_item.component.dart';
import 'package:upgrader/upgrader.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final RefreshController _controller = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh(PosController posController) async {
    await posController.fetchFoods();
    posController.handleFilter('all', 'all');
    _controller.refreshCompleted();
  }

  void _onLoading(PosController posController) async {
    await posController.fetchFoods();
    posController.handleFilter('all', 'all');
    _controller.loadComplete();
  }

  addCart(FoodDataEntity food, PosController posController) {
    if (food.quantity == 0) {
      Mixpanel.instance.track("POS Product Out Stock Cliked", properties: {
        "Product name": food.name,
        "Product ID": food.id,
        "Category": food.category?.name,
        "Selling Price": food.price
      });
      return;
    }
    final hasVariants = food.foodVariantCategory != null &&
        food.foodVariantCategory!.isNotEmpty;
    if (hasVariants) {
      Mixpanel.instance.track("Product With Variant Cliked", properties: {
        "Product name": food.name,
        "Product ID": food.id,
        "Category": food.category?.name,
        "Selling Price": food.price,
        "Stock Availability": food.quantity,
        "Number of variants categories": food.foodVariantCategory?.length,
        "Average of variants by category":
            food.foodVariantCategory?[0].foodVariant?.length
      });

      AppHelpersCommon.showCustomModalBottomSheet(
        context: context,
        modal: FoodVariantModal(
          food: food,
        ),
        isDarkMode: false,
        isDrag: true,
        radius: 12,
      );
      return;
    }
    posController.addCart(context, food, null, 1, 0, false);
  }

  addCount(FoodDataEntity food, bool hasVariants, PosController posController) {
    if (hasVariants) {
      AppHelpersCommon.showCustomModalBottomSheet(
        context: context,
        modal: FoodVariantModal(
          food: food,
        ),
        isDarkMode: false,
        isDrag: true,
        radius: 12,
      );
      return;
    }
    if (posController.cartItemList
            .firstWhereOrNull((element) => element.id == food.id)
            ?.quantity ==
        food.quantity) return;
    posController.addCount(context: context, foodId: food.id.toString());
  }

  removeCount(
      FoodDataEntity food, bool hasVariants, PosController posController) {
    if (hasVariants) {
      AppHelpersCommon.showCustomModalBottomSheet(
        context: context,
        modal: FoodVariantModal(
          food: food,
        ),
        isDarkMode: false,
        isDrag: true,
        radius: 12,
      );
      return;
    }
    posController.removeCount(
      context: context,
      foodId: food.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        backgroundColor: Style.lighter,
        body: GetBuilder<PosController>(builder: (posController) {
          return Column(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                primary: false,
                scrollDirection: Axis.vertical,
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PosSearchComponent(posController: posController),
                      if (posController.categories.isNotEmpty)
                        CategorieFoodComponent(posController: posController),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 10.w),
                        child: Text(
                          "Tous les articles",
                          style: Style.interBold(),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              Obx(() {
                return posController.isProductLoading.value
                    ? const Expanded(child: ShimmerProductListComponent())
                    : Expanded(
                        child: posController.foods.isEmpty
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
                                    _onLoading(posController);
                                  },
                                  onRefresh: () {
                                    _onRefresh(posController);
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
                                    itemCount: posController.foods.length,
                                    itemBuilder: (context, index) {
                                      //get food
                                      final food = posController.foods[index];
                                      // check if food has variants
                                      final hasVariants =
                                          food.foodVariantCategory != null &&
                                              food.foodVariantCategory!
                                                  .isNotEmpty;

                                      // check if food is in cart
                                      final foodIsInCart = posController
                                          .cartItemList
                                          .map((item) => item.id)
                                          .contains(food.id);

                                      return AnimationConfiguration
                                          .staggeredGrid(
                                        columnCount: posController.foods.length,
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: ScaleAnimation(
                                          scale: 0.5,
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (!foodIsInCart) {
                                                  addCart(food, posController);
                                                } else {
                                                  addCount(food, hasVariants,
                                                      posController);
                                                }
                                              },
                                              child: ShopProductItemComponent(
                                                product: food,
                                                count: posController
                                                    .getQuantity(index),
                                                isAdd: foodIsInCart,
                                                addCount: () => addCount(food,
                                                    hasVariants, posController),
                                                removeCount: () => removeCount(
                                                    food,
                                                    hasVariants,
                                                    posController),
                                                addCart: () => addCart(
                                                    food, posController),
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
          );
        }),
      ),
    );
  }
}
