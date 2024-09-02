import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/food_variant_list.component.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class FoodVariantAddedList extends StatefulWidget {
  final List<ProductVariant>? productVariant;
  const FoodVariantAddedList({super.key, required this.productVariant});

  @override
  State<FoodVariantAddedList> createState() => _FoodVariantAddedListState();
}

class _FoodVariantAddedListState extends State<FoodVariantAddedList> {
  final RefreshController _controller = RefreshController();
  final PosController posController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    await posController.fetchProducts();
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await posController.fetchProducts();
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          20.verticalSpace,
          widget.productVariant == null || widget.productVariant!.isEmpty
              ? Expanded(
                  child: Container(),
                )
              : Expanded(
                  child: AnimationLimiter(
                  child: SmartRefresher(
                    controller: _controller,
                    enablePullDown: true,
                    enablePullUp: true,
                    onLoading: _onLoading,
                    onRefresh: _onRefresh,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.productVariant!.length,
                            itemBuilder: (BuildContext context, int index) {
                              ProductVariant productVariant =
                                  widget.productVariant![index];
                              return FoodVariantListComponent(
                                  productVariant: productVariant);
                            }),
                      ],
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
