import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/add_sub_in_cart.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class ShopProductItemComponent extends StatelessWidget {
  final Product? product;
  final VoidCallback addCart;
  final VoidCallback? addCount;
  final VoidCallback? removeCount;
  final bool isAdd;
  final Color? cardColor;
  final int count;

  const ShopProductItemComponent({
    super.key,
    required this.product,
    required this.addCart,
    this.isAdd = false,
    this.count = 0,
    this.addCount,
    this.removeCount,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height - 100,
      margin: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
        color: cardColor ?? Style.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Opacity(
          opacity: product?.quantity == 0
              ? 0.5
              : 1.0, // Set the desired opacity value
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CustomNetworkImageUi(
                    url: product?.imageUrl ?? "",
                    height: 120.h,
                    width: double.infinity,
                    radius: 10.r,
                    mustSaturation: !(product?.quantity == 0),
                  ),
                  const SizedBox.shrink(),
                  Positioned(
                    bottom: 15,
                    left: 10,
                    child: Container(
                      height: 25.h,
                      decoration: BoxDecoration(
                        color: Style.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '${product?.price}'.currencyLong(),
                            style: Style.interNormal(size: 11.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product?.name ?? "",
                      style: Style.interNormal(
                        size: 13.sp,
                        color: Style.titleDark,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
                width: 100.w,
                child: Text(
                  product?.quantity != 0
                      ? product?.quantity != 0
                          ? '${product?.quantity ?? product?.type}  en stock'
                          : 'rupture'
                      : 'rupture',
                  style: Style.interNormal(
                    size: 12.sp,
                    color: product?.quantity == 0 ? Style.dark : Style.dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              isAdd
                  ? AddSubInCartComponent(
                      text: count.toString(),
                      addCount: addCount ?? () {},
                      removeCount: removeCount ?? () {},
                    )
                  : CustomButton(
                      background: Style.primaryColor,
                      title: product?.quantity == 0 ? 'Rupture' : 'Ajouter',
                      radius: 3,
                      textColor: product?.quantity == 0
                          ? Style.dark
                          : Style.secondaryColor,
                      onPressed: product?.quantity == 0 ? null : addCart,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
