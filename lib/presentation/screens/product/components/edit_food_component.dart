import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/edit_food_tabulation.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/edit_product_price_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/food_tabulation.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/food_variant_added_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/product_price_modal.component.dart';
import 'package:tajiri_sdk/src/models/product.model.dart';

class EditFoodAndVariantComponent extends StatefulWidget {
  const EditFoodAndVariantComponent({super.key});

  @override
  State<EditFoodAndVariantComponent> createState() =>
      _EditFoodAndVariantComponentState();
}

//typedef ChangeIndexFunction = void Function(int index);

class _EditFoodAndVariantComponentState
    extends State<EditFoodAndVariantComponent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RefreshController _refreshController;
  final Product? foodData = Get.arguments;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        elevation: 0,
      ),
      body: GetBuilder<ProductsController>(
        builder: (_productsController) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130.w,
                        child: Text(
                          "${foodData?.name}",
                          overflow: TextOverflow.ellipsis,
                          style:
                              Style.interBold(color: Style.darker, size: 25.sp),
                        ),
                      ),
                      _tabController.index == 0
                          ? EditProductPriceButtonComponent(
                              title: "Modifier le prix",
                              background: Style.primaryColor,
                              textColor: Style.secondaryColor,
                              onPressed: () {
                                AppHelpersCommon.showCustomModalBottomSheet(
                                  context: context,
                                  modal: ProductPriceModalComponent(
                                    product: foodData!,
                                  ),
                                  isDarkMode: false,
                                  isDrag: true,
                                  radius: 12.r,
                                );
                              },
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              EditFoodTabulation(
                editFoodComponent: EditFoodTabulationComponent(
                  product: foodData!,
                ),
                foodVariantAddedListComponent: FoodVariantAddedList(
                  productVariant: foodData?.variants,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
