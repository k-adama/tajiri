import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/local_cart_enties/bag_data.entity.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_pos/deposit_pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/deposit_cart/components/order_detail_confirm_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/deposit_cart/components/orders_informations_display.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class DepositCartScreen extends StatefulWidget {
  const DepositCartScreen({super.key});

  @override
  State<DepositCartScreen> createState() => _DepositCartScreenState();
}

class _DepositCartScreenState extends State<DepositCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Panier",
          style: Style.interBold(
            size: 20,
          ),
        ),
        iconTheme: const IconThemeData(),
        backgroundColor: Style.white,
      ),
      backgroundColor: Style.bgColor,
      body: GetBuilder<DepositPosController>(builder: (depositposController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Scrollbar(
                controller: ScrollController(),
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    shrinkWrap: true,
                    itemCount:
                        depositposController.selectbag.bagProducts.length,
                    itemBuilder: (context, index) {
                      List<DepositCartItem> cartItems =
                          depositposController.selectbag.bagProducts;

                      final cartItem = cartItems[index];

                      return OrdersInformationsDisplayComponent(
                        cart: cartItem,
                        delete: () {
                          depositposController.removeItemInBag(cartItem);
                        },
                      );
                    }),
              ),
            ),
            bottomWidget(context, depositposController),
          ],
        );
      }),
    );
  }

  Widget bottomWidget(
      BuildContext context, DepositPosController posController) {
    return Container(
      decoration: const BoxDecoration(
          color: Style.white,
          border: Border(top: BorderSide(width: 0.5, color: Colors.grey))),
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.w, bottom: 50),
      child: Column(
        children: [
          CustomButton(
            background: tajiriDesignSystem.appColors.mainBlue50,
            title: "Ajouter un produit",
            textColor: tajiriDesignSystem.appColors.mainBlue500,
            haveBorder: false,
            radius: 5,
            icon: Icon(
              Icons.add,
              color: tajiriDesignSystem.appColors.mainBlue50,
            ),
            isUnderline: true,
            onPressed: () {
              Get.back();
            },
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 45,
                  child: CustomButton(
                    background: tajiriDesignSystem.appColors.mainBlue500,
                    title: "Enregistrer la commande",
                    isGrised: posController.selectbag.bagProducts.isEmpty,
                    textColor: Style.white,
                    isLoadingColor: Style.white,
                    haveBorder: false,
                    radius: 5,
                    onPressed: () {
                      AppHelpersCommon.showCustomModalBottomSheet(
                        context: context,
                        modal: Obx(() {
                          return OrderConfirmDetailModalComponent(
                            isLoading: posController.createOrderLoading.value,
                            confirmOrder: () {
                              posController.saveOrder(context);
                            },
                          );
                        }),
                        isDarkMode: false,
                        isDrag: true,
                        radius: 12,
                      );
                    },
                  ),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Style.grey100,
                        border: Border.all(
                          color: Style.grey100,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Total (En FCFA)",
                        ),
                        Text(
                          "${posController.calculateBagProductTotal().toInt()}",
                          style: Style.interBold(),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
