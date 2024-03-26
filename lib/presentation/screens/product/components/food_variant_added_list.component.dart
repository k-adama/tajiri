import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant_category.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/food_variant_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/shimmer/food_variant_card.shimmer.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/shimmer_product_list.widget.dart';

class FoodVariantAddedList extends StatefulWidget {
  final List<FoodVariantCategoryEntity> foodVariantCategory;
  const FoodVariantAddedList({super.key, required this.foodVariantCategory});

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
    await posController.fetchFoods();
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await posController.fetchFoods();
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          20.verticalSpace,
          widget.foodVariantCategory.isEmpty //posController.foods.isEmpty
              ?
              // const ShimmerProductListWidget()
              Expanded(
                  child: ListView.builder(
                    itemCount: widget.foodVariantCategory.length,
                    itemBuilder: (context, i) {
                      return const FoodVariantCardShimmer();
                    },
                  ),
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
                            itemCount: widget.foodVariantCategory.length,
                            itemBuilder: (BuildContext context, int index) {
                              FoodVariantCategoryEntity foodVariantCategory =
                                  widget.foodVariantCategory[index];
                              return FoodVariantListComponent(
                                  foodVariantCategory: foodVariantCategory);
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
