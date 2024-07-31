import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class ProductApproCardComponent extends StatelessWidget {
  final Inventory food;
  final Function(String)? onChanged;
  //final int addValue;
  const ProductApproCardComponent(
      {super.key,
      required this.food,
     //  required this.addValue,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: 120.h,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width - 130.w,
              child: Row(
                children: [
                  CustomNetworkImageUi(
                    url: food.imageUrl,
                    height: 60.h,
                    width: 60.w,
                    radius: 10,
                  ),
                  6.horizontalSpace,
                  SizedBox(
                    width: (size.width - 150) * 0.70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width - 250,
                          child: Text(
                            food.name,
                            style: Style.interBold(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          food.isAvailable == true
                              ? "Disponible"
                              : "Indisponible",
                          style: Style.interNormal(color: Style.dark),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 70.w,
              height: 80.h,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2.w,
                      style: BorderStyle.solid,
                      color: Style.black)),
              child: Column(
                children: [
                  OutlinedBorderTextFormField(
                    onTap: () {},
                    label: "",
                    obscure: true,
                    inputType: TextInputType.number,
                    //  hint: addValue.toString(),
                    hintColor: Style.black,
                    onChanged: onChanged,
                    haveBorder: false,
                    isInterNormal: false,
                    isFillColor: false,
                    isCenterText: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
