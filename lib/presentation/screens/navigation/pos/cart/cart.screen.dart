import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/cart/cart.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/select_table.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/select_waitress.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/add_product_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/cart_order_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  Timer? timer;
  final PosController posController = Get.find();
  final user = AppHelpersCommon.getUserInLocalStorage();
  final controller = Get.put(CartController());
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    timer?.cancel();
    super.deactivate();
  }

  addCount(MainItemEntity food) {
    if (posController.products
            .firstWhereOrNull((element) => element.id == food.productId)
            ?.quantity ==
        food.quantity) return;
    posController.addCount(
        context: context, productId: food.productId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Style.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          width: double.infinity,
          height: screenSize.height - 100.h,
          child: Obx(
            () => Column(
              children: [
                10.verticalSpace,
                Center(
                  child: Container(
                    height: 4.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                        color: Style.white,
                        borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      14.verticalSpace,
                                      Text(
                                        "TOTAL",
                                        style: Style.interNormal(
                                          size: 14,
                                          color: Style.light,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  '${posController.totalCartValue}',
                                              style: Style.interBold(
                                                size: 22,
                                                color: Style.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "/FCFA",
                                              style: Style.interNormal(
                                                size: 8,
                                                color: Style.light,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  posController.currentOrder?.id != null
                                      ? const SizedBox()
                                      : 80.horizontalSpace,
                                  posController.currentOrder?.id != null
                                      ? const SizedBox()
                                      : checkListingType(user) ==
                                              ListingType.waitress
                                          ? const SelectWaitressComponent()
                                          : checkListingType(user) ==
                                                  ListingType.table
                                              ? const SelectTableComponent()
                                              : const SizedBox(),
                                ],
                              ),
                            ),
                            if (posController.currentOrder?.id != null)
                              AddProductButtonComponent(
                                onTap: () {
                                  if (posController.currentOrder?.id != null) {
                                    Get.close(1);
                                    navigationController.selectIndexFunc(1);
                                  }
                                },
                              )
                          ],
                        ),
                      ),
                      14.verticalSpace,
                      const Divider(),
                      SizedBox(
                        height: screenSize.height / 2,
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            shrinkWrap: true,
                            itemCount: posController.cartItemList.length,
                            itemBuilder: (context, index) {
                              List<MainItemEntity> cartItemListSort =
                                  posController
                                      .getSortList(posController.cartItemList);

                              final cartItem = cartItemListSort[index];
                              return CartOrderItemComponent(
                                add: () => addCount(cartItem),
                                remove: () => posController.removeCount(
                                  context: context,
                                  foodId: cartItem.productId.toString(),
                                  foodVariantId:
                                      cartItem.variant?.id.toString(),
                                ),
                                cartItem: cartItem,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: bottomWidget(context, posController),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(BuildContext context, PosController posController) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 24.h,
                right: 16.w,
                left: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    isLoading: posController.isAddAndRemoveLoading,
                    background: Style.secondaryColor,
                    title: "Enregistrer",
                    textColor: Style.white,
                    isLoadingColor: Style.white,
                    haveBorder: false,
                    radius: 5,
                    onPressed: () {
                      final arguments = {
                        "waitressId": posController.waitressCurrentId,
                        "tableId": posController.tableCurrentId
                      };

                      Get.toNamed(
                        Routes.CART_SAVE,
                        arguments: arguments,
                        preventDuplicates: false,
                      );
                    },
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: CustomButton(
                    isLoading: posController.isAddAndRemoveLoading,
                    background: Style.primaryColor,
                    title: "Payer",
                    textColor: Style.secondaryColor,
                    isLoadingColor: Style.secondaryColor,
                    radius: 5,
                    haveBorder: false,
                    onPressed: () {
                      final arguments = {
                        "waitressId": posController.waitressCurrentId,
                        "tableId": posController.tableCurrentId
                      };
                      Get.toNamed(
                        Routes.CART_PAID,
                        arguments: arguments,
                        preventDuplicates: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
