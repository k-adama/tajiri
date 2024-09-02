import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';

class CartOrderItemComponent extends StatelessWidget {
  final MainItemEntity? cartItem;
  final String? symbol;
  final VoidCallback add;
  final VoidCallback remove;
  final bool isActive;
  final bool isOwn;

  const CartOrderItemComponent(
      {super.key,
      required this.add,
      required this.remove,
      required this.cartItem,
      this.isActive = true,
      this.isOwn = true,
      this.symbol});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(10.r),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 220.w) * 5 / 4, //86
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomNetworkImageUi(
                        url: cartItem?.image ?? "",
                        height: 64.h,
                        width: 64.h,
                        radius: 5.r),
                    8.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            cartItem?.name ?? "",
                            style: Style.interNormal(
                              size: 12.sp,
                              color: Style.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        2.verticalSpace,
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            "${cartItem?.price}".currencyLong(),
                            style: Style.interNormal(
                              size: 16.sp,
                              color: Style.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              4.horizontalSpace,
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4.r)),
                    color: Style.white,
                    border: Border.all(color: Style.white, width: 4.w)),
                child: Row(
                  children: [
                    AddOrRemoveButton(onTap: remove, iconData: Icons.remove),
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: Style.lighter,
                          borderRadius: BorderRadius.circular(2)),
                      // padding: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 2),
                      padding:
                          EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                      child: Text(
                        (cartItem?.quantity).toString(),
                        style: Style.interBold(
                          size: 14.sp,
                          color: Style.black,
                        ),
                      ),
                    ),
                    AddOrRemoveButton(onTap: add, iconData: Icons.add),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddOrRemoveButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  const AddOrRemoveButton(
      {super.key, required this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: Style.lighter, borderRadius: BorderRadius.circular(2)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
          child: Icon(
            iconData,
            color: Style.black,
          ),
        ),
      ),
    );
  }
}
