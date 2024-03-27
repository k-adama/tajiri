import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/product_appro_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/shimmer/product_list.shimmer.dart';

class ProductListApproSaveComponent extends StatefulWidget {
  List<Map<String, dynamic>> foods;
  Function(int quantity, dynamic food) updateQuantity;
  ProductListApproSaveComponent(
      {super.key, required this.foods, required this.updateQuantity});

  @override
  State<ProductListApproSaveComponent> createState() =>
      _ProductListApproSaveComponentState();
}

class _ProductListApproSaveComponentState
    extends State<ProductListApproSaveComponent> {
  final NavigationController navigationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Style.white,
      ),
      child: Column(
        children: [
          6.verticalSpace,
          Expanded(
            child: widget.foods.isEmpty
                ? const ProductListShimmer()
                : Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Style.white,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.foods.length,
                      itemBuilder: (BuildContext context, int index) {
                        final food = widget.foods[index];
                        int addValue = food['quantityAdd'];
                        return ProductApproCardComponent(
                          food: food,
                          addValue: addValue,
                          onChanged: (change) {
                            widget.updateQuantity(int.parse(change), food);
                          },
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
