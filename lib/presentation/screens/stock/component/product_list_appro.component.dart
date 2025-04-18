import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/stock_products_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_sdk/src/models/inventory.model.dart';

class ProductListApproComponent extends StatefulWidget {
  List<Inventory> foodInventory;
  ProductListApproComponent({super.key, required this.foodInventory});

  @override
  State<ProductListApproComponent> createState() =>
      _ProductListApproComponentState();
}

class _ProductListApproComponentState extends State<ProductListApproComponent> {
  final bool isDarkMode = LocalStorageService.instance.getAppThemeMode();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Style.white,
      ),
      child: Column(
        children: [
          20.verticalSpace,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.foodInventory.length,
              itemBuilder: (BuildContext context, int index) {
                final product = widget.foodInventory[index];
                return ProductApproComponent(
                    product: product,
                    onTap: () {
                      AppHelpersCommon.showCustomModalBottomSheet(
                        context: context,
                        modal: StockProductModalComponent(
                          foodInventory: product,
                        ),
                        isDarkMode: false,
                        isDrag: true,
                        radius: 12,
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}

class ProductApproComponent extends StatelessWidget {
  final Inventory product;
  final VoidCallback onTap;
  const ProductApproComponent(
      {super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: double.infinity,
        color: Style.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width - 130,
                child: Row(
                  children: [
                    CustomNetworkImageUi(
                      url: product.imageUrl,
                      height: 60.h,
                      width: 60.w,
                      radius: 10,
                    ),
                    6.horizontalSpace,
                    SizedBox(
                      width: (size.width - 130) * 0.70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width - 250,
                            child: Text(
                              product.name,
                              style: Style.interBold(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            product.isAvailable == true
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
                width: (size.width - 125) / 4,
                height: 40.h,
                decoration: BoxDecoration(
                    color: Style.lightBlue,
                    borderRadius: BorderRadius.circular(60)),
                child: Center(
                  child: Text(
                    product.quantity.toString(),
                    style: Style.interBold(
                      size: 14.sp,
                      color: Style.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
