import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class EditVariantComponent extends StatefulWidget {
  final ProductVariant foodVariant;
  const EditVariantComponent({
    super.key,
    required this.foodVariant,
  });

  @override
  State<EditVariantComponent> createState() => _EditVariantComponentState();
}

class _EditVariantComponentState extends State<EditVariantComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
        builder: (productsController) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                Text(
                  "Modifier le prix du variant",
                  style: Style.interBold(size: 20.sp, color: Style.darker),
                ),
                Text(
                  "changer le prix du variant",
                  style: Style.interNormal(color: Style.darker, size: 15.sp),
                ),
                24.verticalSpace,
                OutlinedBorderTextFormField(
                  isModal: true,
                  labelText: "combien coûtera le variant ?",
                  hint: "combien coûtera le variant ?",
                  onTap: () {},
                  label: "Prix",
                  labelColor: Style.dark,
                  obscure: true,
                  isFillColor: true,
                  fillColor: Style.lightBlueT,
                  differBorderColor: Style.lightBlueT,
                  hintColor: Style.black,
                  haveBorder: true,
                  isInterNormal: false,
                  inputType: TextInputType.number,
                  suffixIconConstraintsHeight: 65,
                  suffixIconConstraintsWidth: 80,
                  suffixIcon: Container(
                    width: 80.w,
                    height: 65.h,
                    decoration: const BoxDecoration(
                      color: Style.secondaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text(
                        "F CFA",
                        style: Style.interNormal(color: Style.white),
                      ),
                    ),
                  ),
                  borderRaduis: BorderRadius.circular(8),
                  isCenterText: false,
                  onChanged: productsController.setPrice,
                ),
                20.verticalSpace,
                CustomButton(
                  isLoading: productsController.isProductLoading,
                  background: Style.primaryColor,
                  title: 'Valider la modification',
                  textColor: Style.secondaryColor,
                  radius: 5,
                  onPressed: () {
                    Mixpanel.instance.track("Update price", properties: {
                      "ProductID": widget.foodVariant.id,
                      "ProductName": widget.foodVariant.name,
                      "Date": DateTime.now().toString(),
                    });
                    productsController.updateFoodVariantPrice(
                        context, widget.foodVariant);
                  },
                ),
                20.verticalSpace,
              ],
            ));
  }
}
