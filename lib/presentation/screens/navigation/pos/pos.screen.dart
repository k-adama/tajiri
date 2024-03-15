import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/modals/food_variant.modal.dart';
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
  final posController = Get.find<PosController>();

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    await posController.fetchFoods();
    posController.handleFilter('all', 'all');
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await posController.fetchFoods();
    posController.handleFilter('all', 'all');
    _controller.loadComplete();
  }

  addCart(FoodDataEntity food) {
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
            food.foodVariantCategory?[0]?.foodVariant?.length
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

  addCount(FoodDataEntity food) {
    if (food.foodVariantCategory != null &&
        food.foodVariantCategory!.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        backgroundColor: Style.lighter,
        body: Column(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              primary: false,
              scrollDirection: Axis.vertical,
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // categoriesWidget(context),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
                      child: Text(
                        "Tous les articles",
                        style: Style.interBold(),
                      ),
                    ),
                  ],
                )
              ]),
            ),
            posController.isProductLoading == true
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
                              onLoading: _onLoading,
                              onRefresh: _onRefresh,
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
                                  // check if food is in cart
                                  final isFoodInCart = posController
                                      .cartItemList
                                      .map((item) => item.id)
                                      .contains(food.id);
                                  // check if food has variants
                                  final hasVariants =
                                      food.foodVariantCategory != null &&
                                          food.foodVariantCategory!.isNotEmpty;

                                  return AnimationConfiguration.staggeredGrid(
                                    columnCount: posController.foods.length,
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: ScaleAnimation(
                                      scale: 0.5,
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!(posController.cartItemList
                                                .map((item) => item.id)
                                                .contains(posController
                                                    .foods[index].id))) {
                                              addCart(
                                                  posController.foods[index]);
                                            } else {
                                              addCount(
                                                  posController.foods[index]);
                                            }
                                          },
                                          child: ShopProductItemComponent(
                                            product: food,
                                            count: posController
                                                .getQuantity(index),
                                            isAdd: isFoodInCart,
                                            addCount: () => addCount(food),
                                            removeCount: () {
                                              if (hasVariants) {
                                                AppHelpersCommon
                                                    .showCustomModalBottomSheet(
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
                                            },
                                            addCart: () => addCart(food),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
