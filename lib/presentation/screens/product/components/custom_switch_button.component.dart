import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';
import 'package:tajiri_sdk/src/models/product.model.dart';

class CustomSwitchButtonComponent extends StatefulWidget {
  final Product product;
  const CustomSwitchButtonComponent({super.key, required this.product});

  @override
  State<CustomSwitchButtonComponent> createState() =>
      _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButtonComponent> {
  final ProductsController _productsController = Get.find();

  @override
  void initState() {
    super.initState();
    _productsController.setIsvalaible(widget.product.isAvailable ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
        builder: (productsController) => SizedBox(
              height: 40,
              width: 90,
              child: AnimatedToggleSwitch<bool>.dual(
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
                  productsController.updateProductPrice(
                      context, widget.product, false);
                },

                styleBuilder: (b) => ToggleStyle(
                    indicatorColor: b ? Style.lightBlue : Style.dark),
                textBuilder: (value) => value
                    ? Center(
                        child: Text(
                          'oui',
                          style: Style.interBold(
                              color: Style.lightBlue, size: 14.sp),
                        ),
                      )
                    : Center(
                        child: Text(
                        'non',
                        style: Style.interBold(color: Style.dark, size: 13.sp),
                      )),
              ),
            ));
  }
}
