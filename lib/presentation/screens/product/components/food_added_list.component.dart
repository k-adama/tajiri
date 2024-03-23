import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/food_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/shimmer_product_list.widget.dart';

class FoodAddedListComponent extends StatefulWidget {
  const FoodAddedListComponent({super.key});

  @override
  State<FoodAddedListComponent> createState() => _FoodAddedListComponentState();
}

class _FoodAddedListComponentState extends State<FoodAddedListComponent> {
  final RefreshController _controller = RefreshController();
  final ProductsController productsController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    await productsController.fetchFoods();
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await productsController.fetchFoods();
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Obx(
            () => productsController.foods.isEmpty
                ? const ShimmerProductListWidget()
                : AnimationLimiter(
                    child: Expanded(
                      child: SmartRefresher(
                        controller: _controller,
                        enablePullDown: true,
                        enablePullUp: true,
                        onLoading: _onLoading,
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: productsController.foods.length,
                          itemBuilder: (BuildContext context, int index) {
                            FoodDataEntity food =
                                productsController.foods[index];
                            return InkWell(
                              onTap: () {
                                Get.toNamed(Routes.EDIT_FOOD_AND_VARIANT,
                                    arguments: food);
                              },
                              child: FoodListComponent(
                                url: "${food.imageUrl}",
                                foodName: "${food.name}",
                                foodQuantity: "${food.quantity}",
                                foodCategorieName: "${food.category?.name}",
                                foodPrice: "${food.price ?? 0}",
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
