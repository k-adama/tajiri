import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/product.extension.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/categorie_food.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/modals/food_variant.modal.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/pos_search_bar.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/shimmer_product_list.widget.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/shop_product_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/product_in_cart.widget.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
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
    await posController.fetchProducts();
    posController.handleFilter('all', 'all');
    _controller.refreshCompleted();
  }

  void _onLoading(PosController posController) async {
    await posController.fetchProducts();
    posController.handleFilter('all', 'all');
    _controller.loadComplete();
  }

  addCart(Product product, PosController posController) {
    if (product.quantity == 0) {
      Mixpanel.instance.track("POS Product Out Stock Cliked", properties: {
        "Product name": product.name,
        "Product ID": product.id,
        "Category": product.category.name,
        "Selling Price": product.price
      });
      return;
    }

    if (product.hasVariants) {
      Mixpanel.instance.track("Product With Variant Cliked", properties: {
        "Product name": product.name,
        "Product ID": product.id,
        "Category": product.category.name,
        "Selling Price": product.price,
        "Stock Availability": product.quantity,
        "Number of variants categories": product.variants.length,
        "Average of variants by category": product.variants.length
      });

      AppHelpersCommon.showCustomModalBottomSheet(
        context: context,
        modal: FoodVariantModal(
          product: product,
        ),
        isDarkMode: false,
        isDrag: true,
        radius: 12,
      );
      return;
    }
    posController.addCart(context, product, null, 1, 0, false);
  }

  addCount(Product food, bool hasVariants, PosController posController) {
    if (hasVariants) {
      AppHelpersCommon.showCustomModalBottomSheet(
        context: context,
        modal: FoodVariantModal(
          product: food,
        ),
        isDarkMode: false,
        isDrag: true,
        radius: 12,
      );
      return;
    }
    if (posController.cartItemList
            .firstWhereOrNull((element) => element.productId == food.id)
            ?.quantity ==
        food.quantity) return;
    posController.addCount(context: context, productId: food.id.toString());
  }

  removeCount(Product food, bool hasVariants, PosController posController) {
    if (hasVariants) {
      AppHelpersCommon.showCustomModalBottomSheet(
        context: context,
        modal: FoodVariantModal(
          product: food,
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
          return Stack(
            children: [
              Column(
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
                            CategorieFoodComponent(
                                posController: posController),
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
                        ? const Expanded(child: ShimmerProductListWidget())
                        : Expanded(
                            child: posController.products.isEmpty
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
                                        itemCount:
                                            posController.products.length,
                                        itemBuilder: (context, index) {
                                          //get food
                                          final product =
                                              posController.products[index];

                                          // check if food is in cart
                                          final foodIsInCart = posController
                                              .cartItemList
                                              .map((item) => item.productId)
                                              .contains(product.id);

                                          return AnimationConfiguration
                                              .staggeredGrid(
                                            columnCount:
                                                posController.products.length,
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 375),
                                            child: ScaleAnimation(
                                              scale: 0.5,
                                              child: FadeInAnimation(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (!foodIsInCart) {
                                                      addCart(product,
                                                          posController);
                                                    } else {
                                                      addCount(
                                                          product,
                                                          product.hasVariants,
                                                          posController);
                                                    }
                                                  },
                                                  child:
                                                      ShopProductItemComponent(
                                                    product: product,
                                                    count: posController
                                                        .getQuantity(index),
                                                    isAdd: foodIsInCart,
                                                    addCount: () => addCount(
                                                        product,
                                                        product.hasVariants,
                                                        posController),
                                                    removeCount: () =>
                                                        removeCount(
                                                            product,
                                                            product.hasVariants,
                                                            posController),
                                                    addCart: () => addCart(
                                                        product, posController),
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
              if (posController.cartItemList.isNotEmpty)
                Positioned(
                  bottom: 22,
                  right: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Style.secondaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: const ProductInCartWidget(),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
