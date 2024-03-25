import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/custom_switch_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class EditFoodTabulationComponent extends StatefulWidget {
  FoodDataEntity foodData;
  EditFoodTabulationComponent({super.key, required this.foodData});

  @override
  State<EditFoodTabulationComponent> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFoodTabulationComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (productsController) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImageUi(
                url: widget.foodData.imageUrl!,
                width: 80.w,
                height: 80.h,
                radius: 10.r,
              ),
              30.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Le produit est-il disponible ?",
                    style: Style.interBold(),
                  ),
                  CustomSwitchButtonComponent(foodData: widget.foodData)
                ],
              ),
              30.verticalSpace,
              containerTextField(
                  "Nom ", "", "${widget.foodData.name}", false, false),
              containerTextField("Description du produit ", "",
                  widget.foodData.description!, false, false),
              containerTextField(
                  "Prix", widget.foodData.price.toString(), "", true, true),
              containerTextField(
                  "Prix d'achat ",
                  widget.foodData.price.toString(),
                  widget.foodData.price.toString(),
                  false,
                  true),
              containerTextField("Catégorie ", "",
                  "${widget.foodData.category?.name}", false, false),
              containerTextField(
                  "Le produit est-il disponible ", "", "Oui", false, false)
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String label, String? optionalLabel, String? hint,
      final Function(String text)? onChange, bool readOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        OutlinedBorderTextFormField(
          labelText: hint,
          onTap: () {},
          label: label,
          obscure: true,
          isFillColor: false,
          fillColor: Style.lightBlueT,
          hintColor: Style.black,
          labelColor: Style.darker,
          haveBorder: true,
          isLabelTextBold: true,
          suffixIcon: SvgPicture.asset("assets/svgs/Create.svg"),
          differBorderColor: Style.light,
          isInterNormal: false,
          borderRaduis: BorderRadius.circular(3),
          isCenterText: false,
          onChanged: onChange,
          readOnly: readOnly,
        ),
      ],
    );
  }

  Widget containerTextField(
      String title, String price, String name, bool isModal, bool isPrice) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Style.light, width: 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Style.interBold(
                      size: 14.sp,
                      color: Style.black,
                    ),
                  ),
                  isPrice
                      ? Text(
                          price.currencyLong(),
                          style: Style.interNormal(
                            size: 12.sp,
                            color: Style.dark,
                          ),
                        )
                      : Text(
                          name,
                          style: Style.interNormal(
                            size: 12.sp,
                            color: Style.dark,
                          ),
                        ),
                ],
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
