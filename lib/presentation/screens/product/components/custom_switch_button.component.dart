import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';

class CustomSwitchButtonComponent extends StatefulWidget {
  final FoodDataEntity foodData;
  const CustomSwitchButtonComponent({super.key, required this.foodData});

  @override
  State<CustomSwitchButtonComponent> createState() =>
      _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButtonComponent> {
  final ProductsController _productsController = Get.find();

  @override
  void initState() {
    super.initState();
    _productsController.setIsvalaible(widget.foodData.isAvailable ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
        builder: (productsController) => AnimatedToggleSwitch<bool>.dual(
              current: productsController.isAvailable,
              first: false,
              second: true,
              spacing: 4.0,
              style: ToggleStyle(
                borderColor: Style.transparent,
                backgroundColor: productsController.isAvailable
                    ? Style.secondaryColor
                    : Style.lighter,
              ),
              borderWidth: 4.0,
              //height: 50.h,
              onChanged: (b) {
                setState(() => productsController.setIsvalaible(b));
                productsController.updateFood(context, widget.foodData, false);
              },
              styleBuilder: (b) =>
                  ToggleStyle(indicatorColor: b ? Style.lightBlue : Style.dark),
              textBuilder: (value) => value
                  ? Center(
                      child: Text(
                        'oui',
                        style: Style.interBold(
                            color: Style.lightBlue, size: 15.sp),
                      ),
                    )
                  : Center(
                      child: Text(
                      'non',
                      style: Style.interBold(color: Style.dark, size: 15.sp),
                    )),
            ));
  }
}
