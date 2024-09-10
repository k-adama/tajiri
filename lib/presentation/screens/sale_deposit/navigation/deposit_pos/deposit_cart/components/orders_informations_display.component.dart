import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/local_cart_enties/bag_data.entity.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_pos/deposit_pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/deposit_cart/components/food_detail_modal.component.dart';

class OrdersInformationsDisplayComponent extends StatelessWidget {
  final DepositCartItem? cart;
  final VoidCallback? delete;
  const OrdersInformationsDisplayComponent({
    super.key,
    this.cart,
    this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositPosController>(builder: (depositPosController) {
      return Container(
        decoration: BoxDecoration(
            color: Style.white, borderRadius: BorderRadius.circular(2)),
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${cart?.name}",
                          style: Style.interNormal(size: 13.sp),
                        ),
                        2.verticalSpace,
                        Text(
                          "${cart?.price}".currencyLong(),
                          style: Style.interBold(
                            size: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: const BoxDecoration(
                        color: Style.white, shape: BoxShape.circle),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          "${cart!.quantity}",
                          style: Style.interBold(
                            size: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  20.horizontalSpace,
                  InkWell(
                    onTap: () async {
                      final res = depositPosController
                          .fieldModalProductToUpdateProductAndReturnSelectId(
                              context, cart?.itemId);

                      final result =
                          await AppHelpersCommon.showCustomModalBottomSheet(
                        context: context,
                        modal: FoodDetailModalComponent(
                          key: UniqueKey(),
                          isUpdateModal: true,
                          product: depositPosController.productDataInCart,
                          addCart: () {
                            // posController.updateCartItem(context,
                            //     posController.productDataInCart, cart?.itemId);

                            Get.close(0);
                          },
                          addCount: () {},
                          removeCount: () {},
                        ),
                        isDarkMode: false,
                        isDrag: true,
                        radius: 12,
                      );
                      depositPosController
                          .handleAddModalFoodInCartItemInitialState();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: tajiriDesignSystem.appColors.mainBlue500,
                            style: BorderStyle.solid,
                            width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          "modifier",
                          style: Style.interBold(
                              color: tajiriDesignSystem.appColors.mainBlue500,
                              size: 13.sp),
                        ),
                      ),
                    ),
                  ) // AddOrRemoveItemComponent(add: add!, remove: remove!)
                ],
              ),
            ),
            10.verticalSpace,
            Divider(
              height: 0.5.h,
            ),
            5.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: InkWell(
                onTap: delete,
                child: Text(
                  "Supprimer",
                  style: Style.interBold(
                      color: tajiriDesignSystem.appColors.mainBlue500,
                      underLineColor: tajiriDesignSystem.appColors.mainBlue500,
                      isUnderLine: true,
                      size: 10.sp),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
