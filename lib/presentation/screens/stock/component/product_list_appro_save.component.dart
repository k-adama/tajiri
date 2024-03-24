import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/shimmer_product_list.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class ProductListApproSaveComponent extends StatefulWidget {
  List<Map<String, dynamic>> foods;
  Function(int quantity, dynamic food) updateQuantity;
  ProductListApproSaveComponent(
      {super.key, required this.foods, required this.updateQuantity});

  @override
  State<ProductListApproSaveComponent> createState() => _ProductListApproSaveComponentState();
}

class _ProductListApproSaveComponentState extends State<ProductListApproSaveComponent> {
  final NavigationController navigationController = Get.find();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                ? const ShimmerProductListUi()
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
                        return Container(
                          height: 120.h,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width - 130.w,
                                  child: Row(
                                    children: [
                                      CustomNetworkImageUi(
                                        url: food['imageUrl'] ?? "",
                                        height: 60.h,
                                        width: 60.w,
                                        radius: 10,
                                      ),
                                      6.horizontalSpace,
                                      Container(
                                        width: (size.width - 150) * 0.70,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: size.width - 250,
                                              child: Text(
                                                food['name'] ?? "",
                                                style: Style.interBold(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              food['isAvailable'] == true
                                                  ? "Disponible"
                                                  : "Indisponible",
                                              style: Style.interNormal(
                                                  color: Style.dark),
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
                                        hint: addValue.toString(),
                                        hintColor: Style.black,
                                        onChanged: (change) {
                                          widget.updateQuantity(
                                              int.parse(change), food);
                                        },
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
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
