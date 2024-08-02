import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/custom_switch_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';
import 'package:tajiri_sdk/src/models/product.model.dart';

class EditFoodTabulationComponent extends StatefulWidget {
  Product product;
  EditFoodTabulationComponent({super.key, required this.product});

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
                url: widget.product.imageUrl!,
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
                  CustomSwitchButtonComponent(product: widget.product)
                ],
              ),
              30.verticalSpace,
              containerTextField(
                  "Nom ", "", "${widget.product.name}", false, false),
              containerTextField("Description du produit ", "",
                  widget.product.description.toString(), false, false),
              containerTextField(
                  "Prix", widget.product.price.toString(), "", true, true),
              containerTextField(
                  "Prix d'achat ",
                  widget.product.price.toString(),
                  widget.product.price.toString(),
                  false,
                  true),
              containerTextField("Catégorie ", "",
                  "${widget.product.category?.name}", false, false),
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
      // onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Style.interNormal(
                size: 12.sp,
                color: Style.dark,
              ),
            ),
            10.verticalSpace,
            isPrice
                ? Text(
                    price.currencyLong(),
                    style: Style.interBold(
                      size: 14.sp,
                      color: Style.black,
                    ),
                  )
                : Text(
                    name,
                    style: Style.interBold(
                      size: 14.sp,
                      color: Style.black,
                    ),
                  ),
            const Divider(
              color: Style.light,
            ),
          ],
        ),
      ),
    );
  }
}
